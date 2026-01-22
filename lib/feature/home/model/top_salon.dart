import 'dart:convert';

class TopSalonModel {
  TopSalonModel({
    required this.salonId,
    required this.name,
    required this.logoUrl,
    required this.coverUrl,
    required this.city,
    required this.tagline,
  });

  final String salonId;
  final String name;
  final String logoUrl;
  final String coverUrl;
  final String city;
  final String tagline;

  TopSalonModel copyWith({
    String? salonId,
    String? name,
    String? logoUrl,
    String? coverUrl,
    String? city,
    String? tagline,
  }) {
    return TopSalonModel(
      salonId: salonId ?? this.salonId,
      name: name ?? this.name,
      logoUrl: logoUrl ?? this.logoUrl,
      coverUrl: coverUrl ?? this.coverUrl,
      city: city ?? this.city,
      tagline: tagline ?? this.tagline,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'salon_id': salonId,
      'name': name,
      'logo_url': logoUrl,
      'cover_url': coverUrl,
      'city': city,
      'tagline': tagline,
    };
  }

  factory TopSalonModel.fromMap(Map<String, dynamic> map) {
    return TopSalonModel(
      salonId: map['salon_id'] ?? '',
      name: map['name'] ?? '',
      logoUrl: map['logo_url'] ?? '',
      coverUrl: map['cover_url'] ?? '',
      city: map['city'] ?? '',
      tagline: map['tagline'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory TopSalonModel.fromJson(String source) =>
      TopSalonModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'TopSalonModel(salonId: $salonId, name: $name, logoUrl: $logoUrl, coverUrl: $coverUrl, city: $city, tagline: $tagline)';
  }

  @override
  bool operator ==(covariant TopSalonModel other) {
    if (identical(this, other)) return true;

    return other.salonId == salonId &&
        other.name == name &&
        other.logoUrl == logoUrl &&
        other.coverUrl == coverUrl &&
        other.city == city &&
        other.tagline == tagline;
  }

  @override
  int get hashCode {
    return salonId.hashCode ^
        name.hashCode ^
        logoUrl.hashCode ^
        coverUrl.hashCode ^
        city.hashCode ^
        tagline.hashCode;
  }
}
