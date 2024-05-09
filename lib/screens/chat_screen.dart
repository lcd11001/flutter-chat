import 'package:chat/firebase/firebase_messaging_helper.dart';
import 'package:chat/models/chat_message.dart';
import 'package:chat/widgets/chat_message_list.dart';
import 'package:chat/widgets/new_message.dart';
import 'package:flutter/material.dart';

class ChatScreen extends StatefulWidget {
  final String roomId;
  final String roomTitle;
  const ChatScreen({
    super.key,
    required this.roomId,
    required this.roomTitle,
  });

  @override
  State<StatefulWidget> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  @override
  void initState() {
    super.initState();

    FirebaseMessagingHelper().init().then((_) {
      FirebaseMessagingHelper().subscribe('chat');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.roomTitle),
      ),
      body: Column(
        children: [
          Expanded(
            child: ChatMessageList(
              firestoreCollection:
                  ChatMessage.firestoreCollection(widget.roomId),
              orderField: 'timestamp',
              descending: true,
              reverse: true,
            ),
          ),
          NewMessage(
            roomId: widget.roomId,
          ),
        ],
      ),
    );
  }
}
