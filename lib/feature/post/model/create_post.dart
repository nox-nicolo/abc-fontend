// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:africa_beuty/feature/post/model/post_settings.dart';

class PostMedia {
  final String path;
  final double aspectRatio;
  final String type;

  const PostMedia({
    required this.path,
    required this.aspectRatio,
    required this.type,
  });

  PostMedia copyWith({String? path, double? aspectRatio, String? type}) {
    return PostMedia(
      path: path ?? this.path,
      aspectRatio: aspectRatio ?? this.aspectRatio,
      type: type ?? this.type,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'path': path,
      'aspectRatio': aspectRatio,
      'type': type,
    };
  }

  factory PostMedia.fromMap(Map<String, dynamic> map) {
    return PostMedia(
      path: map['path'] ?? "",
      aspectRatio: (map['aspectRatio'] ?? 1.0).toDouble(),
      type: map['type'] ?? "image",
    );
  }

  String toJson() => json.encode(toMap());

  factory PostMedia.fromJson(String source) =>
      PostMedia.fromMap(json.decode(source));

  @override
  String toString() =>
      'PostMedia(path: $path, aspectRatio: $aspectRatio, type: $type)';

  @override
  bool operator ==(covariant PostMedia other) {
    if (identical(this, other)) return true;

    return other.path == path &&
        other.aspectRatio == aspectRatio &&
        other.type == type;
  }

  @override
  int get hashCode => path.hashCode ^ aspectRatio.hashCode ^ type.hashCode;
}

class CreatePostModel {
  final PostSettings settings;
  final String author;
  final String status;
  final String postType;
  final String category;
  final String caption;
  final List<String> hashtags;
  final List<String> tagged;
  final List<PostMedia> media;

  const CreatePostModel({
    required this.settings,
    required this.author,
    required this.status,
    required this.postType,
    required this.category,
    required this.caption,
    required this.hashtags,
    required this.tagged,
    required this.media,
  });

  CreatePostModel copyWith({
    PostSettings? settings,
    String? author,
    String? status,
    String? postType,
    String? category,
    String? caption,
    List<String>? hashtags,
    List<String>? tagged,
    List<PostMedia>? media,
  }) {
    return CreatePostModel(
      settings: settings ?? this.settings,
      author: author ?? this.author,
      status: status ?? this.status,
      postType: postType ?? this.postType,
      category: category ?? this.category,
      caption: caption ?? this.caption,
      hashtags: hashtags ?? this.hashtags,
      tagged: tagged ?? this.tagged,
      media: media ?? this.media,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'settings': settings.toMap(),
      'author': author,
      'status': status,
      'postType': postType,
      'category': category,
      'caption': caption,
      'hashtags': hashtags,
      'tagged': tagged,
      'media': media.map((x) => x.toMap()).toList(),
    };
  }

  factory CreatePostModel.fromMap(Map<String, dynamic> map) {
    return CreatePostModel(
      settings: PostSettings.fromMap(map['settings']),
      author: map['author'] ?? "",
      status: map['status'] ?? "",
      postType: map['postType'] ?? map['post_type'] ?? "service",
      category: map['category'] ?? "",
      caption: map['caption'] ?? "",
      hashtags: List<String>.from(map['hashtags'] ?? []),
      tagged: List<String>.from(map['tagged'] ?? []),
      media: (map['media'] as List<dynamic>? ?? [])
          .map((e) => PostMedia.fromMap(e))
          .toList(),
    );
  }

  String toJson() => json.encode(toMap());

  factory CreatePostModel.fromJson(String source) =>
      CreatePostModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'CreatePostModel(settings: $settings, author: $author, status: $status, postType: $postType, category: $category, caption: $caption, hashtags: $hashtags, tagged: $tagged, media: $media)';
  }

  @override
  bool operator ==(covariant CreatePostModel other) {
    if (identical(this, other)) return true;

    return other.settings == settings &&
        other.author == author &&
        other.status == status &&
        other.postType == postType &&
        other.category == category &&
        other.caption == caption &&
        other.hashtags == hashtags &&
        other.tagged == tagged &&
        other.media == media;
  }

  @override
  int get hashCode {
    return settings.hashCode ^
        author.hashCode ^
        status.hashCode ^
        postType.hashCode ^
        category.hashCode ^
        caption.hashCode ^
        hashtags.hashCode ^
        tagged.hashCode ^
        media.hashCode;
  }
}
