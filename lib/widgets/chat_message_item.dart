import 'package:chat/models/chat_message.dart';
import 'package:flutter/material.dart';

class ChatMessageItem extends StatelessWidget {
  final ChatMessage message;
  final bool isMe;

  const ChatMessageItem({
    super.key,
    required this.message,
    this.isMe = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10.0),
      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
      child: Text("${message.sender}: ${message.message}"),
    );
  }
}
