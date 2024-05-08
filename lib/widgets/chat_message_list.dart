import 'package:chat/models/chat_message.dart';
import 'package:chat/widgets/chat_message_item.dart';
import 'package:chat/widgets/firestore_list.dart';
import 'package:flutter/material.dart';

class ChatMessageList extends FirestoreList {
  const ChatMessageList({
    super.key,
    required super.firestoreCollection,
  });

  @override
  Widget itemBuilder(BuildContext context, Map<String, dynamic> document) {
    final message = ChatMessage.fromJson(document);
    return ChatMessageItem(
      message: message,
    );
  }
}
