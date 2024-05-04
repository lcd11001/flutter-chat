import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class FirebaseAuthHelper {
  // create singleton class
  FirebaseAuthHelper._();
  factory FirebaseAuthHelper() => _instance;
  static final FirebaseAuthHelper _instance = FirebaseAuthHelper._();

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  Future<User?> createUserWithEmailAndPassword({
    required String email,
    required String password,
    bool forceVerifyEmail = false,
  }) async {
    try {
      final UserCredential userCredential = await _firebaseAuth
          .createUserWithEmailAndPassword(email: email, password: password);

      User? user = userCredential.user;

      if (forceVerifyEmail && user != null && !user.emailVerified) {
        await user.sendEmailVerification();
      }

      return user;
    } on FirebaseAuthException catch (e) {
      debugPrint('FirebaseAuthException: ${e.code} ${e.message}');
      throw Exception(e.message ?? "Sign up failed ${e.code}");
    }
  }

  Future<User?> signInWithEmailAndPassword({
    required String email,
    required String password,
    bool forceVerifyEmail = false,
  }) async {
    try {
      final UserCredential userCredential = await _firebaseAuth
          .signInWithEmailAndPassword(email: email, password: password);

      User? user = userCredential.user;

      if (forceVerifyEmail && user != null && !user.emailVerified) {
        await user.sendEmailVerification();
        await signOut();
        throw Exception("Please verify your email $email first");
      }

      return user;
    } on FirebaseAuthException catch (e) {
      debugPrint('FirebaseAuthException: ${e.code} ${e.message}');
      throw Exception(e.message ?? "Sign in failed ${e.code}");
    }
  }

  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }
}
