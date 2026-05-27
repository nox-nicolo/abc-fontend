// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:africa_beuty/core/utils/image_url.dart';

class SalonViewProfileModel {
  final SalonCoreModel salon;
  final SalonViewerModel viewer;
  final SalonMetricsModel metrics;
  final SalonAvailabilityModel availability;
  final SalonContactsModel contacts;
  final SalonMediaModel media;
  final SalonActionsModel actions;
  final SalonServicesModel services;

  SalonViewProfileModel({
    required this.salon,
    required this.viewer,
    required this.metrics,
    required this.availability,
    required this.contacts,
    required this.media,
    required this.actions,
    required this.services,
  });

  SalonViewProfileModel copyWith({
    SalonCoreModel? salon,
    SalonViewerModel? viewer,
    SalonMetricsModel? metrics,
    SalonAvailabilityModel? availability,
    SalonContactsModel? contacts,
    SalonMediaModel? media,
    SalonActionsModel? actions,
    SalonServicesModel? services,
  }) {
    return SalonViewProfileModel(
      salon: salon ?? this.salon,
      viewer: viewer ?? this.viewer,
      metrics: metrics ?? this.metrics,
      availability: availability ?? this.availability,
      contacts: contacts ?? this.contacts,
      media: media ?? this.media,
      actions: actions ?? this.actions,
      services: services ?? this.services,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'salon': salon.toMap(),
      'viewer': viewer.toMap(),
      'metrics': metrics.toMap(),
      'availability': availability.toMap(),
      'contacts': contacts.toMap(),
      'media': media.toMap(),
      'actions': actions.toMap(),
      'services': services.toMap(),
    };
  }

  factory SalonViewProfileModel.fromMap(Map<String, dynamic> map) {
    return SalonViewProfileModel(
      salon: SalonCoreModel.fromMap(map['salon']),
      viewer: SalonViewerModel.fromMap(map['viewer']),
      metrics: SalonMetricsModel.fromMap(map['metrics']),
      availability: SalonAvailabilityModel.fromMap(map['availability']),
      contacts: SalonContactsModel.fromMap(map['contacts']),
      media: SalonMediaModel.fromMap(map['media']),
      actions: SalonActionsModel.fromMap(map['actions']),
      services: SalonServicesModel.fromMap(map['services']),
    );
  }

  String toJson() => json.encode(toMap());

  factory SalonViewProfileModel.fromJson(String source) =>
      SalonViewProfileModel.fromMap(json.decode(source));

  @override
  String toString() =>
      'SalonViewProfileModel(salon: ${salon.name}, followers: ${metrics.followersCount})';

  @override
  bool operator ==(covariant SalonViewProfileModel other) {
    if (identical(this, other)) return true;
    return other.salon == salon &&
        other.viewer == viewer &&
        other.metrics == metrics &&
        other.availability == availability &&
        other.contacts == contacts &&
        other.media == media &&
        other.actions == actions &&
        other.services == services;
  }

  @override
  int get hashCode =>
      salon.hashCode ^
      viewer.hashCode ^
      metrics.hashCode ^
      availability.hashCode ^
      contacts.hashCode ^
      media.hashCode ^
      actions.hashCode ^
      services.hashCode;
}

class SalonCoreModel {
  final String id;
  final String username;
  final String name;
  final String slogan;
  final String description;
  final String profilePicture;
  final String coverImage;
  final bool isVerified;
  final String verificationStatus;
  final String verificationLabel;
  final List<String> verificationReasons;
  final List<String> verificationMissing;
  final bool isPremiumMember;
  final String? premiumPlan;
  final String? premiumLabel;
  final String createdAt;

