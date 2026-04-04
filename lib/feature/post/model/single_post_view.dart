import 'dart:convert';

/// =================================================
/// ENGAGEMENT
/// =================================================
class EngagementModel {
  final bool liked;
  final bool saved;
  final bool canComment;

  const EngagementModel({
    required this.liked,
    required this.saved,
    required this.canComment,
  });

  factory EngagementModel.fromMap(Map<String, dynamic> map) {
    return EngagementModel(
      liked: map['liked'] ?? false,
      saved: map['saved'] ?? false,
      canComment: map['can_comment'] ?? true,
    );
  }
}


/// =================================================
/// BOOKING
/// =================================================
class BookingModel {
  final bool canBook;
  final bool hasBookedBefore;
  final bool canReview;

  const BookingModel({
    required this.canBook,
    required this.hasBookedBefore,
    required this.canReview,
  });

  factory BookingModel.fromMap(Map<String, dynamic> map) {
    return BookingModel(
      canBook: map['can_book'] ?? false,
      hasBookedBefore: map['has_booked_before'] ?? false,
      canReview: map['can_review'] ?? false,
    );
  }
}


/// =================================================
/// STYLIST
/// =================================================
class StylistModel {
  final String id;
  final String name;
  final String? avatar;
  final String? title;
  final double? rating;

  const StylistModel({
    required this.id,
    required this.name,
    this.avatar,
    this.title,
    this.rating,
  });

  factory StylistModel.fromMap(Map<String, dynamic> map) {
    return StylistModel(
      id: map['id'],
      name: map['name'] ?? '',
      avatar: map['avatar'],
      title: map['title'],
      rating: map['rating'] != null
          ? (map['rating'] as num).toDouble()
          : null,
    );
  }
}



/// =================================================
/// LOCATION
/// =================================================
class AuthorLocationModel {
  final String city;
  final String country;
  final double latitude;
  final double longitude;

  const AuthorLocationModel({
    required this.city,
    required this.country,
    required this.latitude,
    required this.longitude,
  });

  factory AuthorLocationModel.fromMap(Map<String, dynamic> map) {
    return AuthorLocationModel(
      city: map['city'] ?? '',
      country: map['country'] ?? '',
      latitude: (map['latitude'] as num?)?.toDouble() ?? 0,
      longitude: (map['longitude'] as num?)?.toDouble() ?? 0,
    );
  }
}

/// =================================================
/// AUTHOR
/// =================================================
class PostAuthorModel {
  final String id;
  final String salonName;
  final String username;
  final String? displayPicture;
  final bool isVerified;
  final AuthorLocationModel? location;

  const PostAuthorModel({
    required this.id,
    required this.salonName,
    required this.username,
    this.displayPicture,
    required this.isVerified,
    this.location,
  });

  factory PostAuthorModel.fromMap(Map<String, dynamic> map) {
    return PostAuthorModel(
      id: map['id'],
      salonName: map['salon_name'] ?? '',
      username: map['username'] ?? '',
      displayPicture: map['display_picture'],
      isVerified: map['is_verified'] ?? false,
      location: map['location'] != null
          ? AuthorLocationModel.fromMap(map['location'])
          : null,
    );
  }
}

/// =================================================
/// IMAGE
/// =================================================
class PostImageModel {
  final String url;
  final String type;
  final double aspectRatio;

  const PostImageModel({
    required this.url,
    required this.type,
    required this.aspectRatio,
  });

  factory PostImageModel.fromMap(Map<String, dynamic> map) {
    return PostImageModel(
      url: map['url'] ?? '',
      type: map['type'] ?? 'image',
      aspectRatio: (map['aspect_ratio'] as num?)?.toDouble() ?? 1,
    );
  }
}

/// =================================================
/// POST SERVICE (MINI)
/// =================================================
class PostServiceMiniModel {
  final String category;
  final double price;
  final double durationMinutes;
  final String? assignedServicer;

  const PostServiceMiniModel({
    required this.category,
    required this.price,
    required this.durationMinutes,
    this.assignedServicer,
  });

  factory PostServiceMiniModel.fromMap(Map<String, dynamic> map) {
    return PostServiceMiniModel(
      category: map['category'] ?? '',
      price: (map['price'] as num?)?.toDouble() ?? 0,
      durationMinutes: (map['duration_minutes'] as num?)?.toDouble() ?? 0,
      assignedServicer: map['assigned_servicer'],
    );
  }
}

/// =================================================
/// STATS
/// =================================================
class PostStatsModel {
  final int likes;
  final int comments;
  final int shares;
  final int saves;

  const PostStatsModel({
    required this.likes,
    required this.comments,
    required this.shares,
    required this.saves,
  });

  factory PostStatsModel.fromMap(Map<String, dynamic> map) {
    return PostStatsModel(
      likes: map['likes'] ?? 0,
      comments: map['comments'] ?? 0,
      shares: map['shares'] ?? 0,
      saves: map['saves'] ?? 0,
    );
  }
}

/// =================================================
/// VIEWER STATE
/// =================================================
class ViewerStateModel {
  final bool isLiked;
  final bool isSaved;
  final bool isMyPost;

