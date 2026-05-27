import 'dart:convert';

import 'package:africa_beuty/core/utils/image_url.dart';

class PostResponseModel {
  final List<PostModel> items;
  final String? nextCursor;

  PostResponseModel({required this.items, this.nextCursor});

  factory PostResponseModel.fromMap(Map<String, dynamic> map) {
    return PostResponseModel(
      items: List<PostModel>.from(
        (map['items'] as List<dynamic>).map(
          (x) => PostModel.fromMap(x as Map<String, dynamic>),
        ),
      ),
      nextCursor: map['next_cursor'],
    );
  }

  factory PostResponseModel.fromJson(String source) =>
      PostResponseModel.fromMap(json.decode(source) as Map<String, dynamic>);
}

class PostModel {
  final String id;
  final String postType;
  final PostAuthor author;
  final String caption;
  final List<PostMedia> media;
  final String? service;
  final PostStats stats;
  final ViewerState viewerState;
  final String createdAt;

  PostModel({
    required this.id,
    required this.postType,
    required this.author,
    required this.caption,
    required this.media,
    this.service,
    required this.stats,
    required this.viewerState,
    required this.createdAt,
  });

  // --- FromMap Factory ---
  factory PostModel.fromMap(Map<String, dynamic> map) {
    return PostModel(
      id: map['id'] ?? '',
      postType: map['post_type'] ?? 'service',
      author: PostAuthor.fromMap(map['author'] ?? {}),
      caption: map['caption'] ?? '',
      media: List<PostMedia>.from(
        (map['media'] as List<dynamic>).map(
          (x) => PostMedia.fromMap(x as Map<String, dynamic>),
        ),
      ),
      service: map['service'],
      stats: PostStats.fromMap(map['stats'] ?? {}),
      viewerState: ViewerState.fromMap(map['viewer_state'] ?? {}),
      createdAt: map['created_at'] ?? '',
    );
  }

  // --- ToMap for CopyWith/Caching ---
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'post_type': postType,
      'author': author.toMap(),
      'caption': caption,
      'media': media.map((x) => x.toMap()).toList(),
      'service': service,
      'stats': stats.toMap(),
      'viewer_state': viewerState.toMap(),
      'created_at': createdAt,
    };
  }

  PostModel copyWith({
    String? id,
    String? postType,
    PostAuthor? author,
    String? caption,
    List<PostMedia>? media,
    String? service,
    PostStats? stats,
    ViewerState? viewerState,
    String? createdAt,
  }) {
    return PostModel(
      id: id ?? this.id,
      postType: postType ?? this.postType,
      author: author ?? this.author,
      caption: caption ?? this.caption,
      media: media ?? this.media,
      service: service ?? this.service,
      stats: stats ?? this.stats,
      viewerState: viewerState ?? this.viewerState,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}

// ---------------------------------------------------------------------------
// SUB-MODELS
// ---------------------------------------------------------------------------

class PostAuthor {
  final String userId;
  final String username;
  final bool isVerified;
  final String profilePicture;
  final SalonInfo? salon;

  PostAuthor({
    required this.userId,
    required this.username,
    required this.isVerified,
    required this.profilePicture,
    this.salon,
  });

  factory PostAuthor.fromMap(Map<String, dynamic> map) {
    return PostAuthor(
      userId: map['user_id'] ?? '',
      username: map['username'] ?? '',
      isVerified: map['is_verified'] ?? false,
      profilePicture: imageUrlOrEmpty(map['profile_picture']),
      salon: map['salon'] != null ? SalonInfo.fromMap(map['salon']) : null,
    );
  }

  Map<String, dynamic> toMap() => {
    'user_id': userId,
    'username': username,
    'is_verified': isVerified,
    'profile_picture': profilePicture,
    'salon': salon?.toMap(),
  };
}

class SalonInfo {
  final String id;
  final String title;
  // Note: You can add Address model here if needed

  SalonInfo({required this.id, required this.title});

  factory SalonInfo.fromMap(Map<String, dynamic> map) {
    return SalonInfo(id: map['id'] ?? '', title: map['title'] ?? '');
  }

  Map<String, dynamic> toMap() => {'id': id, 'title': title};
}

class PostMedia {
  final String url;
  final String type;
  final double aspectRatio;

  PostMedia({required this.url, required this.type, required this.aspectRatio});

  factory PostMedia.fromMap(Map<String, dynamic> map) {
    return PostMedia(
      url: imageUrlOrEmpty(map['url']),
      type: map['type'] ?? 'IMAGE',
      aspectRatio: (map['aspect_ratio'] as num?)?.toDouble() ?? 1.0,
    );
  }

  Map<String, dynamic> toMap() => {
    'url': url,
    'type': type,
    'aspect_ratio': aspectRatio,
  };
}

class PostStats {
  final int likes;
  final int comments;
  final int shares;

  PostStats({
    required this.likes,
    required this.comments,
    required this.shares,
  });

  factory PostStats.fromMap(Map<String, dynamic> map) {
    return PostStats(
      likes: map['likes'] ?? 0,
      comments: map['comments'] ?? 0,
      shares: map['shares'] ?? 0,
    );
  }

  Map<String, dynamic> toMap() => {
    'likes': likes,
    'comments': comments,
    'shares': shares,
  };
}

class ViewerState {
  final bool isLiked;
  final bool isSaved;
  final bool isMyPost;

  ViewerState({
    required this.isLiked,
    required this.isSaved,
    required this.isMyPost,
  });

  factory ViewerState.fromMap(Map<String, dynamic> map) {
    return ViewerState(
      isLiked: map['is_liked'] ?? false,
      isSaved: map['is_saved'] ?? false,
      isMyPost: map['is_my_post'] ?? false,
    );
  }

  Map<String, dynamic> toMap() => {
    'is_liked': isLiked,
    'is_saved': isSaved,
    'is_my_post': isMyPost,
  };
}
