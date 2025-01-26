// ignore_for_file: prefer_const_constructors, avoid_print, must_be_immutable

import 'package:bidhouse/constants.dart';
import 'package:bidhouse/firebasehelper.dart';
import 'package:bidhouse/models/authenticationModel.dart';
import 'package:bidhouse/models/chatRoomModel.dart';
import 'package:bidhouse/screens/chatRoom.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ChatsScreen extends StatefulWidget {
  AuthenticationModel? userData;
  ChatsScreen({super.key, required this.userData});

  @override
  State<ChatsScreen> createState() => _ChatsScreenState();
}

class _ChatsScreenState extends State<ChatsScreen> {
  late Stream<List<ChatRoomModel>> _chatsStream;

  Stream<List<ChatRoomModel>> fetchChats(String id) {
    return FirebaseFirestore.instance
        .collection("ChatRooms")
        .where('users', arrayContains: id.toString())
        .orderBy('messageSendingTime', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => ChatRoomModel.fromMap(doc.data()))
          .toList();
    });
  }

  @override
  void initState() {
    _chatsStream = fetchChats(widget.userData!.id!);
    super.initState();
  }

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
      ),
      body: StreamBuilder<List<ChatRoomModel>>(
        stream: _chatsStream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No Chats Found.'));
          } else {
            List<ChatRoomModel> chatsList = snapshot.data!;
            return Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage(
                      'lib/assets/bg2.png',
                    ),
                    fit: BoxFit.cover,
                    opacity: 0.5),
              ),
              width: MediaQuery.sizeOf(context).width,
              height: MediaQuery.sizeOf(context).height,
              child: ListView.builder(
                itemCount: chatsList.length,
                itemBuilder: (context, index) {
                  ChatRoomModel data = chatsList[index];
                  Map<String, dynamic> participant = data.participants!;
                  List<String> participantsKeys = participant.keys.toList();
                  participantsKeys.remove(widget.userData!.id!);
                  return FutureBuilder(
                    future: FireBaseHelper.getUserById(participantsKeys[0]),
                    builder: (context, userData) {
                      if (userData.connectionState == ConnectionState.done) {
                        if (userData.data != null) {
                          AuthenticationModel targetUser =
                              userData.data as AuthenticationModel;
                          String name = targetUser.name.toString();
                          DateTime dateTime = data.messageSendingTime!;
                          String formattedTime =
                              DateFormat.jm().format(dateTime);
                          return Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10.0, vertical: 2.0),
                            child: ListTile(
                              shape: Border(
                                bottom:
                                    BorderSide(color: AppConstants.appColor),
                              ),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ChatRoomScreen(
                                        chatRoom: data,
                                        ownerName: userData.data!.name,
                                        id: userData.data!.id!,
                                        imageUrl: userData.data!.imageUrl!),
                                  ),
                                );
                              },
                              leading: SizedBox(
                                height: 55,
                                width: 55,
                                child: targetUser.imageUrl != ""
                                    ? ClipOval(
                                        child: Image.network(
                                          targetUser.imageUrl!,
                                          fit: BoxFit.fill,
                                          height: 140,
                                          width: 140,
                                        ),
                                      )
                                    : Container(
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(30),
                                          border: Border.all(
                                            color: AppConstants.appColor,
                                          ),
                                        ),
                                        child: Icon(
                                          Icons.person,
                                          color: AppConstants.appColor,
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
                              trailing: Text(formattedTime),
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
                },
              ),
            );
          }
        },
      ),
    );
  }
}
