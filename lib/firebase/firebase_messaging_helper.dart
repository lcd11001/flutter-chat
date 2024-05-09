import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

class FirebaseMessagingHelper {
  FirebaseMessagingHelper._();
  factory FirebaseMessagingHelper() => _instance;
  static final FirebaseMessagingHelper _instance = FirebaseMessagingHelper._();

  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  NotificationSettings? _settings;
  String? _token;

  Future<void> init() async {
    await _requestPermission();
    await _requestToken();
  }

  Future<void> subscribe(String topic) async {
    await _firebaseMessaging.subscribeToTopic(topic);
  }

  Future<void> _requestToken() async {
    _token = await _firebaseMessaging.getToken();
    debugPrint('token: $_token');
  }

  Future<void> _requestPermission() async {
    _settings = await _firebaseMessaging.requestPermission();

    if (_settings!.authorizationStatus == AuthorizationStatus.authorized) {
      debugPrint('User granted permission');
    } else {
      debugPrint('User declined or has not accepted permission');
    }
  }
}
