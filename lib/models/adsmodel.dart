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

  factory AdsModel.fromJson(DocumentSnapshot json) => AdsModel(
        id: json["id"],
        city: json["city"],
        areaSize: json["areaSize"],
        floors: json["floors"],
        constructionType: json["constructionType"],
        constructionMode: json["constructionMode"],
        totalCost: json["totalCost"],
        userId: json["userId"],
        userName: json["userName"],
        userEmail: json["userEmail"],
        userImageUrl: json["userImageUrl"],
        userPhoneNo: json["userPhoneNo"],
      );

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
