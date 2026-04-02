class SalonStylistUserModel {
  final String id;
  final String? username;
  final String? name;
  final String? profilePictureUrl;

  const SalonStylistUserModel({
    required this.id,
    this.username,
    this.name,
    this.profilePictureUrl,
  });

  factory SalonStylistUserModel.fromJson(Map<String, dynamic> json) {
    return SalonStylistUserModel(
      id: json['id'] as String,
      username: json['username'] as String?,
      name: json['name'] as String?,
      profilePictureUrl: json['profile_picture_url'] as String?,
    );
  }
}

class SalonStylistModel {
  final String id;
  final String salonId;
  final String userId;
  final String? title;
  final String? bio;
  final bool isOwner;
  final bool isActive;
  final SalonStylistUserModel user;

  const SalonStylistModel({
    required this.id,
    required this.salonId,
    required this.userId,
    required this.title,
    required this.bio,
    required this.isOwner,
    required this.isActive,
    required this.user,
  });

  String get displayName {
    if ((user.name ?? '').trim().isNotEmpty) return user.name!.trim();
    if ((title ?? '').trim().isNotEmpty) return title!.trim();
    return 'Unnamed stylist';
  }

  String? get imageUrl => user.profilePictureUrl;

  factory SalonStylistModel.fromJson(Map<String, dynamic> json) {
    return SalonStylistModel(
      id: json['id'] as String,
      salonId: json['salon_id'] as String,
      userId: json['user_id'] as String,
      title: json['title'] as String?,
      bio: json['bio'] as String?,
      isOwner: json['is_owner'] as bool? ?? false,
      isActive: json['is_active'] as bool? ?? false,
      user: SalonStylistUserModel.fromJson(
        json['user'] as Map<String, dynamic>,
      ),
    );
  }
}

class SalonStylistListResponseModel {
  final List<SalonStylistModel> items;
  final int total;
  final int limit;
  final int offset;

  const SalonStylistListResponseModel({
    required this.items,
    required this.total,
    required this.limit,
    required this.offset,
  });

  factory SalonStylistListResponseModel.fromJson(Map<String, dynamic> json) {
    return SalonStylistListResponseModel(
      items: (json['items'] as List<dynamic>? ?? [])
          .map((e) => SalonStylistModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      total: json['total'] as int? ?? 0,
      limit: json['limit'] as int? ?? 0,
      offset: json['offset'] as int? ?? 0,
    );
  }
}