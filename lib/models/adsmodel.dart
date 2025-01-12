// ignore_for_file: file_names

import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

AdsModel adsFromJson(String str) => AdsModel.fromJson(json.decode(str));

String adsToJson(AdsModel data) => json.encode(data.toJson());

class AdsModel {
  String id;
  String city;
  String areaSize;
  String? floors;
  String constructionType;
  String constructionMode;
  String totalCost;
  String? userId;
  String? userName;
  String? userEmail;
  String? userImageUrl;
  String? userPhoneNo;

  AdsModel({
    required this.id,
    required this.city,
    required this.areaSize,
    required this.floors,
    required this.constructionType,
    required this.constructionMode,
    required this.totalCost,
    this.userId,
    this.userName,
    this.userEmail,
    this.userImageUrl,
    this.userPhoneNo,
  });

  factory AdsModel.fromJson(DocumentSnapshot json) {
    final data = json.data() as Map<String, dynamic>;
    return AdsModel(
      id: json.id, // Firestore document ID
      city: data["city"] ?? '',
      areaSize: data["areaSize"] ?? '',
      floors: data["floors"],
      constructionType: data["constructionType"] ?? '',
      constructionMode: data["constructionMode"] ?? '',
      totalCost: data["totalCost"] ?? '',
      userId: data["userId"],
      userName: data["userName"],
      userEmail: data["userEmail"],
      userImageUrl: data["userImageUrl"],
      userPhoneNo: data["userPhoneNo"],
    );
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "city": city,
        "areaSize": areaSize,
        "floors": floors,
        "constructionType": constructionType,
        "constructionMode": constructionMode,
        "totalCost": totalCost,
        "userId": userId,
        "userName": userName,
        "userEmail": userEmail,
        "userImageUrl": userImageUrl,
        "userPhoneNo": userPhoneNo,
      };
}
