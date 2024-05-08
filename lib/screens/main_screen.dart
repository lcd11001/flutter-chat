import 'package:chat/firebase/firebase_auth_helper.dart';
import 'package:chat/models/user_info.dart';
import 'package:chat/screens/chat_screen.dart';
import 'package:chat/utils/page_route_helper.dart';
import 'package:chat/widgets/user_list.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

const uuid = Uuid();

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
      body: UserList(
        firestoreCollection: 'users',
        onTap: (user) {
          debugPrint('User tapped: ${user.name}');
          _openChatScreen(context, user);
        },
      ),
    );
  }

  void _openChatScreen(BuildContext context, UserInfo user) {
    Navigator.of(context).push(
      PageRouteHelper.slideInRoute(
        ChatScreen(
          roomId: _getRoomId(user),
          roomTitle: user.name,
        ),
      ),
    );
  }

  _getRoomId(UserInfo user) {
    final me = FirebaseAuthHelper().currentUserUid!;
    final friend = user.id;
    final roomId = me.compareTo(friend) > 0 ? '$friend-$me' : '$me-$friend';
    final namespace = uuid.v5(Uuid.NAMESPACE_NIL, roomId);
    debugPrint('Room ID: $namespace');
    return namespace;
  }
}
