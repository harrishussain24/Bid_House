// ignore_for_file: must_be_immutable, avoid_print, use_build_context_synchronously

import 'package:bidhouse/constants.dart';
import 'package:bidhouse/models/adsmodel.dart';
import 'package:bidhouse/models/authenticationModel.dart';
import 'package:bidhouse/screens/adsDetails.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AdsDisplayScreen extends StatefulWidget {
  final String category;
  AuthenticationModel userData;
  AdsDisplayScreen({super.key, required this.category, required this.userData});

  @override
  State<AdsDisplayScreen> createState() => _AdsDisplayScreenState();
}

class _AdsDisplayScreenState extends State<AdsDisplayScreen> {
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
        backgroundColor: AppConstants.appColor,
        title: widget.category == "My Ads"
            ? Text(
                widget.category,
                style: const TextStyle(fontWeight: FontWeight.bold),
              )
            : const Text(
                'Ads',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: widget.category == "No"
            ? FirebaseFirestore.instance.collection("Ads").snapshots()
            : widget.category == "My Ads"
                ? FirebaseFirestore.instance
                    .collection("Ads")
                    .where('userEmail', isEqualTo: widget.userData.email)
                    .snapshots()
                : FirebaseFirestore.instance
                    .collection("Ads")
                    .where('areaSize', isEqualTo: widget.category)
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
                final doc = documents[index].data() as Map<String, dynamic>;
                String initials = getUserInitials(doc['userName']);
                return Container(
                  decoration: const BoxDecoration(
                      border: Border(bottom: BorderSide(width: 0.2))),
                  child: Padding(
                    padding: const EdgeInsets.only(top: 2.0),
                    child: GestureDetector(
                      onLongPress: () {
                        forDeleting(context, doc['id']);
                      },
                      onTap: () {
                        final adDetails = AdsModel.fromJson(documents[index]);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AdsDetailsScreen(
                              adDetails: adDetails,
                              userData: widget.userData,
                              showFav: false,
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
                            child: doc['userImageUrl'] != ""
                                ? Image.network(doc['userImageUrl'])
                                : Center(
                                    child: Text(
                                    initials,
                                    style: const TextStyle(fontSize: 18),
                                  )),
                          ),
                        ),
                        title: Text(
                          doc['city'],
                          style: const TextStyle(
                              fontSize: 19, fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(
                          'Area: ${doc['areaSize']}, Floors: ${doc['floors']}',
                          style: TextStyle(color: AppConstants.appColor),
                        ),
                        trailing: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Text(
                              "Estimated Cost",
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Text(
                              doc['totalCost'],
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
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

  forDeleting(BuildContext context, String docId) {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Center(
            child: Text(
          "Bidding",
          style: TextStyle(
            color: AppConstants.appColor,
            fontWeight: FontWeight.bold,
            fontSize: 25,
          ),
        )),
        content: const Padding(
          padding: EdgeInsets.symmetric(horizontal: 5.0, vertical: 5.0),
          child: Text("Are you sure you want to delete this Ad...!"),
        ),
        actions: [
          TextButton(
            onPressed: () {
              deleteFavourite(docId);
            },
            child: Text(
              "Yes",
              style: TextStyle(
                color: AppConstants.appColor,
                fontWeight: FontWeight.bold,
                fontSize: 17,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> deleteFavourite(String documentId) async {
    try {
      // Reference to the Firestore collection
      CollectionReference favouritesCollection =
          FirebaseFirestore.instance.collection('Ads');

      // Delete the document by its ID
      await favouritesCollection.doc(documentId).delete();

      print("Document with ID $documentId deleted successfully.");
      Navigator.pop(context);
      AppConstants.showAlertDialog(
          context: context,
          title: "Success",
          content: "Ad Deleted Successfully");
    } catch (error) {
      print("Error deleting document: $error");
    }
  }
}
