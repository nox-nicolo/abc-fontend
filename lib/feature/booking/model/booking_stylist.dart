import 'package:africa_beuty/core/utils/image_url.dart';

class BookingStylistModel {
  const BookingStylistModel({
    required this.stylistId,
    required this.userId,
    required this.name,
    this.title,
    this.bio,
    required this.image,
    required this.rating,
    required this.reviewsCount,
    required this.isRecommended,
    this.recommendationReason,
  });

  final String stylistId;
  final String userId;
  final String name;
  final String? title;
  final String? bio;
  final String image;
  final double rating;
  final int reviewsCount;
  final bool isRecommended;
  final String? recommendationReason;

  factory BookingStylistModel.fromMap(Map<String, dynamic> map) {
    return BookingStylistModel(
      stylistId: map['stylist_id']?.toString() ?? '',
      userId: map['user_id']?.toString() ?? '',
      name: map['name']?.toString() ?? 'Stylist',
      title: map['title']?.toString(),
      bio: map['bio']?.toString(),
      image: imageUrlOrEmpty(map['image']),
      rating: (map['rating'] as num?)?.toDouble() ?? 0.0,
      reviewsCount: (map['reviews_count'] as num?)?.toInt() ?? 0,
      isRecommended: map['is_recommended'] == true,
      recommendationReason: map['recommendation_reason']?.toString(),
    );
  }

  static List<BookingStylistModel> listFromJson(List list) {
    return list
        .whereType<Map<String, dynamic>>()
        .map(BookingStylistModel.fromMap)
        .toList();
  }
}
