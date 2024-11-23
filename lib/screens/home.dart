// ignore_for_file: prefer_const_constructors

import 'package:bidhouse/constants.dart';
import 'package:bidhouse/models/chatRoomModel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  ChatRoomModel? chatRoom;
  Uuid uuid = const Uuid();

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
      body: Center(
        child: TextButton(
          onPressed: () {},
          child: Text("Checking Chats"),
        ),
      ),
    );
  }
}
