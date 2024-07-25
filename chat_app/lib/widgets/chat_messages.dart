import 'package:chat_app/widgets/message_bubble.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ChatMessages extends StatelessWidget {
  const ChatMessages({super.key});
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('chats')
            .orderBy('createdAt', descending: true)
            .snapshots(),
        builder: (ctx, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (snapshot.hasError) {
            const Center(
              child: Text('An Error has happend!'),
            );
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            const Center(
              child: Text('No messages yet!'),
            );
          }
          final messages = snapshot.data!.docs;
          return ListView.builder(
            reverse: true,
            padding: const EdgeInsets.only(left: 13, right: 13, bottom: 40),
            itemCount: messages.length,
            itemBuilder: (ctx, index) {
              final chatMessage = messages[index].data();
              final nextChatMessage = index + 1 < messages.length
                  ? messages[index + 1].data()
                  : null;

              final currentMessageUserId = chatMessage['userId'];
              final nextMessageUserId =
                  nextChatMessage != null ? nextChatMessage['userId'] : null;
              final nextUserIsSame = nextMessageUserId == currentMessageUserId;

              if (nextUserIsSame) {
                return MessageBubble.next(
                  message: chatMessage['message'],
                  isMe: FirebaseAuth.instance.currentUser!.uid ==
                      currentMessageUserId,
                );
              } else {
                return MessageBubble.first(
                  userImage: chatMessage['imageurl'],
                  username: chatMessage['username'],
                  message: chatMessage['message'],
                  isMe: FirebaseAuth.instance.currentUser!.uid ==
                      currentMessageUserId,
                );
              }
            },
          );
        });
  }
}
