import 'dart:convert';

import 'package:africa_beuty/core/utils/api_datetime.dart';

StylistListResponse stylistListResponseFromJson(String str) =>
    StylistListResponse.fromJson(json.decode(str) as Map<String, dynamic>);

String stylistListResponseToJson(StylistListResponse data) =>
    json.encode(data.toJson());

class StylistListResponse {
  final List<StylistItem> items;
  final int total;
  final int limit;
  final int offset;

  const StylistListResponse({
    required this.items,
    required this.total,
    required this.limit,
    required this.offset,
  });

  factory StylistListResponse.fromJson(Map<String, dynamic> json) {
    return StylistListResponse(
      items: (json['items'] as List<dynamic>? ?? [])
          .map((e) => StylistItem.fromJson(e as Map<String, dynamic>))
          .toList(),
      total: json['total'] as int? ?? 0,
      limit: json['limit'] as int? ?? 0,
      offset: json['offset'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'items': items.map((e) => e.toJson()).toList(),
      'total': total,
      'limit': limit,
      'offset': offset,
    };
  }

  StylistListResponse copyWith({
    List<StylistItem>? items,
    int? total,
    int? limit,
    int? offset,
  }) {
    return StylistListResponse(
      items: items ?? this.items,
      total: total ?? this.total,
      limit: limit ?? this.limit,
      offset: offset ?? this.offset,
    );
  }
}

class StylistItem {
  final String id;
  final String salonId;
  final String userId;
  final String title;
  final String bio;
  final bool isOwner;
  final bool isActive;
  final DateTime? createdAt;
  final StylistUser? user;

  const StylistItem({
    required this.id,
    required this.salonId,
    required this.userId,
    required this.title,
    required this.bio,
    required this.isOwner,
    required this.isActive,
    required this.createdAt,
    required this.user,
  });

  factory StylistItem.fromJson(Map<String, dynamic> json) {
    return StylistItem(
      id: json['id'] as String? ?? '',
      salonId: json['salon_id'] as String? ?? '',
      userId: json['user_id'] as String? ?? '',
      title: json['title'] as String? ?? '',
      bio: json['bio'] as String? ?? '',
      isOwner: json['is_owner'] as bool? ?? false,
      isActive: json['is_active'] as bool? ?? false,
      createdAt: tryParseApiDateTime(json['created_at']),
      user: json['user'] != null
          ? StylistUser.fromJson(json['user'] as Map<String, dynamic>)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'salon_id': salonId,
      'user_id': userId,
      'title': title,
      'bio': bio,
      'is_owner': isOwner,
      'is_active': isActive,
      'created_at': createdAt?.toIso8601String(),
      'user': user?.toJson(),
    };
  }

  StylistItem copyWith({
    String? id,
    String? salonId,
    String? userId,
    String? title,
    String? bio,
    bool? isOwner,
    bool? isActive,
    DateTime? createdAt,
    StylistUser? user,
  }) {
    return StylistItem(
      id: id ?? this.id,
      salonId: salonId ?? this.salonId,
      userId: userId ?? this.userId,
      title: title ?? this.title,
      bio: bio ?? this.bio,
      isOwner: isOwner ?? this.isOwner,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      user: user ?? this.user,
    );
  }

  String get displayName => user?.name ?? '';
  String get username => user?.username ?? '';
  String get profileImageUrl => user?.profilePictureUrl ?? '';
}

class StylistUser {
  final String id;
  final String username;
  final String name;
  final StylistProfilePicture? profilePicture;
  final String profilePictureUrl;

  const StylistUser({
    required this.id,
    required this.username,
    required this.name,
    required this.profilePicture,
    required this.profilePictureUrl,
  });

  factory StylistUser.fromJson(Map<String, dynamic> json) {
    return StylistUser(
      id: json['id'] as String? ?? '',
      username: json['username'] as String? ?? '',
      name: json['name'] as String? ?? '',
      profilePicture: json['profile_picture'] != null
          ? StylistProfilePicture.fromJson(
              json['profile_picture'] as Map<String, dynamic>,
            )
          : null,
      profilePictureUrl: json['profile_picture_url'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'name': name,
      'profile_picture': profilePicture?.toJson(),
      'profile_picture_url': profilePictureUrl,
    };
  }

  StylistUser copyWith({
    String? id,
    String? username,
    String? name,
    StylistProfilePicture? profilePicture,
    String? profilePictureUrl,
  }) {
    return StylistUser(
      id: id ?? this.id,
      username: username ?? this.username,
      name: name ?? this.name,
      profilePicture: profilePicture ?? this.profilePicture,
      profilePictureUrl: profilePictureUrl ?? this.profilePictureUrl,
    );
  }
}

class StylistProfilePicture {
  final String id;
  final String fileName;

  const StylistProfilePicture({required this.id, required this.fileName});

  factory StylistProfilePicture.fromJson(Map<String, dynamic> json) {
    return StylistProfilePicture(
      id: json['id'] as String? ?? '',
      fileName: json['file_name'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'file_name': fileName};
  }

  StylistProfilePicture copyWith({String? id, String? fileName}) {
    return StylistProfilePicture(
      id: id ?? this.id,
      fileName: fileName ?? this.fileName,
    );
  }
}