  const ViewerStateModel({
    required this.isLiked,
    required this.isSaved,
    required this.isMyPost,
  });

  factory ViewerStateModel.fromMap(Map<String, dynamic> map) {
    return ViewerStateModel(
      isLiked: map['is_liked'] ?? false,
      isSaved: map['is_saved'] ?? false,
      isMyPost: map['is_my_post'] ?? false,
    );
  }
}

/// =================================================
/// POST ITEM (USED FOR post + other_posts.items)
/// =================================================
class PostItemModel {
  final String id;
  final PostAuthorModel author;
  final String description;
  final List<PostImageModel> images;
  final PostServiceMiniModel service;
  final PostStatsModel stats;
  final ViewerStateModel viewerState;
  final DateTime createdAt;

  const PostItemModel({
    required this.id,
    required this.author,
    required this.description,
    required this.images,
    required this.service,
    required this.stats,
    required this.viewerState,
    required this.createdAt,
  });

  factory PostItemModel.fromMap(Map<String, dynamic> map) {
    return PostItemModel(
      id: map['id'],
      author: PostAuthorModel.fromMap(map['author']),
      description: map['description'] ?? '',
      images: (map['images'] as List<dynamic>? ?? [])
          .map((e) => PostImageModel.fromMap(e))
          .toList(),
      service: PostServiceMiniModel.fromMap(map['service'] ?? {}),
      stats: PostStatsModel.fromMap(map['stats'] ?? {}),
      viewerState: ViewerStateModel.fromMap(map['viewer_state'] ?? {}),
      createdAt: DateTime.parse(map['created_at']),
    );
  }
}

/// =================================================
/// SERVICE SECTION (FULL)
/// =================================================
class PriceRangeModel {
  final double min;
  final double max;
  final String currency;

  const PriceRangeModel({
    required this.min,
    required this.max,
    required this.currency,
  });

  factory PriceRangeModel.fromMap(Map<String, dynamic> map) {
    return PriceRangeModel(
      min: (map['min'] as num?)?.toDouble() ?? 0,
      max: (map['max'] as num?)?.toDouble() ?? 0,
      currency: map['currency'] ?? 'TZS',
    );
  }
}

class ServiceProductModel {
  final String name;
  final String? brand;

  const ServiceProductModel({
    required this.name,
    this.brand,
  });

  factory ServiceProductModel.fromMap(Map<String, dynamic> map) {
    return ServiceProductModel(
      name: map['name'] ?? '',
      brand: map['brand'],
    );
  }
}

class ServiceSectionModel {
  final String id;
  final String name;
  final PriceRangeModel price;
  final int durationMinutes;
  final List<String> benefits;
  final List<ServiceProductModel> products;

  const ServiceSectionModel({
    required this.id,
    required this.name,
    required this.price,
    required this.durationMinutes,
    required this.benefits,
    required this.products,
  });

  factory ServiceSectionModel.fromMap(Map<String, dynamic> map) {
    return ServiceSectionModel(
      id: map['id'],
      name: map['name'] ?? '',
      price: PriceRangeModel.fromMap(map['price'] ?? {}),
      durationMinutes: (map['duration_minutes'] as num?)?.toInt() ?? 0,
      benefits: List<String>.from(map['benefits'] ?? []),
      products: (map['products'] as List<dynamic>? ?? [])
          .map((e) => ServiceProductModel.fromMap(e))
          .toList(),
    );
  }
}

/// =================================================
/// OTHER POSTS
/// =================================================
class OtherPostsSectionModel {
  final List<PostItemModel> items;
  final DateTime? nextCursor;

  const OtherPostsSectionModel({
    required this.items,
    this.nextCursor,
  });

  OtherPostsSectionModel copyWith({
    List<PostItemModel>? items,
    DateTime? nextCursor,
  }) {
    return OtherPostsSectionModel(
      items: items ?? this.items,
      nextCursor: nextCursor ?? this.nextCursor,
    );
  }

  factory OtherPostsSectionModel.fromMap(Map<String, dynamic> map) {
    return OtherPostsSectionModel(
      items: (map['items'] as List<dynamic>? ?? [])
          .map((e) => PostItemModel.fromMap(e))
          .toList(),
      nextCursor: map['next_cursor'] != null
          ? DateTime.parse(map['next_cursor'])
          : null,
    );
  }
}

class PostPreviewModel {
  final String id;
  final String coverImage;

  const PostPreviewModel({
    required this.id,
    required this.coverImage,
  });

  factory PostPreviewModel.fromMap(Map<String, dynamic> map) {
    return PostPreviewModel(
      id: map['id'],
      coverImage: map['cover_image'] ?? '',
    );
  }
}

class SimilarSectionModel {
  final List<PostPreviewModel> byService;
  final List<PostPreviewModel> byStylist;
  final List<PostPreviewModel> bySalon;

  const SimilarSectionModel({
    required this.byService,
    required this.byStylist,
    required this.bySalon,
  });

