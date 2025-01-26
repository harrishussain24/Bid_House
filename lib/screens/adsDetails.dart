// ignore_for_file: must_be_immutable, avoid_print, use_build_context_synchronously, file_names

import 'package:bidhouse/constants.dart';
import 'package:bidhouse/models/adsmodel.dart';
import 'package:bidhouse/models/authenticationModel.dart';
import 'package:bidhouse/models/bidModel.dart';
import 'package:bidhouse/models/chatRoomModel.dart';
import 'package:bidhouse/models/favouritesModel.dart';
import 'package:bidhouse/screens/chatRoom.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

class AdsDetailsScreen extends StatefulWidget {
  bool showFav;
  AdsModel adDetails;
  AuthenticationModel userData;
  AdsDetailsScreen(
      {super.key,
      required this.adDetails,
      required this.userData,
      required this.showFav});

  @override
  State<AdsDetailsScreen> createState() => _AdsDetailsScreenState();
}

class _AdsDetailsScreenState extends State<AdsDetailsScreen> {
  Color color = AppConstants.appColor;
  TextEditingController controller = TextEditingController();
  ChatRoomModel? chatRoom;
  bool addedToFav = false;
  Uuid uuid = const Uuid();
  CollectionReference datacollection =
      FirebaseFirestore.instance.collection('Favourites');

  //late Stream<List<AdsModel>> _adsStream;

  @override
  void initState() {
    super.initState();
    if (widget.showFav == true) {
      addedToFav = true;
    }
    //_adsStream = getAllAdsStream(widget.userData.email);
  }

  //saving data to database
  saveToFavourite(FavouritesModel favAd) async {
    try {
      AppConstants.showLoadingDialog(
          context: context, title: "Adding to your Favourites List...!");
      // Getting a new document reference from Firestore
      DocumentReference newDocument = datacollection.doc();
      // Setting the document ID as the ad's ID
      favAd.id = newDocument.id;
      // Converting the ad model to JSON
      var data = favAd.toJson();
      // Saving data to Firestore
      await newDocument.set(data).whenComplete(() {
        Navigator.pop(context);
      });
      // Showing success message
      AppConstants.showAlertDialog(
        context: context,
        title: "Success",
        content: "Added to Your Favourites List...!",
      );
      // Clearing all the values
      setState(() {
        addedToFav = true;
      });
    } catch (error) {
      // Showing error message
      Navigator.pop(context);
      AppConstants.showAlertDialog(
        context: context,
        title: "Error",
        content: error.toString(),
      );
      print('Error: $error');
    }
  }

  sendBid() async {
    num bid = num.parse(controller.text.trim());
    if (bid != 0) {
      BidsModel bidsModel = BidsModel(
        bidId: uuid.v1(),
        bidderName: widget.userData.name,
        bidderEmail: widget.userData.email,
        bid: bid,
        createdOn: DateTime.now(),
      );

      await FirebaseFirestore.instance
          .collection("Ads")
          .doc(widget.adDetails.id)
          .collection("bidsOnAd")
          .doc(bidsModel.bidId)
          .set(bidsModel.toMap());
      print("Bid Sent");
    }
  }

