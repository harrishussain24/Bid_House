// ignore_for_file: prefer_const_constructors, use_build_context_synchronously, must_be_immutable

import 'package:bidhouse/constants.dart';
import 'package:bidhouse/models/adsmodel.dart';
import 'package:bidhouse/models/authenticationModel.dart';
import 'package:bidhouse/models/chatRoomModel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

class HomeScreen extends StatefulWidget {
  AuthenticationModel userData;
  HomeScreen({super.key, required this.userData});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  ChatRoomModel? chatRoom;
  Uuid uuid = const Uuid();

  late final Stream<List<AdsModel>> _adsStream;

  @override
  void initState() {
    super.initState();
    _adsStream = getAllAdsStream(widget.userData.email);
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

  Stream<List<AdsModel>> getAllAdsStream(String email) {
    return FirebaseFirestore.instance
        .collection('Ads')
        .where("userEmail", isEqualTo: email)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) => AdsModel.fromJson(doc)).toList();
    });
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
            return Center(child: Text('No ads found.'));
          } else {
            List<AdsModel> adsList = snapshot.data!;
            return ListView.builder(
              itemCount: adsList.length,
              itemBuilder: (context, index) {
                AdsModel ad = adsList[index];
                return ListTile(
                  title: Text(ad.city),
                  subtitle: Text('Size: ${ad.areaSize}, Floors: ${ad.floors}'),
                );
              },
            );
          }
        },
      ),
    );
  }
}
