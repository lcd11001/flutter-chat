import 'package:chat/models/chat_message.dart';
import 'package:chat/widgets/chat_message_list.dart';
import 'package:chat/widgets/new_message.dart';
import 'package:flutter/material.dart';

class ChatScreen extends StatelessWidget {
  final String roomId;
  final String roomTitle;
  const ChatScreen({
    super.key,
    required this.roomId,
    required this.roomTitle,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(roomTitle),
      ),
      body: Column(
        children: [
          Expanded(
            child: ChatMessageList(
              firestoreCollection: ChatMessage.firestoreCollection(roomId),
              orderField: 'timestamp',
              descending: true,
              reverse: true,
            ),
          ),
          NewMessage(
            roomId: roomId,
          ),
        ],
      ),
    );
  }
}
