import 'dart:convert';

class MediaUpdate {
  final String profilePictureUrl;
  final String coverAdsUrl;
  final String status;

  MediaUpdate({
    required this.profilePictureUrl,
    required this.coverAdsUrl,
    required this.status,
  });

  factory MediaUpdate.fromMap(Map<String, dynamic> map) {
    return MediaUpdate(
      profilePictureUrl: map['profile_picture_url']?.toString() ?? '',
      coverAdsUrl: map['cover_ads_url']?.toString() ?? '',
      status: map['status']?.toString() ?? '',
    );
  }

  factory MediaUpdate.fromJson(String source) => 
      MediaUpdate.fromMap(json.decode(source) as Map<String, dynamic>);
}