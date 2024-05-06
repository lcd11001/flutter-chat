import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';

class FirebaseFirestoreHelper {
  // create singleton class
  FirebaseFirestoreHelper._();
  factory FirebaseFirestoreHelper() => _instance;
  static final FirebaseFirestoreHelper _instance = FirebaseFirestoreHelper._();

  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  Future<void> setData(
      String collection, String id, Map<String, dynamic> data) async {
    try {
      await _firebaseFirestore
          .collection(collection)
          .doc(id)
          .set(data, SetOptions(merge: true));
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<void> updateData(
      String collection, String id, Map<String, dynamic> data) async {
    try {
      await _firebaseFirestore.collection(collection).doc(id).update(data);
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<void> deleteData(String collection, String id) async {
    try {
      await _firebaseFirestore.collection(collection).doc(id).delete();
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<List<Map<String, dynamic>>> getData(String collection) async {
    try {
      final snapshot = await _firebaseFirestore.collection(collection).get();
      return snapshot.docs.map((e) => e.data()).toList();
    } catch (e) {
      debugPrint(e.toString());
      return [];
    }
  }
}
