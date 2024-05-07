import 'package:chat/firebase/firebase_auth_helper.dart';
import 'package:chat/widgets/chat_message_list.dart';
import 'package:chat/widgets/new_message.dart';
import 'package:flutter/material.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter Chat'),
        actions: [
          IconButton(
            icon: Icon(
              Icons.logout,
              color: colorScheme.primary,
              size: 30.0,
            ),
            onPressed: () async {
              await FirebaseAuthHelper().signOut();
            },
          ),
        ],
      ),
      body: const Column(
        children: [
          Expanded(
            child: ChatMessageList(
              messages: [],
            ),
          ),
          NewMessage(
            chatRoomId: 'chatRoomId',
          ),
        ],
      ),
    );
  }
}
