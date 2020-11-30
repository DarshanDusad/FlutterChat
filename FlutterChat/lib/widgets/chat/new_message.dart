import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class NewMessage extends StatefulWidget {
  @override
  _NewMessageState createState() => _NewMessageState();
}

class _NewMessageState extends State<NewMessage> {
  String message = "";
  TextEditingController _controller = TextEditingController();

  void sendMessage() async {
    FocusScope.of(context).unfocus();
    var user = await FirebaseAuth.instance.currentUser();
    final userData =
        await Firestore.instance.collection("users").document(user.uid).get();
    Firestore.instance.collection("chat").add({
      "text": message,
      "time": Timestamp.now(),
      "uid": user.uid,
      "username": userData["username"],
      "image": userData["image_url"]
    });
    _controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.only(top: 8),
        padding: EdgeInsets.all(8),
        child: Row(
          children: [
            Expanded(
              child: TextField(
                autocorrect: true,
                textCapitalization: TextCapitalization.sentences,
                enableSuggestions: true,
                controller: _controller,
                decoration: InputDecoration(labelText: "Send a message ...."),
                onChanged: (value) {
                  setState(() {
                    message = value;
                  });
                },
              ),
            ),
            IconButton(
              color: Theme.of(context).primaryColor,
              icon: Icon(Icons.send),
              onPressed: message.trim().isEmpty ? null : sendMessage,
            )
          ],
        ));
  }
}
