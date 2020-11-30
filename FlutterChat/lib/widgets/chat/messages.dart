import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import './message_bubble.dart';

class Messages extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: FirebaseAuth.instance.currentUser(),
      builder: (context, auth) {
        if (auth.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }
        return StreamBuilder(
          stream: Firestore.instance
              .collection("chat")
              .orderBy("time", descending: true)
              .snapshots(),
          builder: (ctx, snap) {
            if (snap.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            return ListView.builder(
              reverse: true,
              itemCount: snap.data.documents.length,
              itemBuilder: (ctx, index) {
                return MessageBubble(
                  snap.data.documents[index]["text"],
                  snap.data.documents[index]["uid"] == auth.data.uid,
                  ValueKey(snap.data.documents[index].documentID),
                  snap.data.documents[index]["username"],
                  snap.data.documents[index]["image"],
                );
              },
            );
          },
        );
      },
    );
  }
}
