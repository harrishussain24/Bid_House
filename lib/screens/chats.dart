// ignore_for_file: prefer_const_constructors

import 'package:bidhouse/constants.dart';
import 'package:bidhouse/firebasehelper.dart';
import 'package:bidhouse/models/authenticationModel.dart';
import 'package:bidhouse/models/chatRoomModel.dart';
import 'package:bidhouse/screens/chatRoom.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ChatsScreen extends StatefulWidget {
  const ChatsScreen({super.key});

  @override
  State<ChatsScreen> createState() => _ChatsScreenState();
}

class _ChatsScreenState extends State<ChatsScreen> {
  var chatsList = <ChatRoomModel>[];
  var chats = <AuthenticationModel>[];
  String? id, name;

  Future<void> fetchChats(String id) async {
    print("Fetching chats...");
    try {
      // Fetch data from Firestore once
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection("ChatRooms")
          .where('users', arrayContains: id.toString())
          .orderBy('createdOn', descending: true)
          .get();

      // Process the data
      chatsList = querySnapshot.docs.map((doc) {
        return ChatRoomModel.fromMap(doc.data() as Map<String, dynamic>);
      }).toList();

      print("Chats fetched successfully");
      print(chatsList);
    } catch (error) {
      print("Error fetching Chats collection: $error");
    }
  }

  /*@override
  void initState() {
    fetchChats('');
    super.initState();
  }*/

  @override
  Widget build(BuildContext context) {
    Color color = AppConstants.appColor;
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 65,
        backgroundColor: color,
        title: const Text(
          "Chats",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 25,
          ),
        ),
        leading: Container(),
      ),
      body: chatsList.isEmpty
          ? Center(child: Text('No Chats'))
          : ListView.builder(
              itemCount: chatsList.length,
              itemBuilder: (context, index) {
                ChatRoomModel data = chatsList[index];
                Map<String, dynamic> participant = data.participants!;
                List<String> participantsKeys = participant.keys.toList();
                participantsKeys.remove(id);
                return FutureBuilder(
                  future: FireBaseHelper.getUserById(participantsKeys[0]),
                  builder: (context, userData) {
                    if (userData.connectionState == ConnectionState.done) {
                      if (userData.data != null) {
                        AuthenticationModel targetUser =
                            userData.data as AuthenticationModel;
                        String name = targetUser.name.toString();
                        return Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 15.0, vertical: 2.0),
                          child: ListTile(
                            shape: Border(
                              bottom: BorderSide(color: AppConstants.appColor),
                            ),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ChatRoomScreen(
                                      chatRoom: data,
                                      ownerName: name,
                                      id: id!,
                                      imageUrl: userData.data!.imageUrl!),
                                ),
                              );
                            },
                            leading: SizedBox(
                              height: 55,
                              width: 55,
                              child: ClipOval(
                                child: Image.network(
                                  targetUser.imageUrl!,
                                  fit: BoxFit.fill,
                                  height: 140,
                                  width: 140,
                                ),
                              ),
                            ),
                            title: Text(
                              name,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                            subtitle: (data.lastMessage.toString() != "")
                                ? Text(
                                    data.lastMessage.toString(),
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 15,
                                    ),
                                  )
                                : Text(
                                    "Say Hi to your new Friend",
                                    style: TextStyle(
                                      color: AppConstants.appColor,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 15,
                                    ),
                                  ),
                          ),
                        );
                      } else {
                        return Container();
                      }
                    } else {
                      return Container();
                    }
                  },
                );
              }),
    );
  }
}
