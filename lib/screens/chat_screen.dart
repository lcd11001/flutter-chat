import 'package:chat/widgets/chat_message_list.dart';
import 'package:chat/widgets/new_message.dart';
import 'package:flutter/material.dart';

class ChatScreen extends StatelessWidget {
  final String roomId;
  const ChatScreen({super.key, required this.roomId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(roomId),
      ),
      body: Column(
        children: [
          Expanded(
            child: ChatMessageList(
              roomId: roomId,
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
