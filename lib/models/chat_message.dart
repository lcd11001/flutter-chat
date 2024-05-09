import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';

// run this command in terminal to generate chat_message.freezed.dart
// flutter pub run build_runner build --delete-conflicting-outputs
part 'chat_message.freezed.dart';
part 'chat_message.g.dart';

@freezed
class ChatMessage with _$ChatMessage {
  static String fcmTopicPrefix(String roomId) => 'fcm/chatRooms/$roomId';

  static String firestoreCollection(String roomId) =>
      'chatRooms/$roomId/messages';

  factory ChatMessage({
    required String sender,
    required String message,
    @TimestampConverter() required Timestamp timestamp,
  }) = _ChatMessage;

  factory ChatMessage.fromJson(Map<String, dynamic> json) =>
      _$ChatMessageFromJson(json);
}

class TimestampConverter extends JsonConverter<Timestamp, int> {
  const TimestampConverter();

  @override
  Timestamp fromJson(int json) {
    return Timestamp.fromMillisecondsSinceEpoch(json);
  }

  @override
  int toJson(Timestamp object) {
    return object.millisecondsSinceEpoch;
  }
}
