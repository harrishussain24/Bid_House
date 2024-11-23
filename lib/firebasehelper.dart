import 'package:bidhouse/models/authenticationModel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FireBaseHelper {
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
}
