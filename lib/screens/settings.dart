// ignore_for_file: must_be_immutable, use_build_context_synchronously, avoid_print

import 'package:bidhouse/constants.dart';
import 'package:bidhouse/localStorageHelper.dart';
import 'package:bidhouse/models/authenticationModel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class SettingScreen extends StatefulWidget {
  AuthenticationModel? userData;
  SettingScreen({super.key, required this.userData});

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  TextEditingController nameController = TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
    print(widget.userData!.id);
    nameController.text = widget.userData!.name;
  }

  Future<void> updateData(AuthenticationModel authModel) async {
    try {
      AppConstants.showLoadingDialog(
          context: context, title: "Updating Your Data");
      final docRef = _firestore.collection('Users').doc(authModel.id);

      // Check if the document exists
      final docSnapshot = await docRef.get();
      if (docSnapshot.exists) {
        // Update the document if it exists
        await docRef.update(authModel.toJson()).whenComplete(() {
          Navigator.pop(context);
          Localstoragehelper.savingDataToStorage(authModel);
          AppConstants.showAlertDialog(
              context: context, title: "Success", content: "Data Updated");
        });
        print('Document updated successfully!');
      } else {
        print('Document not found.');
      }
    } on FirebaseException catch (e) {
      Navigator.pop(context);
      AppConstants.showAlertDialog(
          context: context, title: "Success", content: e.message!);
      print('FirebaseException: ${e.message}');
    } catch (e) {
      Navigator.pop(context);
      AppConstants.showAlertDialog(
          context: context, title: "Success", content: e.toString());
      print('Error updating document: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    Color color = AppConstants.appColor;
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 65,
        backgroundColor: color,
        centerTitle: false,
        title: const Text(
          "Settings",
          style: TextStyle(
            overflow: TextOverflow.ellipsis,
            fontWeight: FontWeight.bold,
            fontSize: 27,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: SafeArea(
            child: Column(
          children: [
            ExpansionTile(
              title: Text(
                "Edit Profile",
                style: TextStyle(
                  color: color,
                  fontSize: 21,
                  fontWeight: FontWeight.bold,
                ),
              ),
              children: [
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    children: [
                      AppConstants.inputField(
                        label: "Name",
                        hintText: "",
                        controller: nameController,
                        icon: Icons.person,
                        obsecureText: false,
                        keyboardType: TextInputType.text,
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      AppConstants.button(
                        buttonWidth: 0.5,
                        buttonHeight: 0.06,
                        onTap: () {
                          AuthenticationModel updatedData = AuthenticationModel(
                            id: widget.userData!.id,
                            name: nameController.text.toString().trim(),
                            email: widget.userData!.email,
                            phoneNo: widget.userData!.phoneNo,
                            userType: widget.userData!.userType,
                            imageUrl: "",
                          );
                          updateData(updatedData);
                        },
                        buttonText: "Update",
                        textSize: 20,
                        context: context,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        )),
      ),
    );
  }
}
