import 'package:chat/firebase/firebase_auth_helper.dart';
import 'package:chat/firebase/firebase_firestore_helper.dart';
import 'package:chat/models/chat_message.dart';
import 'package:chat/models/user_info.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class NewMessage extends StatefulWidget {
  final String roomId;
  const NewMessage({
    super.key,
    required this.roomId,
  });

  @override
  State<StatefulWidget> createState() => _NewMessageState();
}

class _NewMessageState extends State<NewMessage> {
  final _messageController = TextEditingController();

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  void _sendMessage() {
    final message = _messageController.text.trim();
    // close the keyboard
    FocusScope.of(context).unfocus();
    _messageController.clear();

    _submitMessage(message);
  }

  Future<void> _submitMessage(String message) async {
    if (message.isEmpty) {
      return;
    }

    final userId = FirebaseAuthHelper().currentUserUid!;
    final userInfo =
        await FirebaseFirestoreHelper().getDocument('users', userId);
    debugPrint('user info: $userInfo');
    userInfo['id'] = userId;

    final user = UserInfo.fromJson(userInfo);
    debugPrint('user: $user');

    final chatMessage = ChatMessage(
      sender: user.id,
      message: message,
      timestamp: Timestamp.now(),
    );

    final success = await FirebaseFirestoreHelper().addDocument(
      'chatRooms/${widget.roomId}/messages',
      chatMessage.toJson(),
    );
    debugPrint('send chat message success: $success');
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      margin: const EdgeInsets.only(top: 8.0),
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _messageController,
              textCapitalization: TextCapitalization.sentences,
              autocorrect: true,
              keyboardType: TextInputType.text,
              decoration: const InputDecoration(labelText: 'Send a message...'),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.send),
            color: colorScheme.primary,
            onPressed: _sendMessage,
          ),
        ],
      ),
    );
  }
}
