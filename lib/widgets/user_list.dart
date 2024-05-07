import 'package:chat/models/user_info.dart';
import 'package:flutter/material.dart';

class UserList extends StatelessWidget {
  final List<UserInfo> users;
  final void Function(UserInfo user) onTap;

  const UserList({
    super.key,
    required this.users,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    throw UnimplementedError();
  }
}
