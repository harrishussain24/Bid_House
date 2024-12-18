// ignore_for_file: must_be_immutable

import 'package:bidhouse/constants.dart';
import 'package:bidhouse/models/adsmodel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AdsDetailsScreen extends StatefulWidget {
  AdsModel adDetails;
  AdsDetailsScreen({super.key, required this.adDetails});

  @override
  State<AdsDetailsScreen> createState() => _AdsDetailsScreenState();
}

class _AdsDetailsScreenState extends State<AdsDetailsScreen> {
  Color color = AppConstants.appColor;
  TextEditingController controller = TextEditingController();

  late Stream<List<AdsModel>> _adsStream;

  @override
  void initState() {
    super.initState();
    //_adsStream = getAllAdsStream(widget.userData.email);
  }

  Stream<List<AdsModel>> getAllAdsStream(String email) {
    return FirebaseFirestore.instance
        .collection('Bids')
        .where("userEmail", isEqualTo: email)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) => AdsModel.fromJson(doc)).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 65,
        backgroundColor: color,
        title: const Text(
          "Details",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 25,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        child: Column(
          children: [
            const SizedBox(
              height: 10,
            ),
            const Text(
              "Total Estimated Cost",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.w500),
            ),
            Text(
              widget.adDetails.totalCost,
              style: const TextStyle(fontSize: 23, fontWeight: FontWeight.bold),
            ),
            displayData("Owner :", widget.adDetails.userName!),
            displayData("City :", widget.adDetails.city),
            displayData("Size :", widget.adDetails.areaSize),
            displayData("Cons. Type :", widget.adDetails.constructionType),
            displayData("Cons. Mode :", widget.adDetails.constructionMode),
            displayData("Floors :", widget.adDetails.floors!),
            const Divider(
              indent: 10,
              endIndent: 10,
            ),
            const Text(
              "Bids on this Ad",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.w500),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 10,
          vertical: 25,
        ),
        decoration: BoxDecoration(
          color: AppConstants.bgColor,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            AppConstants.button(
              buttonHeight: 0.047,
              buttonWidth: 0.37,
              buttonText: "Bid",
              textSize: 20,
              context: context,
              onTap: () {
                forBidding(context);
              },
            ),
            const SizedBox(
              width: 20,
            ),
            AppConstants.button(
              buttonHeight: 0.047,
              buttonWidth: 0.37,
              buttonText: "Chat",
              textSize: 20,
              context: context,
              onTap: () {},
            ),
          ],
        ),
      ),
    );
  }

  forBidding(BuildContext context) {
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
        content: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 5.0),
          child: SizedBox(
            width: MediaQuery.sizeOf(context).width * 0.7,
            child: AppConstants.inputField(
              label: "Amount",
              hintText: "Enter Your Bid",
              controller: controller,
              icon: Icons.money_outlined,
              obsecureText: false,
              keyboardType: TextInputType.number,
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {},
            child: Text(
              "Bid",
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

  Column displayData(
    String key,
    String value,
  ) {
    return Column(
      children: [
        Row(
          children: [
            Text(
              key,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
            ),
            const SizedBox(
              width: 10,
            ),
            Text(
              value,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ],
        ),
        const SizedBox(
          height: 5,
        ),
      ],
    );
  }
}
