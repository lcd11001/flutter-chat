import 'package:flutter/material.dart';

class NewMessage extends StatefulWidget {
  final String chatRoomId;
  const NewMessage({
    super.key,
    required this.chatRoomId,
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
