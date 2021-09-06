import 'package:chat_app/widgets/chat/message_bubble.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Messages extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: FirebaseAuth.instance.currentUser(),
      builder: (ctx, futureSnap) {
        if (futureSnap.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        return StreamBuilder(
            stream: Firestore.instance
                .collection('chat')
                .orderBy(
                  'timestamp',
                  descending: true,
                )
                .snapshots(),
            builder: (ctx, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
              final chatDocs = snapshot.data.documents;
              return ListView.builder(
                reverse: true,
                itemCount: chatDocs.length,
                itemBuilder: (ctx, idx) => MessageBubble(
                  msg: chatDocs[idx]['text'],
                  isMe: (chatDocs[idx]['userId'] == futureSnap.data.uid),
                  key: ValueKey(chatDocs[idx].documentID),
                  username: chatDocs[idx]['username'],
                  userImage: chatDocs[idx]['userImage'],
                ),
              );
            });
      },
    );
  }
}
