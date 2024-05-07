import 'package:chat/models/user_info.dart';
import 'package:flutter/material.dart';

class UserList extends StatelessWidget {
  final String firestoreCollection;
  final void Function(UserInfo user) onTap;

  const UserList({
    super.key,
    required this.firestoreCollection,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Text(firestoreCollection);
  }
}
