import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';

class FirebaseFirestoreHelper {
  // create singleton class
  FirebaseFirestoreHelper._();
  factory FirebaseFirestoreHelper() => _instance;
  static final FirebaseFirestoreHelper _instance = FirebaseFirestoreHelper._();

  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  Future<bool> setData(
      String collection, String id, Map<String, dynamic> data) async {
    try {
      await _firebaseFirestore
          .collection(collection)
          .doc(id)
          .set(data, SetOptions(merge: true));
      return true;
    } catch (e) {
      debugPrint(e.toString());
    }
    return false;
  }

  Future<bool> updateData(
      String collection, String id, Map<String, dynamic> data) async {
    try {
      await _firebaseFirestore.collection(collection).doc(id).update(data);
      return true;
    } catch (e) {
      debugPrint(e.toString());
    }
    return false;
  }

  Future<bool> deleteData(String collection, String id) async {
    try {
      await _firebaseFirestore.collection(collection).doc(id).delete();
      return true;
    } catch (e) {
      debugPrint(e.toString());
    }
    return false;
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

  Future<Map<String, dynamic>> getDocument(String collection, String id) async {
    try {
      final snapshot =
          await _firebaseFirestore.collection(collection).doc(id).get();
      return snapshot.data() ?? {};
    } catch (e) {
      debugPrint(e.toString());
      return {};
    }
  }

  Future<bool> addDocument(String collection, Map<String, dynamic> data) async {
    try {
      await _firebaseFirestore.collection(collection).add(data);
      return true;
    } catch (e) {
      debugPrint(e.toString());
    }
    return false;
  }
}
