import 'dart:convert';

class HashtagHeaderModel {
  final String name;
  final int postCount;
  final bool isTrending;

  HashtagHeaderModel({
    required this.name,
    required this.postCount,
    required this.isTrending,
  });

  HashtagHeaderModel copyWith({
    String? name,
    int? postCount,
    bool? isTrending,
  }) {
    return HashtagHeaderModel(
      name: name ?? this.name,
      postCount: postCount ?? this.postCount,
      isTrending: isTrending ?? this.isTrending,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'post_count': postCount,
      'is_trending': isTrending,
    };
  }

  factory HashtagHeaderModel.fromMap(Map<String, dynamic> map) {
    return HashtagHeaderModel(
      name: map['name']?.toString() ?? '',
      postCount: (map['post_count'] as num?)?.toInt() ?? 0,
      isTrending: map['is_trending'] as bool? ?? false,
    );
  }

  String toJson() => json.encode(toMap());

  factory HashtagHeaderModel.fromJson(String source) =>
      HashtagHeaderModel.fromMap(json.decode(source));

  @override
  String toString() =>
      'HashtagHeaderModel(name: $name, postCount: $postCount, trending: $isTrending)';

  @override
  bool operator ==(covariant HashtagHeaderModel other) {
    if (identical(this, other)) return true;
    return other.name == name &&
        other.postCount == postCount &&
        other.isTrending == isTrending;
  }

  @override
  int get hashCode =>
      name.hashCode ^ postCount.hashCode ^ isTrending.hashCode;
}



class HashtagPostTileModel {
  final String postId;
  final String imageUrl;

  HashtagPostTileModel({
    required this.postId,
    required this.imageUrl,
  });

  HashtagPostTileModel copyWith({
    String? postId,
    String? imageUrl,
  }) {
    return HashtagPostTileModel(
      postId: postId ?? this.postId,
      imageUrl: imageUrl ?? this.imageUrl,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'post_id': postId,
      'image': {
        'url': imageUrl,
      },
    };
  }

  factory HashtagPostTileModel.fromMap(Map<String, dynamic> map) {
    return HashtagPostTileModel(
      postId: map['post_id']?.toString() ?? '',
      imageUrl: map['image'] != null
          ? map['image']['url']?.toString() ?? ''
          : '',
    );
  }

  @override
  String toString() =>
      'HashtagPostTileModel(postId: $postId, imageUrl: $imageUrl)';

  @override
  bool operator ==(covariant HashtagPostTileModel other) {
    if (identical(this, other)) return true;
    return other.postId == postId &&
        other.imageUrl == imageUrl;
  }

  @override
  int get hashCode => postId.hashCode ^ imageUrl.hashCode;
}



class HashtagGridModel {
  final HashtagHeaderModel hashtag;
  final List<HashtagPostTileModel> posts;
  final String? cursor;

  HashtagGridModel({
    required this.hashtag,
    required this.posts,
    this.cursor,
  });

  HashtagGridModel copyWith({
    HashtagHeaderModel? hashtag,
    List<HashtagPostTileModel>? posts,
    String? cursor,
  }) {
    return HashtagGridModel(
      hashtag: hashtag ?? this.hashtag,
      posts: posts ?? this.posts,
      cursor: cursor ?? this.cursor,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'hashtag': hashtag.toMap(),
      'posts': posts.map((x) => x.toMap()).toList(),
      'cursor': cursor,
    };
  }

  factory HashtagGridModel.fromMap(Map<String, dynamic> map) {
    return HashtagGridModel(
      hashtag: HashtagHeaderModel.fromMap(
        map['hashtag'] as Map<String, dynamic>,
      ),
      posts: map['posts'] is List
          ? List<HashtagPostTileModel>.from(
              (map['posts'] as List)
                  .map((x) => HashtagPostTileModel.fromMap(
                        x as Map<String, dynamic>,
                      )),
            )
          : [],
      cursor: map['cursor']?.toString(),
    );
  }

  String toJson() => json.encode(toMap());

  factory HashtagGridModel.fromJson(String source) =>
      HashtagGridModel.fromMap(json.decode(source));

  @override
  String toString() =>
      'HashtagGridModel(posts: ${posts.length}, cursor: $cursor)';
}
