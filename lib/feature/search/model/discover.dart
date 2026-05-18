String? _stringOrNull(Object? value) {
  if (value == null) return null;
  final text = value.toString().trim();
  if (text.isEmpty || text.toLowerCase() == 'not set') return null;
  return text;
}

double? _doubleOrNull(Object? value) {
  if (value is num) return value.toDouble();
  return double.tryParse(value?.toString() ?? '');
}

int _intOrZero(Object? value) {
  if (value is num) return value.toInt();
  return int.tryParse(value?.toString() ?? '') ?? 0;
}

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
    id: (m['id'] ?? m['salon_id'] ?? '').toString(),
    title: (m['title'] ?? m['name'] ?? '').toString(),
    coverImage: _stringOrNull(
      m['cover_image'] ?? m['cover_url'] ?? m['logo_url'],
    ),
    city: _stringOrNull(m['city']),
    distanceKm: _doubleOrNull(m['distance_km']) ?? 0,
    lat: _doubleOrNull(m['lat'] ?? m['latitude']),
    lng: _doubleOrNull(m['lng'] ?? m['longitude']),
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
    id: (m['id'] ?? m['salon_id'] ?? '').toString(),
    title: (m['title'] ?? m['name'] ?? '').toString(),
    coverImage: _stringOrNull(
      m['cover_image'] ?? m['cover_url'] ?? m['logo_url'],
    ),
    city: _stringOrNull(m['city']),
    bookingCount: _intOrZero(m['booking_count']),
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

  factory TrendingStyleItem.fromMap(Map<String, dynamic> m) =>
      TrendingStyleItem(
        id: (m['id'] ?? '').toString(),
        name: (m['name'] ?? '').toString(),
        image: _stringOrNull(m['image']),
        postCount: _intOrZero(m['post_count']),
      );
}
