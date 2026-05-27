import 'package:africa_beuty/core/utils/image_url.dart';

class CustomerStatsModel {
  final int followingCount;
  final int bookingsCount;
  final int reviewsCount;

  const CustomerStatsModel({
    required this.followingCount,
    required this.bookingsCount,
    required this.reviewsCount,
  });

  factory CustomerStatsModel.fromMap(Map<String, dynamic> map) {
    return CustomerStatsModel(
      followingCount: (map['following_count'] as num?)?.toInt() ?? 0,
      bookingsCount: (map['bookings_count'] as num?)?.toInt() ?? 0,
      reviewsCount: (map['reviews_count'] as num?)?.toInt() ?? 0,
    );
  }
}

class CustomerProfileModel {
  final String id;
  final String username;
  final String name;
  final String? profilePicture;
  final String? bio;
  final String? city;
  final String? country;
  final String? gender;
  final List<String> preferredServices;
  final CustomerStatsModel stats;
  final bool isSalonOwner;

  const CustomerProfileModel({
    required this.id,
    required this.username,
    required this.name,
    this.profilePicture,
    this.bio,
    this.city,
    this.country,
    this.gender,
    required this.preferredServices,
    required this.stats,
    required this.isSalonOwner,
  });

  factory CustomerProfileModel.fromMap(Map<String, dynamic> map) {
    return CustomerProfileModel(
      id: map['id']?.toString() ?? '',
      username: map['username']?.toString() ?? '',
      name: map['name']?.toString() ?? '',
      profilePicture: resolveImageUrl(map['profile_picture']),
      bio: map['bio']?.toString(),
      city: map['city']?.toString(),
      country: map['country']?.toString(),
      gender: map['gender']?.toString(),
      preferredServices: (map['preferred_services'] as List? ?? [])
          .map((e) => e.toString())
          .toList(),
      stats: map['stats'] != null
          ? CustomerStatsModel.fromMap(
              Map<String, dynamic>.from(map['stats'] as Map),
            )
          : const CustomerStatsModel(
              followingCount: 0,
              bookingsCount: 0,
              reviewsCount: 0,
            ),
      isSalonOwner: map['is_salon_owner'] as bool? ?? false,
    );
  }

  CustomerProfileModel copyWith({
    String? name,
    String? bio,
    String? city,
    String? country,
    String? gender,
  }) {
    return CustomerProfileModel(
      id: id,
      username: username,
      name: name ?? this.name,
      profilePicture: profilePicture,
      bio: bio ?? this.bio,
      city: city ?? this.city,
      country: country ?? this.country,
      gender: gender ?? this.gender,
      preferredServices: preferredServices,
      stats: stats,
      isSalonOwner: isSalonOwner,
    );
  }
}
