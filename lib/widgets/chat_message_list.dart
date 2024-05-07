import 'package:chat/models/chat_message.dart';
import 'package:chat/widgets/chat_message_item.dart';
import 'package:flutter/material.dart';

class ChatMessageList extends StatelessWidget {
  final String roomId;

  const ChatMessageList({
    super.key,
    required this.roomId,
  });

  @override
  Widget build(BuildContext context) {
    final messages = [];

    if (messages.isEmpty) {
      return const Center(
        child: Text('No messages found. Start chatting!'),
      );
    }

    return ListView.builder(
      itemCount: messages.length,
      itemBuilder: (context, index) {
        return messages[index];
      },
    );
  }
}
