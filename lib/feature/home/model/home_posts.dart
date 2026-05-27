import 'dart:convert';

import 'package:africa_beuty/core/utils/api_datetime.dart';
import 'package:africa_beuty/core/utils/image_url.dart';

/* ------------------------------------------------------------
   Post Model
------------------------------------------------------------- */

class PostModel {
  PostModel({
    required this.id,
    required this.postType,
    required this.caption,
    required this.createdAt,
    required this.author,
    required this.media,
    required this.stats,
    required this.viewerState,
  });

  final String id;
  final String postType;
  final String caption;
  final DateTime createdAt;
  final PostAuthor author;
  final List<PostMedia> media;
  final PostStats stats;
  final PostViewerState viewerState;

  // ----------------------------------------------------------
  // COPY
  // ----------------------------------------------------------
  PostModel copyWith({
    String? id,
    String? postType,
    String? caption,
    DateTime? createdAt,
    PostAuthor? author,
    List<PostMedia>? media,
    PostStats? stats,
    PostViewerState? viewerState,
  }) {
    return PostModel(
      id: id ?? this.id,
      postType: postType ?? this.postType,
      caption: caption ?? this.caption,
      createdAt: createdAt ?? this.createdAt,
      author: author ?? this.author,
      media: media ?? this.media,
      stats: stats ?? this.stats,
      viewerState: viewerState ?? this.viewerState,
    );
  }

  // ----------------------------------------------------------
  // MAP / JSON
  // ----------------------------------------------------------
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'post_type': postType,
      'caption': caption,
      'created_at': createdAt.toIso8601String(),
      'author': author.toMap(),
      'media': media.map((e) => e.toMap()).toList(),
      'stats': stats.toMap(),
      'viewer_state': viewerState.toMap(),
    };
  }

  factory PostModel.fromMap(Map<String, dynamic> map) {
    return PostModel(
      id: map['id'] ?? '',
      postType: map['post_type'] ?? 'service',
      caption: map['caption'] ?? '',
      createdAt: parseApiDateTime(map['created_at']),
      author: PostAuthor.fromMap(map['author'] ?? {}),
      media: List<PostMedia>.from(
        (map['media'] ?? []).map((e) => PostMedia.fromMap(e)),
      ),
      stats: PostStats.fromMap(map['stats'] ?? {}),
      viewerState: PostViewerState.fromMap(map['viewer_state'] ?? {}),
    );
  }

  String toJson() => json.encode(toMap());

  factory PostModel.fromJson(String source) =>
      PostModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'PostModel(id: $id, postType: $postType, caption: $caption, createdAt: $createdAt)';
  }

  @override
  bool operator ==(covariant PostModel other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.postType == postType &&
        other.caption == caption &&
        other.createdAt == createdAt &&
        other.author == author &&
        _listEquals(other.media, media) &&
        other.stats == stats &&
        other.viewerState == viewerState;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        postType.hashCode ^
        caption.hashCode ^
        createdAt.hashCode ^
        author.hashCode ^
        media.hashCode ^
        stats.hashCode ^
        viewerState.hashCode;
  }
}

/* ------------------------------------------------------------
   Author
------------------------------------------------------------- */

class PostAuthor {
  PostAuthor({
    required this.userId,
    required this.username,
    required this.isVerified,
    required this.salon,
    required this.profilePicture,
  });

  final String userId;
  final String username;
  final bool isVerified;
  final String profilePicture;
  final PostSalon salon;

  PostAuthor copyWith({
    String? userId,
    String? username,
    bool? isVerified,
    String? profilePicture,
    PostSalon? salon,
  }) {
    return PostAuthor(
      userId: userId ?? this.userId,
      username: username ?? this.username,
      isVerified: isVerified ?? this.isVerified,
      profilePicture: profilePicture ?? this.profilePicture,
      salon: salon ?? this.salon,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'user_id': userId,
      'username': username,
      'is_verified': isVerified,
      'profile_picture': profilePicture,
      'salon': salon.toMap(),
    };
  }

  factory PostAuthor.fromMap(Map<String, dynamic> map) {
    return PostAuthor(
      userId: map['user_id'] ?? '',
      username: map['username'] ?? '',
      isVerified: map['is_verified'] ?? false,
      profilePicture: imageUrlOrEmpty(map['profile_picture']),
      salon: PostSalon.fromMap(map['salon'] ?? {}),
    );
  }

  @override
  bool operator ==(covariant PostAuthor other) {
    if (identical(this, other)) return true;

    return other.userId == userId &&
        other.username == username &&
        other.isVerified == isVerified &&
        other.profilePicture == profilePicture &&
        other.salon == salon;
  }

  @override
  int get hashCode {
    return userId.hashCode ^
        username.hashCode ^
        isVerified.hashCode ^
        profilePicture.hashCode ^
        salon.hashCode;
  }
}

/* ------------------------------------------------------------
   Salon
------------------------------------------------------------- */

class PostSalon {
  PostSalon({required this.id, required this.title, required this.address});

  final String id;
  final String title;
  final String address;

  PostSalon copyWith({String? id, String? title, String? address}) {
    return PostSalon(
      id: id ?? this.id,
      title: title ?? this.title,
      address: address ?? this.address,
    );
  }

