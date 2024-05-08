import 'package:chat/firebase/firebase_auth_helper.dart';
import 'package:chat/models/chat_message.dart';
import 'package:flutter/material.dart';

class ChatMessageItem extends StatelessWidget {
  final ChatMessage message;

  const ChatMessageItem({
    super.key,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    bool isMe = message.sender == FirebaseAuthHelper().currentUserUid!;

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10.0),
      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
      child: Text(
        "${message.sender}: ${message.message}",
        style: TextStyle(
          color: isMe ? Colors.black : Colors.white,
          backgroundColor: isMe ? Colors.grey[300] : Colors.blue,
        ),
        textAlign: isMe ? TextAlign.end : TextAlign.start,
      ),
    );
  }
}
