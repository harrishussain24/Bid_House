// ignore_for_file: use_build_context_synchronously, avoid_print

import 'package:bidhouse/constants.dart';
import 'package:bidhouse/localStorageHelper.dart';
import 'package:bidhouse/models/authenticationModel.dart';
import 'package:bidhouse/screens/dashboard.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class FireBaseHelper {
  static FirebaseAuth auth = FirebaseAuth.instance;
  static FirebaseFirestore db = FirebaseFirestore.instance;

  //getting user by checking if the user with the id exist
  static Future<AuthenticationModel?> getUserById(String id) async {
    AuthenticationModel? authenticationModel;
    try {
      DocumentSnapshot snapshot =
          await FirebaseFirestore.instance.collection("Users").doc(id).get();

      if (snapshot.exists) {
        authenticationModel = AuthenticationModel.fromJson(snapshot);
      }
    } catch (e) {
      throw Exception('Error Retrieving User');
    }

    return authenticationModel;
  }

  //getting User Data from storage after successfull login
  static Future<AuthenticationModel?> getUserData(String email) async {
    final snapshot =
        await db.collection('Users').where('email', isEqualTo: email).get();
    if (snapshot.docs.isEmpty) {
      print('NO Data');
      return null;
    }
    final userData = AuthenticationModel.fromJson(snapshot.docs.first);
    return userData;
  }

  //checking if the user exist or not
  static Future<bool> checkUserExist(String email, BuildContext context) async {
    final snapshot =
        await db.collection("Users").where("email", isEqualTo: email).get();
    if (snapshot.docs.isEmpty) {
      return true;
    } else {
      AppConstants.showAlertDialog(
          context: context,
          title: "Error",
          content: "User with this email Exist");
    }
    //final userData = AuthenticationModel.fromJson(snapshot.docs.first);
    //return userData;
    return false;
  }

  //logging in
  static Future<void> loginUser(
      {required String email,
      required String password,
      required BuildContext context}) async {
    try {
      AppConstants.showLoadingDialog(context: context, title: "Logging In...!");
      await auth
          .signInWithEmailAndPassword(email: email, password: password)
          .then(
            (value) async => {
              await db
                  .collection("Users")
                  .where('email', isEqualTo: email)
                  .get()
                  .then(
                    (value) {},
                  ),
            },
          )
          .whenComplete(() async {
        final userData = await getUserData(email);
        await Localstoragehelper.savingDataToStorage(userData!);
        print(userData.email);
        Navigator.pop(context);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const Dashboard(),
          ),
        );
      });
    } on FirebaseAuthException catch (e) {
      Navigator.pop(context);
      AppConstants.showAlertDialog(
          context: context, title: "Error", content: e.toString());
    } catch (e) {
      print(e);
    }
  }

  //creating new User
  static Future<void> createUser(
      {required AuthenticationModel authModel,
      required BuildContext context}) async {
    try {
      AppConstants.showLoadingDialog(
          context: context, title: "Creating Your Account");
      UserCredential userCredential = await auth.createUserWithEmailAndPassword(
          email: authModel.email, password: authModel.password);
      authModel.id = userCredential.user!.uid;
      await db.collection("Users").doc(authModel.id).set({
        'id': authModel.id,
        'name': authModel.name,
        'email': authModel.email,
        'phoneNo': authModel.phoneNo,
        'imageUrl': authModel.imageUrl,
        'userType': authModel.userType,
        'password': authModel.password,
      }).whenComplete(() async {
        await Localstoragehelper.savingDataToStorage(authModel);
        print(authModel.email);
        Navigator.pop(context);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => Dashboard(),
          ),
        );
      });
    } on FirebaseAuthException catch (e) {
      Navigator.pop(context);
      AppConstants.showAlertDialog(
          context: context, title: "Error", content: e.toString());
    } catch (e) {
      print(e.toString());
    }
  }
}
