import 'dart:async';

import 'package:chat_app/Screeens/LoginScreen.dart';
import 'package:chat_app/Screeens/WelcomeScreen.dart';
import 'package:chat_app/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class chatScreen extends StatefulWidget {
  static const id = "chatScreen";

  const chatScreen({Key? key}) : super(key: key);

  @override
  State<chatScreen> createState() => _chatScreenState();
}

class _chatScreenState extends State<chatScreen> {
  FirebaseAuth auth = FirebaseAuth.instance;
  late User user;
  TextEditingController controller = TextEditingController();
  final fireStore = FirebaseFirestore.instance;
  String? typingid;
  late Timer _timer;

  void getCurrentUser() {
    user = auth.currentUser!;
  }

  // void getMessages() async {
  //   messages = await fireStore.collection("messeges").get();
  //   setState(() {});
  //   for (var item in messages.docs) {
  //     print(item["text"]);
  //   }
  // }

  @override
  void initState() {
    getCurrentUser();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.lightBlueAccent,
        leading: null,
        actions: [
          Text("${user.email}"),
          IconButton(
              onPressed: () {
                auth.signOut();
                Navigator.pushNamedAndRemoveUntil(
                    context, loginScreen.id, (route) => false);
              },
              icon: Icon(Icons.logout))
        ],
        title: Row(children: [
          Image.asset(
            "images/messenger.png",
            cacheWidth: 50,
          ),
          Text(
            "Messenger",
            style: TextStyle(fontSize: 15),
          )
        ]),
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            StreamBuilder(
                stream: fireStore.collection("typing_user").snapshots(),
                builder: (context, snapShot) {
                  if (snapShot.hasData) {
                    List<dynamic> users = snapShot.data!.docs;
                    return ListView.builder(
                        reverse: true,
                        shrinkWrap: true,
                        itemCount: users.length,
                        itemBuilder: (context, index) {
                          if (users[index]['user'] != user.email) {
                            return Container(
                                color: Colors.amberAccent,
                                child: Text('${users[index]['user']}'));
                          }
                          return SizedBox();
                        });
                  }
                  return SizedBox(
                    height: 5,
                  );
                }),
            StreamBuilder(
                stream: fireStore
                    .collection("messeges")
                    .orderBy("time", descending: true)
                    .snapshots(),
                builder: (context, snapShot) {
                  if (snapShot.hasData) {
                    List<dynamic> messages = snapShot.data!.docs;
                    return Expanded(
                      child: ListView.builder(
                          shrinkWrap: true,
                          reverse: true,
                          itemCount: messages.length,
                          itemBuilder: (context, index) {
                            return messageBubble(
                                messages: messages,
                                index: index,
                                sender: user.email!,
                                isMe: messages[index]["sender"] == user.email);
                          }),
                    );
                  }
                  return Text("Loading Data....");
                }),
            Text(""),
            Container(
              decoration: MessageContainerStyle,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                      child: TextField(
                    controller: controller,
                    decoration: MessageTextField,
                    onChanged: (value) async {
                      if (_timer?.isActive ?? false) _timer?.cancel();
                      _timer =
                          Timer(const Duration(milliseconds: 500), () async {
                        if (value.isNotEmpty) {
                          if (typingid == null) {
                            final ref = await fireStore
                                .collection('typing_users')
                                .add({'user': user.email});
                            typingid = ref.id;
                          }
                        } else if (controller.text.isEmpty) {
                          fireStore
                              .collection('typing_users')
                              .doc(typingid)
                              .delete();
                          typingid = null;
                        }
                      });
                    },
                  )),
                  IconButton(
                      onPressed: () {
                        fireStore.collection("messeges").add({
                          "text": controller.text,
                          "sender": user.email,
                          "time": DateTime.now()
                        });
                        controller.clear();
                      },
                      icon: Icon(
                        Icons.send,
                        color: Colors.lightBlueAccent,
                      ))
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class messageBubble extends StatelessWidget {
  messageBubble(
      {Key? key,
      required this.messages,
      required this.index,
      required this.sender,
      required this.isMe})
      : super(key: key);

  final List messages;
  final int index;
  final String sender;
  final bool isMe;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(8),
      child: Column(
        crossAxisAlignment:
            isMe ? CrossAxisAlignment.start : CrossAxisAlignment.end,
        children: [
          Text(
            "${sender}",
            style: TextStyle(fontSize: 10),
          ),
          SizedBox(
            height: 8,
          ),
          Material(
            color: isMe ? Colors.blue : Colors.lightBlueAccent,
            borderRadius: isMe
                ? BorderRadius.only(
                    topRight: Radius.circular(10),
                    bottomLeft: Radius.circular(10),
                    bottomRight: Radius.circular(10))
                : BorderRadius.only(
                    topLeft: Radius.circular(10),
                    bottomLeft: Radius.circular(10),
                    bottomRight: Radius.circular(10)),
            child: Padding(
              padding: EdgeInsets.all(8),
              child: Text(
                "${messages[index]["text"]}",
                style: TextStyle(fontSize: 24),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