  Map<String, dynamic> toMap() {
    return {'id': id, 'title': title, 'address': address};
  }

  factory PostSalon.fromMap(Map<String, dynamic> map) {
    final rawAddress = map['address'];
    String finalAddress = '';

    if (rawAddress == null) {
      finalAddress = 'No address';
    } else if (rawAddress is Map) {
      // If it's the new Map structure, pick the fields you want to show
      final city = rawAddress['city'] ?? '';
      final country = rawAddress['country'] ?? '';
      finalAddress = city.isNotEmpty ? "$city, $country" : country;
    } else {
      // If it's still a simple String
      finalAddress = rawAddress.toString();
    }

    return PostSalon(
      id: map['id'] ?? '',
      title: map['title'] ?? '',
      address: finalAddress,
    );
  }

  @override
  bool operator ==(covariant PostSalon other) {
    if (identical(this, other)) return true;

    return other.id == id && other.title == title && other.address == address;
  }

  @override
  int get hashCode {
    return id.hashCode ^ title.hashCode ^ address.hashCode;
  }
}

/* ------------------------------------------------------------
   Media
------------------------------------------------------------- */

class PostMedia {
  PostMedia({required this.url, required this.type, required this.aspectRatio});

  final String url;
  final String type;
  final double aspectRatio;

  PostMedia copyWith({String? url, String? type, double? aspectRatio}) {
    return PostMedia(
      url: url ?? this.url,
      type: type ?? this.type,
      aspectRatio: aspectRatio ?? this.aspectRatio,
    );
  }

  Map<String, dynamic> toMap() {
    return {'url': url, 'type': type, 'aspect_ratio': aspectRatio};
  }

  factory PostMedia.fromMap(Map<String, dynamic> map) {
    return PostMedia(
      url: imageUrlOrEmpty(map['url']),
      type: map['type'] ?? '',
      aspectRatio: (map['aspect_ratio'] as num?)?.toDouble() ?? 1,
    );
  }

  @override
  bool operator ==(covariant PostMedia other) {
    if (identical(this, other)) return true;

    return other.url == url &&
        other.type == type &&
        other.aspectRatio == aspectRatio;
  }

  @override
  int get hashCode {
    return url.hashCode ^ type.hashCode ^ aspectRatio.hashCode;
  }
}

/* ------------------------------------------------------------
   Stats
------------------------------------------------------------- */

class PostStats {
  PostStats({
    required this.likes,
    required this.comments,
    required this.shares,
  });

  final int likes;
  final int comments;
  final int shares;

  PostStats copyWith({int? likes, int? comments, int? shares}) {
    return PostStats(
      likes: likes ?? this.likes,
      comments: comments ?? this.comments,
      shares: shares ?? this.shares,
    );
  }

  Map<String, dynamic> toMap() {
    return {'likes': likes, 'comments': comments, 'shares': shares};
  }

  factory PostStats.fromMap(Map<String, dynamic> map) {
    return PostStats(
      likes: map['likes'] ?? 0,
      comments: map['comments'] ?? 0,
      shares: map['shares'] ?? 0,
    );
  }

  @override
  bool operator ==(covariant PostStats other) {
    if (identical(this, other)) return true;

    return other.likes == likes &&
        other.comments == comments &&
        other.shares == shares;
  }

  @override
  int get hashCode {
    return likes.hashCode ^ comments.hashCode ^ shares.hashCode;
  }
}

/* ------------------------------------------------------------
   Viewer State
------------------------------------------------------------- */

class PostViewerState {
  PostViewerState({
    required this.isLiked,
    required this.isSaved,
    required this.isMyPost,
  });

  final bool isLiked;
  final bool isSaved;
  final bool isMyPost;

  PostViewerState copyWith({bool? isLiked, bool? isSaved, bool? isMyPost}) {
    return PostViewerState(
      isLiked: isLiked ?? this.isLiked,
      isSaved: isSaved ?? this.isSaved,
      isMyPost: isMyPost ?? this.isMyPost,
    );
  }

  Map<String, dynamic> toMap() {
    return {'is_liked': isLiked, 'is_saved': isSaved, 'is_my_post': isMyPost};
  }

  factory PostViewerState.fromMap(Map<String, dynamic> map) {
    return PostViewerState(
      isLiked: map['is_liked'] ?? false,
      isSaved: map['is_saved'] ?? false,
      isMyPost: map['is_my_post'] ?? false,
    );
  }

  @override
  bool operator ==(covariant PostViewerState other) {
    if (identical(this, other)) return true;

    return other.isLiked == isLiked &&
        other.isSaved == isSaved &&
        other.isMyPost == isMyPost;
  }

  @override
  int get hashCode {
    return isLiked.hashCode ^ isSaved.hashCode ^ isMyPost.hashCode;
  }
}

/* ------------------------------------------------------------
   Helpers
------------------------------------------------------------- */

bool _listEquals<T>(List<T> a, List<T> b) {
  if (a.length != b.length) return false;
  for (var i = 0; i < a.length; i++) {
    if (a[i] != b[i]) return false;
  }
  return true;
}
