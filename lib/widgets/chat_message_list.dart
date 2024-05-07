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
    return ListView.builder(
      itemCount: messages.length,
      itemBuilder: (context, index) {
        return messages[index];
      },
    );
  }
}
