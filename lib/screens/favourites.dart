// ignore_for_file: must_be_immutable, unused_local_variable

import 'package:bidhouse/constants.dart';
import 'package:bidhouse/models/adsmodel.dart';
import 'package:bidhouse/models/authenticationModel.dart';
import 'package:bidhouse/screens/adsDetails.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class FavouritesScreen extends StatefulWidget {
  AuthenticationModel userData;
  FavouritesScreen({super.key, required this.userData});

  @override
  State<FavouritesScreen> createState() => _FavouritesScreenState();
}

class _FavouritesScreenState extends State<FavouritesScreen> {
  Color color = AppConstants.appColor;
  String getUserInitials(String name) {
    // Spliting the name into words
    List<String> words =
        name.split(' ').where((word) => word.isNotEmpty).toList();

    String initials;

    if (words.length > 2) {
      // Use the first and last words if more than two
      initials = words.first[0] + words.last[0];
    } else {
      // Use initials of all words
      initials = words.map((word) => word[0]).join();
    }

    return initials;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 65,
        backgroundColor: color,
        title: const Text(
          "Favourites",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 25,
          ),
        ),
        leading: Container(),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection("Favourites")
            .where('userEmail', isEqualTo: widget.userData.email)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          final documents = snapshot.data!.docs;
          if (documents.isEmpty) {
            return Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(
                    'lib/assets/bg1.png',
                  ),
                  fit: BoxFit.cover,
                  opacity: 0.4,
                ),
              ),
              child: const Center(
                child: Text(
                  "No Ads Yet",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
            );
          }
          return Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage(
                  'lib/assets/bg1.png',
                ),
                fit: BoxFit.cover,
                opacity: 0.4,
              ),
            ),
            width: MediaQuery.sizeOf(context).width,
            child: ListView.builder(
              itemCount: documents.length,
              itemBuilder: (context, index) {
                // Convert Firestore data to a map
                Map<String, dynamic> data =
                    documents[index].data() as Map<String, dynamic>;

                // Extract fields
                String userEmail = data['userEmail'] ?? 'No Email';
                Map<String, dynamic> adDetails = data['adDetails'] ?? {};
                String initials = getUserInitials(adDetails['userName']);
                return Container(
                  decoration: const BoxDecoration(
                      border: Border(bottom: BorderSide(width: 0.2))),
                  child: Padding(
                    padding: const EdgeInsets.only(top: 2.0),
                    child: GestureDetector(
                      onTap: () {
                        AdsModel adDet = AdsModel(
                          id: adDetails['id'],
                          city: adDetails['city'] ?? '',
                          areaSize: adDetails['areaSize'] ?? '',
                          floors: adDetails['floors'],
                          constructionType: adDetails['constructionType'] ?? '',
                          constructionMode: adDetails['constructionMode'] ?? '',
                          totalCost: adDetails['totalCost'] ?? '',
                          userId: adDetails['userId'],
                          userName: adDetails['userName'],
                          userEmail: adDetails['userEmail'],
                          userImageUrl: adDetails['userImageUrl'],
                          userPhoneNo: adDetails['userPhoneNo'],
                        );
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AdsDetailsScreen(
                              adDetails: adDet,
                              userData: widget.userData,
                              showFav: true,
                            ),
                          ),
                        );
                      },
                      child: ListTile(
                        leading: ClipOval(
                          child: Container(
                            height: 45,
                            width: 45,
                            decoration: BoxDecoration(
                                border: Border.all(width: 0.2),
                                borderRadius: BorderRadius.circular(25)),
                            child: adDetails['userImageUrl'] != ""
                                ? Image.network(adDetails['userImageUrl'])
                                : Center(
                                    child: Text(
                                    initials,
                                    style: const TextStyle(fontSize: 18),
                                  )),
                          ),
                        ),
                        title: Text(
                          adDetails['city'],
                          style: const TextStyle(
                              fontSize: 19, fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(
                          'Area: ${adDetails['areaSize']}, Floors: ${adDetails['floors']}',
                          style: TextStyle(color: AppConstants.appColor),
                        ), // Replace with your field
                      ),
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