  SalonCoreModel({
    required this.id,
    required this.username,
    required this.name,
    required this.slogan,
    required this.description,
    required this.profilePicture,
    required this.coverImage,
    required this.isVerified,
    required this.verificationStatus,
    required this.verificationLabel,
    required this.verificationReasons,
    required this.verificationMissing,
    required this.isPremiumMember,
    this.premiumPlan,
    this.premiumLabel,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() => {
    'id': id,
    'username': username,
    'name': name,
    'slogan': slogan,
    'description': description,
    'profile_picture': profilePicture,
    'cover_image': coverImage,
    'is_verified': isVerified,
    'verification_status': verificationStatus,
    'verification_label': verificationLabel,
    'verification_reasons': verificationReasons,
    'verification_missing': verificationMissing,
    'is_premium_member': isPremiumMember,
    'premium_plan': premiumPlan,
    'premium_label': premiumLabel,
    'created_at': createdAt,
  };

  factory SalonCoreModel.fromMap(Map<String, dynamic> map) {
    return SalonCoreModel(
      id: map['id'] ?? '',
      username: map['username'] ?? '',
      name: map['name'] ?? '',
      slogan: map['slogan'] ?? '',
      description: map['description'] ?? '',
      profilePicture: imageUrlOrEmpty(map['profile_picture']),
      coverImage: imageUrlOrEmpty(map['cover_image']),
      isVerified: map['is_verified'] ?? false,
      verificationStatus: map['verification_status'] ?? 'not_verified',
      verificationLabel: map['verification_label'] ?? 'Not verified',
      verificationReasons: List<String>.from(
        (map['verification_reasons'] as List? ?? const []).map(
          (item) => item.toString(),
        ),
      ),
      verificationMissing: List<String>.from(
        (map['verification_missing'] as List? ?? const []).map(
          (item) => item.toString(),
        ),
      ),
      isPremiumMember: map['is_premium_member'] ?? false,
      premiumPlan: map['premium_plan'],
      premiumLabel: map['premium_label'],
      createdAt: map['created_at'] ?? '',
    );
  }
}

class SalonViewerModel {
  final bool isFollowing;
  final bool notificationsEnabled;
  final bool isBlocked;
  final bool isOwner;
  final bool isSaved;

  SalonViewerModel({
    required this.isFollowing,
    required this.notificationsEnabled,
    required this.isBlocked,
    this.isOwner = false,
    this.isSaved = false,
  });

  SalonViewerModel copyWith({
    bool? isFollowing,
    bool? notificationsEnabled,
    bool? isBlocked,
    bool? isOwner,
    bool? isSaved,
  }) {
    return SalonViewerModel(
      isFollowing: isFollowing ?? this.isFollowing,
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
      isBlocked: isBlocked ?? this.isBlocked,
      isOwner: isOwner ?? this.isOwner,
      isSaved: isSaved ?? this.isSaved,
    );
  }

  Map<String, dynamic> toMap() => {
    'is_following': isFollowing,
    'notifications_enabled': notificationsEnabled,
    'is_blocked': isBlocked,
    'is_owner': isOwner,
    'is_saved': isSaved,
  };

  factory SalonViewerModel.fromMap(Map<String, dynamic> map) {
    return SalonViewerModel(
      isFollowing: map['is_following'] ?? false,
      notificationsEnabled: map['notifications_enabled'] ?? false,
      isBlocked: map['is_blocked'] ?? false,
      isOwner: map['is_owner'] ?? false,
      isSaved: map['is_saved'] ?? false,
    );
  }
}

class SalonMetricsModel {
  final int followersCount;
  final int postsCount;
  final double rating;
  final int reviewsCount;

  SalonMetricsModel({
    required this.followersCount,
    required this.postsCount,
    required this.rating,
    required this.reviewsCount,
  });

  SalonMetricsModel copyWith({
    int? followersCount,
    int? postsCount,
    double? rating,
    int? reviewsCount,
  }) {
    return SalonMetricsModel(
      followersCount: followersCount ?? this.followersCount,
      postsCount: postsCount ?? this.postsCount,
      rating: rating ?? this.rating,
      reviewsCount: reviewsCount ?? this.reviewsCount,
    );
  }

  Map<String, dynamic> toMap() => {
    'followers_count': followersCount,
    'posts_count': postsCount,
    'rating': rating,
    'reviews_count': reviewsCount,
  };

  factory SalonMetricsModel.fromMap(Map<String, dynamic> map) {
    return SalonMetricsModel(
      followersCount: map['followers_count'] ?? 0,
      postsCount: map['posts_count'] ?? 0,
      rating: (map['rating'] as num?)?.toDouble() ?? 0.0,
      reviewsCount: map['reviews_count'] ?? 0,
    );
  }
}

class SalonAvailabilityModel {
  final bool isOpenNow;
  final SalonTodayModel? today;
  final List<SalonWeeklyModel> weekly;

  SalonAvailabilityModel({
    required this.isOpenNow,
    this.today,
    required this.weekly,
  });

  Map<String, dynamic> toMap() => {
    'is_open_now': isOpenNow,
    'today': today?.toMap(),
    'weekly': weekly.map((x) => x.toMap()).toList(),
  };

  factory SalonAvailabilityModel.fromMap(Map<String, dynamic> map) {
    return SalonAvailabilityModel(
      isOpenNow: map['is_open_now'] ?? false,
      today: map['today'] != null
          ? SalonTodayModel.fromMap(map['today'])
          : null,
      weekly: map['weekly'] is List
          ? List<SalonWeeklyModel>.from(
              (map['weekly'] as List).map((x) => SalonWeeklyModel.fromMap(x)),
            )
          : [],
    );
  }
}

class SalonTodayModel {
  final int day;
  final String openTime;
  final String closeTime;

  SalonTodayModel({
    required this.day,
    required this.openTime,
    required this.closeTime,
  });

  Map<String, dynamic> toMap() => {
    'day': day,
    'open_time': openTime,
    'close_time': closeTime,
  };

  factory SalonTodayModel.fromMap(Map<String, dynamic> map) {
    return SalonTodayModel(
      day: map['day'] ?? 0,
      openTime: map['open_time'] ?? '',
      closeTime: map['close_time'] ?? '',
    );
  }
}

class SalonWeeklyModel {
  final int day;
  final bool isOpen;
  final String? open;
  final String? close;

  SalonWeeklyModel({
    required this.day,
    required this.isOpen,
    this.open,
    this.close,
  });

  Map<String, dynamic> toMap() => {
    'day': day,
    'is_open': isOpen,
    'open': open,
    'close': close,
  };

  factory SalonWeeklyModel.fromMap(Map<String, dynamic> map) {
    return SalonWeeklyModel(
      day: map['day'] ?? 0,
      isOpen: map['is_open'] ?? false,
      open: map['open'],
      close: map['close'],
    );
  }
}

class SalonContactsModel {
  final String? phone;
  final String? sms;
  final String? whatsapp;
  final String? email;
  final SalonLocationModel? location;

  SalonContactsModel({
    this.phone,
    this.sms,
    this.whatsapp,
    this.email,
    this.location,
  });

  Map<String, dynamic> toMap() => {
    'phone': phone,
    'sms': sms,
    'whatsapp': whatsapp,
    'email': email,
    'location': location?.toMap(),
  };

  factory SalonContactsModel.fromMap(Map<String, dynamic> map) {
    return SalonContactsModel(
      phone: map['phone'],
      sms: map['sms'],
      whatsapp: map['whatsapp'],
      email: map['email'],
      location: map['location'] != null
          ? SalonLocationModel.fromMap(map['location'])
          : null,
    );
  }
}

class SalonLocationModel {
  final String address;
  final double lat;
  final double lng;

  SalonLocationModel({
    required this.address,
    required this.lat,
    required this.lng,
  });

  Map<String, dynamic> toMap() => {'address': address, 'lat': lat, 'lng': lng};

  factory SalonLocationModel.fromMap(Map<String, dynamic> map) {
    return SalonLocationModel(
      address: map['address'] ?? '',
      lat: (map['lat'] as num?)?.toDouble() ?? 0.0,
      lng: (map['lng'] as num?)?.toDouble() ?? 0.0,
    );
  }
}

class SalonMediaModel {
  final List<SalonGalleryModel> gallery;

  SalonMediaModel({required this.gallery});

  Map<String, dynamic> toMap() => {
    'gallery': gallery.map((x) => x.toMap()).toList(),
  };

  factory SalonMediaModel.fromMap(Map<String, dynamic> map) {
    return SalonMediaModel(
      gallery: map['gallery'] is List
          ? List<SalonGalleryModel>.from(
              (map['gallery'] as List).map((x) => SalonGalleryModel.fromMap(x)),
            )
          : [],
    );
  }
}

class SalonGalleryModel {
  final String id;
  final String imageUrl;
  final int order;

  SalonGalleryModel({
    required this.id,
    required this.imageUrl,
    required this.order,
  });

  Map<String, dynamic> toMap() => {
    'id': id,
    'image_url': imageUrl,
    'order': order,
  };

  factory SalonGalleryModel.fromMap(Map<String, dynamic> map) {
    return SalonGalleryModel(
      id: map['id'] ?? '',
      imageUrl: imageUrlOrEmpty(map['image_url']),
      order: map['order'] ?? 0,
    );
  }
}

class SalonActionsModel {
  final bool canFollow;
  final bool canUnfollow;
  final bool canContact;
  final bool canShare;
  final bool canReport;
  final bool canBlock;

  SalonActionsModel({
    required this.canFollow,
    required this.canUnfollow,
    required this.canContact,
    required this.canShare,
    required this.canReport,
    required this.canBlock,
  });

  Map<String, dynamic> toMap() => {
    'can_follow': canFollow,
    'can_unfollow': canUnfollow,
    'can_contact': canContact,
    'can_share': canShare,
    'can_report': canReport,
    'can_block': canBlock,
  };

  factory SalonActionsModel.fromMap(Map<String, dynamic> map) {
    return SalonActionsModel(
      canFollow: map['can_follow'] ?? false,
      canUnfollow: map['can_unfollow'] ?? false,
      canContact: map['can_contact'] ?? false,
      canShare: map['can_share'] ?? false,
      canReport: map['can_report'] ?? false,
      canBlock: map['can_block'] ?? false,
    );
  }
}

class SalonServicesModel {
  final List<SalonServiceCategoryModel> categories;

  SalonServicesModel({required this.categories});

  Map<String, dynamic> toMap() => {
    'categories': categories.map((x) => x.toMap()).toList(),
  };

  factory SalonServicesModel.fromMap(Map<String, dynamic> map) {
    return SalonServicesModel(
      categories: map['categories'] is List
          ? List<SalonServiceCategoryModel>.from(
              (map['categories'] as List).map(
                (x) => SalonServiceCategoryModel.fromMap(x),
              ),
            )
          : [],
    );
  }
}

class SalonServiceCategoryModel {
  final String categoryId;
  final String categoryName;
  final List<SalonServiceItemModel> services;

  SalonServiceCategoryModel({
    required this.categoryId,
    required this.categoryName,
    required this.services,
  });

  Map<String, dynamic> toMap() => {
    'category_id': categoryId,
    'category_name': categoryName,
    'services': services.map((x) => x.toMap()).toList(),
  };

  factory SalonServiceCategoryModel.fromMap(Map<String, dynamic> map) {
    return SalonServiceCategoryModel(
      categoryId: map['category_id'] ?? '',
      categoryName: map['category_name'] ?? '',
      services: map['services'] is List
          ? List<SalonServiceItemModel>.from(
              (map['services'] as List).map(
                (x) => SalonServiceItemModel.fromMap(x),
              ),
            )
          : [],
    );
  }
}

class SalonServiceItemModel {
  final String id;
  final String name;
  final int? priceMin;
  final int? priceMax;
  final String currency;
  final int? durationMinutes;
  final List<SalonServiceStylistModel> stylists;

  SalonServiceItemModel({
    required this.id,
    required this.name,
    this.priceMin,
    this.priceMax,
    required this.currency,
    this.durationMinutes,
    required this.stylists,
  });

  Map<String, dynamic> toMap() => {
    'id': id,
    'name': name,
    'price_min': priceMin,
    'price_max': priceMax,
    'currency': currency,
    'duration_minutes': durationMinutes,
    'stylists': stylists.map((x) => x.toMap()).toList(),
  };

  factory SalonServiceItemModel.fromMap(Map<String, dynamic> map) {
    return SalonServiceItemModel(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      priceMin: map['price_min'],
      priceMax: map['price_max'],
      currency: map['currency'] ?? 'TZS',
      durationMinutes: map['duration_minutes'],
      stylists: map['stylists'] is List
          ? List<SalonServiceStylistModel>.from(
              (map['stylists'] as List).map(
                (x) => SalonServiceStylistModel.fromMap(x),
              ),
            )
          : [],
    );
  }
}

class SalonServiceStylistModel {
  final String id;
  final String name;
  final String? avatar;

  SalonServiceStylistModel({required this.id, required this.name, this.avatar});

  Map<String, dynamic> toMap() => {'id': id, 'name': name, 'avatar': avatar};

  factory SalonServiceStylistModel.fromMap(Map<String, dynamic> map) {
    return SalonServiceStylistModel(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      avatar: resolveImageUrl(
        map['avatar'] ?? map['profile_picture'] ?? map['profile_picture_url'],
      ),
    );
  }
}
