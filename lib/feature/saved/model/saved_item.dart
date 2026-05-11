class SavedCollection {
  final List<SavedSalon> salons;
  final List<SavedService> services;
  final List<SavedStyle> styles;

  const SavedCollection({
    required this.salons,
    required this.services,
    required this.styles,
  });

  bool get isEmpty => salons.isEmpty && services.isEmpty && styles.isEmpty;
}

class SavedSalon {
  final String id;
  final String name;
  final String? username;
  final String? imageUrl;
  final String? subtitle;

  const SavedSalon({
    required this.id,
    required this.name,
    this.username,
    this.imageUrl,
    this.subtitle,
  });

  factory SavedSalon.fromMap(Map<String, dynamic> map) {
    final salon = _nestedMap(map, 'salon') ?? map;
    return SavedSalon(
      id: _string(salon, ['id', 'salon_id']),
      name: _string(salon, ['name', 'title', 'salon_name'], fallback: 'Salon'),
      username: _optionalString(salon, ['username']),
      imageUrl: _optionalString(salon, [
        'profile_picture',
        'cover_image',
        'image_url',
        'imageUrl',
      ]),
      subtitle: _optionalString(salon, ['slogan', 'location', 'city']),
    );
  }
}

class SavedService {
  final String id;
  final String name;
  final String? salonName;
  final String? imageUrl;
  final double? price;
  final String? currency;

  const SavedService({
    required this.id,
    required this.name,
    this.salonName,
    this.imageUrl,
    this.price,
    this.currency,
  });

  factory SavedService.fromMap(Map<String, dynamic> map) {
    final service = _nestedMap(map, 'service') ?? map;
    return SavedService(
      id: _string(service, ['id', 'service_id']),
      name: _string(service, ['name', 'service_name'], fallback: 'Service'),
      salonName: _optionalString(service, ['salon_name', 'salonName']),
      imageUrl: _optionalString(service, ['image_url', 'imageUrl', 'picture']),
      price: _number(service, ['price', 'price_min', 'priceMin']),
      currency: _optionalString(service, ['currency']),
    );
  }
}

class SavedStyle {
  final String id;
  final String title;
  final String? imageUrl;
  final String? salonName;
  final int? likesCount;

  const SavedStyle({
    required this.id,
    required this.title,
    this.imageUrl,
    this.salonName,
    this.likesCount,
  });

  factory SavedStyle.fromMap(Map<String, dynamic> map) {
    final style = _nestedMap(map, 'style') ?? _nestedMap(map, 'post') ?? map;
    final media = style['media'];
    final firstMedia = media is List && media.isNotEmpty && media.first is Map
        ? Map<String, dynamic>.from(media.first as Map)
        : null;
    final stats = _nestedMap(style, 'stats');

    return SavedStyle(
      id: _string(style, ['id', 'post_id', 'style_id']),
      title: _string(style, ['caption', 'title', 'name'], fallback: 'Style'),
      imageUrl:
          _optionalString(style, ['image_url', 'imageUrl']) ??
          _optionalString(firstMedia, ['url', 'image_url']),
      salonName: _optionalString(style, ['salon_name', 'author_name']),
      likesCount: _number(stats ?? style, ['likes', 'likes_count'])?.toInt(),
    );
  }
}

Map<String, dynamic>? _nestedMap(Map<String, dynamic>? map, String key) {
  final value = map?[key];
  if (value is Map<String, dynamic>) return value;
  if (value is Map) return Map<String, dynamic>.from(value);
  return null;
}

String _string(
  Map<String, dynamic>? map,
  List<String> keys, {
  String fallback = '',
}) {
  for (final key in keys) {
    final value = map?[key];
    if (value != null && value.toString().isNotEmpty) return value.toString();
  }
  return fallback;
}

String? _optionalString(Map<String, dynamic>? map, List<String> keys) {
  final value = _string(map, keys);
  return value.isEmpty ? null : value;
}

double? _number(Map<String, dynamic>? map, List<String> keys) {
  for (final key in keys) {
    final value = map?[key];
    if (value is num) return value.toDouble();
    if (value is String) return double.tryParse(value);
  }
  return null;
}
