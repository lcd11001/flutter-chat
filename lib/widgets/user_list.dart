import 'package:chat/firebase/firebase_auth_helper.dart';
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

        debugPrint('snapshot.data!.docs.length: ${snapshot.data!.docs.length}');

        final users = snapshot.data!.docs.where((doc) {
          final data = doc.data();
          final id = data['id'] as String;
          if (id == FirebaseAuthHelper().currentUserUid) {
            return false;
          }
          return true;
        }).map((doc) {
          final data = doc.data();
          debugPrint('data: $data');
          return UserInfo.fromJson(data);
        }).toList();

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
