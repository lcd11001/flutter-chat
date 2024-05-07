import 'package:flutter/material.dart';

class NewMessage extends StatefulWidget {
  final String chatRoomId;
  const NewMessage(this.chatRoomId, {super.key});

  @override
  State<StatefulWidget> createState() => _NewMessageState();
}

class _NewMessageState extends State<NewMessage> {
  final _messageController = TextEditingController();

  void _sendMessage() {
    if (_messageController.text.isEmpty) {
      return;
    }
    FocusScope.of(context).unfocus();
    debugPrint(widget.chatRoomId);
    debugPrint(_messageController.text);
    _messageController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 8.0),
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _messageController,
              decoration: const InputDecoration(labelText: 'Send a message...'),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.send),
            onPressed: _sendMessage,
          ),
        ],
      ),
    );
  }
}
