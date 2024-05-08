import 'package:chat/firebase/firebase_firestore_helper.dart';
import 'package:chat/models/user_info.dart';
import 'package:chat/widgets/user_item.dart';
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
    return StreamBuilder(
      stream:
          FirebaseFirestoreHelper().getCollectionStream(firestoreCollection),
      builder: (ctx, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (snapshot.hasError) {
          return const Center(
            child: Text('An error occurred!'),
          );
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Center(
            child: Text('No users found.'),
          );
        }

        final users = snapshot.data!.docs
            .map((doc) => UserInfo.fromJson(doc.data()))
            .toList();

        return ListView.builder(
          itemCount: users.length,
          itemBuilder: (ctx2, index) {
            final user = users[index];
            return UserItem(
              user: user,
              onTap: onTap,
            );
          },
        );
      },
    );
  }
}
