import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat/firebase/firebase_auth_helper.dart';
import 'package:chat/firebase/firebase_storage_helper.dart';
import 'package:chat/models/chat_message.dart';
import 'package:flutter/material.dart';

final Map<String, String> _cachedAvatarUrl = {};

class ChatMessageItem extends StatelessWidget {
  final ChatMessage message;

  const ChatMessageItem({
    super.key,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    final bool isMe = message.sender == FirebaseAuthHelper().currentUserUid!;

    final colorScheme = Theme.of(context).colorScheme;

    final textColor = isMe ? colorScheme.onPrimary : colorScheme.onTertiary;
    final bgColor = isMe ? colorScheme.primary : colorScheme.tertiary;
    final columnAlign =
        isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start;
    final textAlign = isMe ? TextAlign.end : TextAlign.start;

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 5.0),
      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
      child: Column(
        crossAxisAlignment: columnAlign,
        children: [
          FutureBuilder(
            future: _getAvatarUrl(message.sender),
            builder: (ctx, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator();
              }

              if (snapshot.hasError) {
                debugPrint('Error: ${snapshot.error}');
                return const Icon(Icons.error);
              }

              final avatarUrl = snapshot.data as String;

              return ClipOval(
                child: CachedNetworkImage(
                  imageUrl: avatarUrl,
                  errorWidget: (context, url, error) => const Icon(Icons.error),
                  placeholder: (context, url) =>
                      const CircularProgressIndicator(),
                  width: 30.0,
                  height: 30.0,
                  fit: BoxFit.cover,
                ),
              );
            },
          ),
          Container(
            margin: const EdgeInsets.symmetric(vertical: 5.0),
            padding: const EdgeInsets.all(10.0),
            decoration: BoxDecoration(
              color: bgColor.withOpacity(0.8),
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: Text(
              message.message,
              style: TextStyle(
                color: textColor,
              ),
              textAlign: textAlign,
            ),
          ),
        ],
      ),
    );
  }

  Future<String> _getAvatarUrl(String sender) async {
    // get the avatar URL from the Firebase Firestore
    if (_cachedAvatarUrl.containsKey(sender)) {
      return _cachedAvatarUrl[sender]!;
    }

    final url =
        await FirebaseStorageHelper().download('user_avatars', '$sender.jpg');
    _cachedAvatarUrl[sender] = url;

    return url;
  }
}
