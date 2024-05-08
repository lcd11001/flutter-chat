import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';

part 'user_avatars.freezed.dart';
part 'user_avatars.g.dart';

@freezed
class UserAvatars with _$UserAvatars {
  static const String collectionId = 'user_avatars';

  factory UserAvatars({
    required String id,
    required String avatarUrl,
  }) = _UserAvatars;

  factory UserAvatars.fromJson(Map<String, dynamic> json) =>
      _$UserAvatarsFromJson(json);
}
