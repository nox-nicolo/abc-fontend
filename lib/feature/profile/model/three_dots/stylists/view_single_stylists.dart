import 'dart:convert';

import 'package:africa_beuty/core/utils/api_datetime.dart';

SalonStylistDetail salonStylistDetailFromJson(String str) =>
    SalonStylistDetail.fromJson(json.decode(str) as Map<String, dynamic>);

String salonStylistDetailToJson(SalonStylistDetail data) =>
    json.encode(data.toJson());

class SalonStylistDetail {
  final String id;
  final String salonId;
  final String userId;
  final String title;
  final String bio;
  final bool isOwner;
  final bool isActive;
  final DateTime? createdAt;
  final SalonStylistDetailUser? user;

  const SalonStylistDetail({
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

  factory SalonStylistDetail.fromJson(Map<String, dynamic> json) {
    return SalonStylistDetail(
      id: json['id'] as String? ?? '',
      salonId: json['salon_id'] as String? ?? '',
      userId: json['user_id'] as String? ?? '',
      title: json['title'] as String? ?? '',
      bio: json['bio'] as String? ?? '',
      isOwner: json['is_owner'] as bool? ?? false,
      isActive: json['is_active'] as bool? ?? false,
      createdAt: tryParseApiDateTime(json['created_at']),
      user: json['user'] != null
          ? SalonStylistDetailUser.fromJson(
              json['user'] as Map<String, dynamic>,
            )
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

  SalonStylistDetail copyWith({
    String? id,
    String? salonId,
    String? userId,
    String? title,
    String? bio,
    bool? isOwner,
    bool? isActive,
    DateTime? createdAt,
    SalonStylistDetailUser? user,
  }) {
    return SalonStylistDetail(
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
}

class SalonStylistDetailUser {
  final String id;
  final String username;
  final String name;
  final SalonStylistDetailProfilePicture? profilePicture;
  final String profilePictureUrl;

  const SalonStylistDetailUser({
    required this.id,
    required this.username,
    required this.name,
    required this.profilePicture,
    required this.profilePictureUrl,
  });

  factory SalonStylistDetailUser.fromJson(Map<String, dynamic> json) {
    return SalonStylistDetailUser(
      id: json['id'] as String? ?? '',
      username: json['username'] as String? ?? '',
      name: json['name'] as String? ?? '',
      profilePicture: json['profile_picture'] != null
          ? SalonStylistDetailProfilePicture.fromJson(
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
}

class SalonStylistDetailProfilePicture {
  final String id;
  final String fileName;

  const SalonStylistDetailProfilePicture({
    required this.id,
    required this.fileName,
  });

  factory SalonStylistDetailProfilePicture.fromJson(Map<String, dynamic> json) {
    return SalonStylistDetailProfilePicture(
      id: json['id'] as String? ?? '',
      fileName: json['file_name'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'file_name': fileName};
  }
}