  Future<ChatRoomModel?> getChatRoom(String ownerId, userId) async {
    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection("ChatRooms")
        .where("participants.${userId.toString()}", isEqualTo: true)
        .get();
    if (snapshot.docs.isNotEmpty) {
      print("ChatRoom Exist");
      var docData = snapshot.docs[0].data();
      ChatRoomModel existingChatRoom =
          ChatRoomModel.fromMap(docData as Map<String, dynamic>);
      chatRoom = existingChatRoom;
    } else {
      ChatRoomModel newChatRoom = ChatRoomModel(
        chatRoomId: uuid.v1(),
        lastMessage: "",
        participants: {userId.toString(): true, ownerId.toString(): true},
        createdOn: DateTime.now(),
        messageSendingTime: DateTime.now(),
        users: [userId.toString(), ownerId.toString()],
      );

      await FirebaseFirestore.instance
          .collection("ChatRooms")
          .doc(newChatRoom.chatRoomId)
          .set(newChatRoom.toMap());

      chatRoom = newChatRoom;
      print("ChatRoom created");
    }

    return chatRoom;
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
            const SizedBox(
              height: 10,
            ),
            displayData("Owner :", widget.adDetails.userName!),
            displayData("City :", widget.adDetails.city),
            displayData("Size :", widget.adDetails.areaSize),
            displayData("Cons. Type :", widget.adDetails.constructionType),
            displayData("Cons. Mode :", widget.adDetails.constructionMode),
            displayData("Floors :", widget.adDetails.floors!),
            Align(
              alignment: Alignment.topRight,
              child: addedToFav == false
                  ? TextButton.icon(
                      onPressed: () {
                        var data = widget.adDetails;
                        FavouritesModel fav = FavouritesModel(
                          userEmail: widget.userData.email,
                          adDetails: data,
                        );
                        saveToFavourite(fav);
                      },
                      label: const Text(
                        "Add to Favourite",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      icon: const Icon(
                        Icons.favorite,
                        size: 20,
                      ),
                    )
                  : const Text(
                      "Added to Favourite",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
            ),
            const Divider(),
            const Text(
              "Bids on this Ad",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.w500),
            ),
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection("Ads")
                      .doc(widget.adDetails.id)
                      .collection("bidsOnAd")
                      .orderBy("createdOn", descending: true)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.active) {
                      if (snapshot.hasData) {
                        QuerySnapshot querySnapshot =
                            snapshot.data as QuerySnapshot;

                        return ListView.builder(
                          itemCount: querySnapshot.docs.length,
                          itemBuilder: ((context, index) {
                            BidsModel bidsModel = BidsModel.fromMap(
                                querySnapshot.docs[index].data()
                                    as Map<String, dynamic>);
                            //DateTime dateTime = bidsModel.createdOn!;
                            /*String formattedTime =
                                DateFormat.jm().format(dateTime);*/

                            return Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                SizedBox(
                                  height: 45,
                                  child: ListTile(
                                    contentPadding: const EdgeInsets.symmetric(
                                        horizontal: 16.0, vertical: 0),
                                    title: Text(
                                      bidsModel.bidderName!,
                                      style: const TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    trailing: Text(
                                      "Bid: ${bidsModel.bid.toString()}",
                                      style: const TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                                const Divider(
                                  height: 0,
                                  indent: 10,
                                  endIndent: 10,
                                )
                              ],
                            );
                          }),
                        );
                      } else if (snapshot.hasError) {
                        return const Center(
                          child: Text(
                              "An error occured..! Please check you connection"),
                        );
                      } else {
                        return const Center(
                          child: Text("Say Hi to your friend"),
                        );
                      }
                    } else {
                      return Container();
                    }
                  },
                ),
              ),
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
            widget.userData.userType == "User"
                ? const SizedBox.shrink()
                : AppConstants.button(
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
              buttonHeight: widget.userData.userType == "User" ? 0.06 : 0.047,
              buttonWidth: widget.userData.userType == "User" ? 0.6 : 0.37,
              buttonText: "Chat",
              textSize: 20,
              context: context,
              onTap: () async {
                if (widget.adDetails.userEmail != widget.userData.email) {
                  var chats = await getChatRoom(
                      widget.userData.id!, widget.adDetails.userId);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ChatRoomScreen(
                          chatRoom: chats!,
                          ownerName: widget.adDetails.userName!,
                          id: widget.adDetails.userId!,
                          imageUrl: widget.adDetails.userImageUrl!),
                    ),
                  );
                } else {
                  AppConstants.showAlertDialog(
                      context: context,
                      title: "Error",
                      content: "You cannot Chat with YourSelf");
                }
              },
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
            onPressed: () {
              if (widget.adDetails.userEmail != widget.userData.email) {
                sendBid();
                controller.clear();
                Navigator.pop(context);
              } else {
                AppConstants.showAlertDialog(
                    context: context,
                    title: "Error",
                    content: "You cannot Bid on Your on Ad");
              }
            },
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
