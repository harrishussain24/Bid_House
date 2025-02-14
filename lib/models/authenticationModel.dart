// ignore_for_file: file_names

import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

AuthenticationModel authenticationFromJson(String str) =>
    AuthenticationModel.fromJson(json.decode(str));

String authenticationToJson(AuthenticationModel data) =>
    json.encode(data.toJson());

class AuthenticationModel {
  String? id;
  String name;
  String email;
  String phoneNo;
  String? imageUrl;
  String userType;

  AuthenticationModel({
    this.id,
    required this.name,
    required this.email,
    required this.phoneNo,
    this.imageUrl,
    required this.userType,
  });

  factory AuthenticationModel.fromJson(DocumentSnapshot json) =>
      AuthenticationModel(
        id: json["id"],
        name: json["name"],
        email: json["email"],
        phoneNo: json["phoneNo"],
        imageUrl: json["imageUrl"],
        userType: json["userType"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "email": email,
        "phoneNo": phoneNo,
        "imageUrl": imageUrl,
        "userType": userType,
      };
}
