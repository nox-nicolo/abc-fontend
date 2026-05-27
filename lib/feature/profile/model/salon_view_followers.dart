import 'dart:convert';

import 'package:africa_beuty/core/utils/image_url.dart';

class SalonFollowersResponseModel {
  final int count;
  final List<SalonFollowerItemModel> items;
  final String? nextCursor;

  SalonFollowersResponseModel({
    required this.count,
    required this.items,
    this.nextCursor,
  });

  Map<String, dynamic> toMap() {
    return {
      'count': count,
      'items': items.map((x) => x.toMap()).toList(),
      'next_cursor': nextCursor,
    };
  }

  factory SalonFollowersResponseModel.fromMap(Map<String, dynamic> map) {
    return SalonFollowersResponseModel(
      count: map['count'] ?? 0,
      items: map['items'] is List
          ? List<SalonFollowerItemModel>.from(
              (map['items'] as List).map(
                (x) => SalonFollowerItemModel.fromMap(x),
              ),
            )
          : [],
      nextCursor: map['next_cursor'],
    );
  }

  String toJson() => json.encode(toMap());

  factory SalonFollowersResponseModel.fromJson(String source) =>
      SalonFollowersResponseModel.fromMap(json.decode(source));
}

class SalonFollowerItemModel {
  final String userId;
  final String username;
  final String name;
  final String? avatar;
  final bool isFollowing;

  SalonFollowerItemModel({
    required this.userId,
    required this.username,
    required this.name,
    this.avatar,
    required this.isFollowing,
  });

  Map<String, dynamic> toMap() => {
    'user_id': userId,
    'username': username,
    'name': name,
    'avatar': avatar,
    'is_following': isFollowing,
  };

  factory SalonFollowerItemModel.fromMap(Map<String, dynamic> map) {
    return SalonFollowerItemModel(
      userId: map['user_id'] ?? '',
      username: map['username'] ?? '',
      name: map['name'] ?? '',
      avatar: resolveImageUrl(
        map['avatar'] ?? map['profile_picture'] ?? map['profile_picture_url'],
      ),
      isFollowing: map['is_following'] ?? false,
    );
  }
}
