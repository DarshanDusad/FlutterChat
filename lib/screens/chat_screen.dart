import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../widgets/chat/messages.dart';
import '../widgets/chat/new_message.dart';

class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  void initState() {
    super.initState();
    final fbm = FirebaseMessaging();
    fbm.requestNotificationPermissions();
    fbm.configure();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("FlutterChat"),
        actions: [
          DropdownButton(
            icon: Icon(
              Icons.more_vert,
              color: Colors.white,
            ),
            items: [
              DropdownMenuItem(
                value: "logout",
                child: Row(
                  children: [
                    Icon(
                      Icons.exit_to_app,
                    ),
                    SizedBox(
                      width: 8,
                    ),
                    Text(
                      "LOGOUT",
                    ),
                  ],
                ),
              ),
            ],
            onChanged: (val) {
              FirebaseAuth.instance.signOut();
            },
          )
        ],
      ),
      body: Container(
          child: Column(
        children: [
          Expanded(
            child: Messages(),
          ),
          NewMessage()
        ],
      )),
    );
  }
}
