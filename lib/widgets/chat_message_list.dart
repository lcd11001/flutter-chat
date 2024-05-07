import 'package:chat/widgets/chat_message_item.dart';
import 'package:flutter/material.dart';

class ChatMessageList extends StatelessWidget {
  final List<ChatMessageItem> messages;

  const ChatMessageList({
    super.key,
    required this.messages,
  });

  @override
  Widget build(BuildContext context) {
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
