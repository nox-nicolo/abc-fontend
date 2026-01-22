import 'dart:convert';

class PostLikeModel {
  PostLikeModel({
    required this.postId,
    required this.liked,
    required this.likesCount,
  });

  final String postId;
  final bool liked;
  final int likesCount;

  PostLikeModel copyWith({
    String? postId,
    bool? liked,
    int? likesCount,
  }) {
    return PostLikeModel(
      postId: postId ?? this.postId,
      liked: liked ?? this.liked,
      likesCount: likesCount ?? this.likesCount,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'post_id': postId,
      'liked': liked,
      'likes_count': likesCount,
    };
  }

  factory PostLikeModel.fromMap(Map<String, dynamic> map) {
    return PostLikeModel(
      postId: map['post_id'] ?? '',
      liked: map['liked'] ?? false,
      likesCount: map['likes_count'] ?? 0,
    );
  }

  String toJson() => json.encode(toMap());

  factory PostLikeModel.fromJson(String source) =>
      PostLikeModel.fromMap(json.decode(source));
}
