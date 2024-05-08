import 'package:chat/firebase/firebase_firestore_helper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

abstract class FirestoreList extends StatelessWidget {
  final String firestoreCollection;
  final String? orderField;
  final bool descending;
  final bool reverse;

  const FirestoreList({
    super.key,
    required this.firestoreCollection,
    this.orderField,
    this.descending = false,
    this.reverse = false,
  });

  Widget itemBuilder(BuildContext context, Map<String, dynamic> document,
      Map<String, dynamic>? nextDocument);

  Iterable<Map<String, dynamic>> sortDocuments(
      List<QueryDocumentSnapshot<Map<String, dynamic>>> documents) {
    return documents.map((e) => e.data());
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: orderField != null
          ? FirebaseFirestoreHelper().getCollectionStreamWithOrder(
              firestoreCollection, orderField!, descending)
          : FirebaseFirestoreHelper().getCollectionStream(firestoreCollection),
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
            child: Text('No data found.'),
          );
        }

        final documents = sortDocuments(snapshot.data!.docs);

        return ListView.builder(
          reverse: reverse,
          itemCount: documents.length,
          itemBuilder: (ctx2, index) {
            final document = documents.elementAt(index);
            final nextDocument = index + 1 < documents.length
                ? documents.elementAt(index + 1)
                : null;
            return itemBuilder(ctx2, document, nextDocument);
          },
        );
      },
    );
  }
}
