import 'package:chat/models/chat_message.dart';
import 'package:chat/widgets/chat_message_item.dart';
import 'package:chat/widgets/firestore_list.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ChatMessageList extends FirestoreList {
  const ChatMessageList({
    super.key,
    required super.firestoreCollection,
    super.orderField,
    super.descending,
    super.reverse,
  });

  @override
  Widget itemBuilder(BuildContext context, Map<String, dynamic> document,
      Map<String, dynamic>? nextDocument) {
    final message = ChatMessage.fromJson(document);
    final nextMessage =
        nextDocument != null ? ChatMessage.fromJson(nextDocument) : null;

    if (nextMessage != null && message.sender == nextMessage.sender) {
      return ChatMessageItem.next(
        message: message,
      );
    }

    return ChatMessageItem.first(
      message: message,
    );
  }

  /*
  @override
  Iterable<Map<String, dynamic>> sortDocuments(
      List<QueryDocumentSnapshot<Map<String, dynamic>>> documents) {
    documents.sort((a, b) {
      final ChatMessage msgA = ChatMessage.fromJson(a.data());
      final ChatMessage msgB = ChatMessage.fromJson(b.data());

      return msgA.timestamp.compareTo(msgB.timestamp);
    });

    return super.sortDocuments(documents);
  }
  */
}
