import 'package:africa_beuty/core/utils/image_url.dart';

class FollowedSalonModel {
  final String salonId;
  final String title;
  final String username;
  final String? profilePicture;

  const FollowedSalonModel({
    required this.salonId,
    required this.title,
    required this.username,
    this.profilePicture,
  });

  factory FollowedSalonModel.fromMap(Map<String, dynamic> map) {
    return FollowedSalonModel(
      salonId: map['salon_id']?.toString() ?? '',
      title: map['title']?.toString() ?? '',
      username: map['username']?.toString() ?? '',
      profilePicture: resolveImageUrl(map['profile_picture']),
    );
  }
}
