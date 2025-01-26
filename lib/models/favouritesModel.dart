import 'package:bidhouse/models/adsmodel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FavouritesModel {
  String? id;
  String userEmail;
  AdsModel adDetails;

  FavouritesModel({
    this.id,
    required this.userEmail,
    required this.adDetails,
  });

  factory FavouritesModel.fromJson(DocumentSnapshot json) {
    final data = json.data() as Map<String, dynamic>;
    return FavouritesModel(
      id: json.id, // Firestore document ID
      userEmail: data["userEmail"],
      adDetails: AdsModel.fromJson(data["adDetails"]),
    );
  }

  Map<String, dynamic> toJson() =>
      {"id": id, "userEmail": userEmail, "adDetails": adDetails.toJson()};
}
