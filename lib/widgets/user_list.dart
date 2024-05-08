import 'package:chat/firebase/firebase_auth_helper.dart';
import 'package:chat/models/user_info.dart';
import 'package:chat/widgets/firestore_list.dart';
import 'package:chat/widgets/user_item.dart';
import 'package:flutter/material.dart';

class UserList extends FirestoreList {
  final void Function(UserInfo user) onTap;

  const UserList({
    super.key,
    super.orderField,
    super.descending,
    super.reverse,
    required super.firestoreCollection,
    required this.onTap,
  });

  @override
  Widget itemBuilder(BuildContext context, Map<String, dynamic> document,
      Map<String, dynamic>? nextDocument) {
    final user = UserInfo.fromJson(document);
    if (user.id == FirebaseAuthHelper().currentUserUid) {
      return const SizedBox.shrink();
    }
    return UserItem(
      user: user,
      onTap: onTap,
    );
  }
}