  factory SimilarSectionModel.fromMap(Map<String, dynamic> map) {
    return SimilarSectionModel(
      byService: (map['by_service'] as List<dynamic>? ?? [])
          .map((e) => PostPreviewModel.fromMap(e))
          .toList(),
      byStylist: (map['by_stylist'] as List<dynamic>? ?? [])
          .map((e) => PostPreviewModel.fromMap(e))
          .toList(),
      bySalon: (map['by_salon'] as List<dynamic>? ?? [])
          .map((e) => PostPreviewModel.fromMap(e))
          .toList(),
    );
  }
}


class SponsoredSalonModel {
  final String salonId;
  final String name;
  final String? location;
  final double? rating;
  final double price;
  final String currency;
  final String planType;

  const SponsoredSalonModel({
    required this.salonId,
    required this.name,
    this.location,
    this.rating,
    required this.price,
    required this.currency,
    required this.planType,
  });

  factory SponsoredSalonModel.fromMap(Map<String, dynamic> map) {
    return SponsoredSalonModel(
      salonId: map['salon_id'],
      name: map['name'] ?? '',
      location: map['location'],
      rating: map['rating'] != null
          ? (map['rating'] as num).toDouble()
          : null,
      price: (map['price'] as num?)?.toDouble() ?? 0,
      currency: map['currency'] ?? 'TZS',
      planType: map['plan_type'] ?? '',
    );
  }
}

class ServiceReviewModel {
  final String id;
  final String userName;
  final String? userAvatar;
  final double rating;
  final String comment;
  final DateTime createdAt;

  const ServiceReviewModel({
    required this.id,
    required this.userName,
    this.userAvatar,
    required this.rating,
    required this.comment,
    required this.createdAt,
  });

  factory ServiceReviewModel.fromMap(Map<String, dynamic> map) {
    return ServiceReviewModel(
      id: map['id'] ?? '',
      userName: map['user_name'] ?? '',
      userAvatar: map['user_avatar'],
      rating: (map['rating'] as num?)?.toDouble() ?? 0,
      comment: map['comment'] ?? '',
      createdAt: DateTime.parse(map['created_at']),
    );
  }
}

class ReviewSectionModel {
  final int count;
  final double? average;
  final List<ServiceReviewModel> items;

  const ReviewSectionModel({
    required this.count,
    this.average,
    required this.items,
  });

  factory ReviewSectionModel.fromMap(Map<String, dynamic> map) {
    return ReviewSectionModel(
      count: map['count'] ?? 0,
      average: map['average'] != null
          ? (map['average'] as num).toDouble()
          : null,
      items: (map['items'] as List<dynamic>? ?? [])
          .map((e) => ServiceReviewModel.fromMap(e))
          .toList(),
    );
  }
}




/// =================================================
/// ROOT SINGLE POST VIEW
/// =================================================
class SinglePostViewModel {
  final PostItemModel post;
  final ServiceSectionModel service;
  final EngagementModel engagement;
  final BookingModel booking;
  final List<StylistModel> stylists;
  final ReviewSectionModel reviews;
  final SimilarSectionModel similar;
  final List<SponsoredSalonModel> sponsoredSalons;
  final OtherPostsSectionModel otherPosts;

  const SinglePostViewModel({
    required this.post,
    required this.service,
    required this.engagement,
    required this.booking,
    required this.stylists,
    required this.reviews,
    required this.similar,
    required this.sponsoredSalons,
    required this.otherPosts,
  });

  SinglePostViewModel copyWith({
    PostItemModel? post,
    ServiceSectionModel? service,
    EngagementModel? engagement,
    BookingModel? booking,
    List<StylistModel>? stylists,
    ReviewSectionModel? reviews,
    SimilarSectionModel? similar,
    List<SponsoredSalonModel>? sponsoredSalons,
    OtherPostsSectionModel? otherPosts,
  }) {
    return SinglePostViewModel(
      post: post ?? this.post,
      service: service ?? this.service,
      engagement: engagement ?? this.engagement,
      booking: booking ?? this.booking,
      stylists: stylists ?? this.stylists,
      reviews: reviews ?? this.reviews,
      similar: similar ?? this.similar,
      sponsoredSalons:
          sponsoredSalons ?? this.sponsoredSalons,
      otherPosts: otherPosts ?? this.otherPosts,
    );
  }

  factory SinglePostViewModel.fromMap(Map<String, dynamic> map) {
    return SinglePostViewModel(
      post: PostItemModel.fromMap(map['post']),
      service: ServiceSectionModel.fromMap(map['service']),
      engagement: EngagementModel.fromMap(map['engagement']),
      booking: BookingModel.fromMap(map['booking']),
      stylists: (map['stylists'] as List<dynamic>? ?? [])
          .map((e) => StylistModel.fromMap(e))
          .toList(),
      reviews: ReviewSectionModel.fromMap(map['reviews']),
      similar: SimilarSectionModel.fromMap(map['similar']),
      sponsoredSalons: (map['sponsored_salons'] as List<dynamic>? ?? [])
          .map((e) => SponsoredSalonModel.fromMap(e))
          .toList(),
      otherPosts: OtherPostsSectionModel.fromMap(map['other_posts']),
    );
  }

  factory SinglePostViewModel.fromJson(String source) =>
      SinglePostViewModel.fromMap(json.decode(source));
}
