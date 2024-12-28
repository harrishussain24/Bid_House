// ignore_for_file: prefer_const_constructors, use_build_context_synchronously, must_be_immutable

import 'package:bidhouse/constants.dart';
import 'package:bidhouse/models/adsmodel.dart';
import 'package:bidhouse/models/authenticationModel.dart';
import 'package:bidhouse/screens/adsDetails.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  AuthenticationModel userData;
  HomeScreen({super.key, required this.userData});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Stream<List<AdsModel>> _adsStream;

  @override
  void initState() {
    super.initState();
    if (widget.userData.userType == "Bidder") {
      _adsStream = getAllAdsStream();
    } else {
      _adsStream = getSpecificAdsStream(widget.userData.email);
    }
  }

  Stream<List<AdsModel>> getAllAdsStream() {
    return FirebaseFirestore.instance
        .collection('Ads')
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) => AdsModel.fromJson(doc)).toList();
    });
  }

  Stream<List<AdsModel>> getSpecificAdsStream(String email) {
    return FirebaseFirestore.instance
        .collection('Ads')
        .where("userEmail", isEqualTo: email)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) => AdsModel.fromJson(doc)).toList();
    });
  }

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
    Color color = AppConstants.appColor;
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 65,
        backgroundColor: color,
        title: const Text(
          "Home",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 25,
          ),
        ),
        leading: Container(),
      ),
      body: StreamBuilder<List<AdsModel>>(
        stream: _adsStream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No Ads Found.'));
          } else {
            List<AdsModel> adsList = snapshot.data!;
            return ListView.builder(
              itemCount: adsList.length,
              itemBuilder: (context, index) {
                AdsModel ad = adsList[index];
                String initials = getUserInitials(ad.userName!);
                return Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 2.0),
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => AdsDetailsScreen(
                                adDetails: ad,
                                userData: widget.userData,
                              ),
                            ),
                          );
                        },
                        child: ListTile(
                          leading: Container(
                            height: 45,
                            width: 45,
                            decoration: BoxDecoration(
                                border: Border.all(width: 0.2),
                                borderRadius: BorderRadius.circular(25)),
                            child: ad.userImageUrl != ""
                                ? Image.network(ad.userImageUrl!)
                                : Center(
                                    child: Text(
                                    initials,
                                    style: TextStyle(fontSize: 18),
                                  )),
                          ),
                          title: Text(
                            ad.city,
                            style: TextStyle(
                                fontSize: 19, fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text(
                            'Area: ${ad.areaSize}, Floors: ${ad.floors}',
                            style: TextStyle(color: color),
                          ),
                          trailing: Padding(
                            padding: const EdgeInsets.only(top: 5.0),
                            child: Column(
                              children: [
                                Text(
                                  "Estimated Cost",
                                  style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  ad.totalCost,
                                  style: TextStyle(
                                      fontSize: 19,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    Divider(
                      indent: 10,
                      endIndent: 10,
                    ),
                  ],
                );
              },
            );
          }
        },
      ),
    );
  }
}
