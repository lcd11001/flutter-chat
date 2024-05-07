import 'package:chat/models/user_info.dart';
import 'package:flutter/material.dart';

class UserItem extends StatelessWidget {
  final UserInfo user;
  final void Function(UserInfo user) onTap;

  const UserItem({
    super.key,
    required this.user,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        radius: 30.0,
        backgroundImage: NetworkImage(user.avatarUrl),
      ),
      title: Text(user.name),
      subtitle: Text(user.email),
      onTap: () => onTap(user),
    );
  }
}
