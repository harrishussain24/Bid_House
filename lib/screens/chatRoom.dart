import 'package:bidhouse/constants.dart';
import 'package:bidhouse/models/chatRoomModel.dart';
import 'package:bidhouse/models/messageModel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

class ChatRoomScreen extends StatefulWidget {
  final ChatRoomModel chatRoom;
  final String ownerName, id, imageUrl;
  const ChatRoomScreen(
      {super.key,
      required this.chatRoom,
      required this.ownerName,
      required this.id,
      required this.imageUrl});

  @override
  State<ChatRoomScreen> createState() => _ChatRoomScreenState();
}

class _ChatRoomScreenState extends State<ChatRoomScreen> {
  TextEditingController messageController = TextEditingController();
  Uuid uuid = const Uuid();
  void sendMessage() async {
    String msg = messageController.text.trim().toString();
    messageController.clear();
    if (msg != "") {
      MessagesModel newMessage = MessagesModel(
        messageId: uuid.v1(),
        sender: widget.id,
        createdOn: DateTime.now(),
        text: msg.toString(),
        seen: false,
      );

      FirebaseFirestore.instance
          .collection("ChatRooms")
          .doc(widget.chatRoom.chatRoomId)
          .collection("messages")
          .doc(newMessage.messageId)
          .set(newMessage.toMap());
      widget.chatRoom.lastMessage = msg;
      widget.chatRoom.messageSendingTime = DateTime.now();
      FirebaseFirestore.instance
          .collection("ChatRooms")
          .doc(widget.chatRoom.chatRoomId)
          .set(widget.chatRoom.toMap());
      print("Message Sent");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 70,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
        ),
        elevation: 10,
        backgroundColor: AppConstants.appColor,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(
              height: 45,
              width: 45,
              child: widget.imageUrl != ""
                  ? ClipOval(
                      child: Image.network(
                        widget.imageUrl,
                        fit: BoxFit.fill,
                        height: 140,
                        width: 140,
                      ),
                    )
                  : Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        border: Border.all(
                          color: Colors.white,
                        ),
                      ),
                      child: const Icon(
                        Icons.person,
                        color: Colors.white,
                      ),
                    ),
            ),
            const SizedBox(
              width: 20,
            ),
            Text(
              widget.ownerName,
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  wordSpacing: 2,
                  letterSpacing: 1),
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection("ChatRooms")
                      .doc(widget.chatRoom.chatRoomId)
                      .collection("messages")
                      .orderBy('createdOn', descending: true)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.active) {
                      if (snapshot.hasData) {
                        QuerySnapshot datasnapshot =
                            snapshot.data as QuerySnapshot;

                        return ListView.builder(
                          reverse: true,
                          itemCount: datasnapshot.docs.length,
                          itemBuilder: ((context, index) {
                            MessagesModel currentMessage =
                                MessagesModel.fromMap(datasnapshot.docs[index]
                                    .data() as Map<String, dynamic>);
                            DateTime dateTime = currentMessage.createdOn!;
                            String formattedTime =
                                DateFormat.jm().format(dateTime);
                            return Row(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment:
                                  (currentMessage.sender == widget.id)
                                      ? MainAxisAlignment.end
                                      : MainAxisAlignment.start,
                              children: [
                                LayoutBuilder(
                                  builder: (BuildContext context,
                                      BoxConstraints constraints) {
                                    return Container(
                                      constraints: BoxConstraints(
                                        minWidth:
                                            MediaQuery.of(context).size.width *
                                                0.2,
                                        maxWidth:
                                            MediaQuery.of(context).size.width *
                                                0.7,
                                      ),
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 15, vertical: 18),
                                      margin: const EdgeInsets.symmetric(
                                          vertical: 2),
                                      decoration: BoxDecoration(
                                        color:
                                            (currentMessage.sender == widget.id)
                                                ? AppConstants.appColor
                                                : AppConstants.bgColor,
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Stack(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                bottom: 18.0),
                                            child: Text(
                                              currentMessage.text.toString(),
                                              textAlign: TextAlign.start,
                                              style: const TextStyle(
                                                fontSize: 15,
                                                color: Colors.black,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                          const SizedBox(height: 15),
                                          Positioned(
                                            bottom: 0,
                                            right: 0,
                                            child: Text(
                                              formattedTime,
                                              style: const TextStyle(
                                                fontSize: 12,
                                                color: Colors.black87,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                ),
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
            Container(
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(color: AppConstants.appColor),
                  right: BorderSide(color: AppConstants.appColor, width: 4),
                  left: BorderSide(color: AppConstants.appColor, width: 4),
                  bottom: BorderSide(color: AppConstants.appColor),
                ),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
              margin: const EdgeInsets.only(top: 10),
              child: Row(
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.78,
                    child: TextField(
                      maxLines: null,
                      controller: messageController,
                      decoration: const InputDecoration(
                          focusedBorder: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          hintText: "Enter Message",
                          border: InputBorder.none),
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      sendMessage();
                    },
                    icon: Icon(Icons.send, color: AppConstants.appColor),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
