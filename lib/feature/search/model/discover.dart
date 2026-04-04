class NearbySalonItem {
  final String id;
  final String title;
  final String? coverImage;
  final String? city;
  final double distanceKm;
  final double? lat;
  final double? lng;

  const NearbySalonItem({
    required this.id,
    required this.title,
    this.coverImage,
    this.city,
    required this.distanceKm,
    this.lat,
    this.lng,
  });

  factory NearbySalonItem.fromMap(Map<String, dynamic> m) => NearbySalonItem(
        id: m['id'] as String,
        title: m['title'] as String? ?? '',
        coverImage: m['cover_image'] as String?,
        city: m['city'] as String?,
        distanceKm: (m['distance_km'] as num?)?.toDouble() ?? 0,
        lat: (m['lat'] as num?)?.toDouble(),
        lng: (m['lng'] as num?)?.toDouble(),
      );
}

class TopSalonItem {
  final String id;
  final String title;
  final String? coverImage;
  final String? city;
  final int bookingCount;

  const TopSalonItem({
    required this.id,
    required this.title,
    this.coverImage,
    this.city,
    required this.bookingCount,
  });

  factory TopSalonItem.fromMap(Map<String, dynamic> m) => TopSalonItem(
        id: m['id'] as String,
        title: m['title'] as String? ?? '',
        coverImage: m['cover_image'] as String?,
        city: m['city'] as String?,
        bookingCount: m['booking_count'] as int? ?? 0,
      );
}

class TrendingStyleItem {
  final String id;
  final String name;
  final String? image;
  final int postCount;

  const TrendingStyleItem({
    required this.id,
    required this.name,
    this.image,
    required this.postCount,
  });

  factory TrendingStyleItem.fromMap(Map<String, dynamic> m) => TrendingStyleItem(
        id: m['id'] as String,
        name: m['name'] as String? ?? '',
        image: m['image'] as String?,
        postCount: m['post_count'] as int? ?? 0,
      );
}
