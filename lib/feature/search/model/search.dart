// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';


enum SearchEntityType {
  user,
  salon,
  service,
  hashtag,
}


sealed class SearchResult {
  final String id;
  final SearchEntityType entity;
  final double? score;

  const SearchResult({
    required this.id,
    required this.entity,
    this.score,
  });

  /// Polymorphic factory
  factory SearchResult.fromMap(Map<String, dynamic> map) {
    final type = map['entity'] as String?;

    return switch (type) {
      'user' => SearchUserResult.fromMap(map),
      'salon' => SearchSalonResult.fromMap(map),
      'service' => SearchServiceResult.fromMap(map),
      'hashtag' => SearchHashtagResult.fromMap(map),
      _ => throw Exception('Unknown search entity type: $type'),
    };
  }

  Map<String, dynamic> toMap();

  String toJson() => json.encode(toMap());
}


class SearchUserResult extends SearchResult {
  final String username;
  final String? fullName;
  final String? avatarUrl;

  const SearchUserResult({
    required super.id,
    super.score,
    required this.username,
    this.fullName,
    this.avatarUrl,
  }) : super(entity: SearchEntityType.user);

  SearchUserResult copyWith({
    String? id,
    double? score,
    String? username,
    String? fullName,
    String? avatarUrl,
  }) {
    return SearchUserResult(
      id: id ?? this.id,
      score: score ?? this.score,
      username: username ?? this.username,
      fullName: fullName ?? this.fullName,
      avatarUrl: avatarUrl ?? this.avatarUrl,
    );
  }

  factory SearchUserResult.fromMap(Map<String, dynamic> map) {
    return SearchUserResult(
      id: map['id'] ?? '',
      score: (map['score'] as num?)?.toDouble(),
      username: map['username'] ?? '',
      fullName: map['fullName'],
      avatarUrl: map['avatarUrl'],
    );
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'entity': entity.name,
      'score': score,
      'username': username,
      'fullName': fullName,
      'avatarUrl': avatarUrl,
    };
  }

  @override
  bool operator ==(covariant SearchUserResult other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.score == score &&
        other.username == username &&
        other.fullName == fullName &&
        other.avatarUrl == avatarUrl;
  }

  @override
  int get hashCode =>
      id.hashCode ^
      score.hashCode ^
      username.hashCode ^
      fullName.hashCode ^
      avatarUrl.hashCode;
}


class SearchSalonResult extends SearchResult {
  final String slogan;
  final String? title;
  final String? coverImage;
  final bool isVerified;
  final String ownerName;

  const SearchSalonResult({
    required super.id,
    super.score,
    required this.slogan,
    this.title,
    this.coverImage,
    required this.isVerified,
    required this.ownerName,
  }) : super(entity: SearchEntityType.salon);

  SearchSalonResult copyWith({
    String? id,
    double? score,
    String? slogan,
    String? title,
    String? coverImage,
    bool? isVerified,
    String? ownerName,
  }) {
    return SearchSalonResult(
      id: id ?? this.id,
      score: score ?? this.score,
      slogan: slogan ?? this.slogan,
      title: title ?? this.title,
      coverImage: coverImage ?? this.coverImage,
      isVerified: isVerified ?? this.isVerified,
      ownerName: ownerName ?? this.ownerName,
    );
  }

  factory SearchSalonResult.fromMap(Map<String, dynamic> map) {
    return SearchSalonResult(
      id: map['id'] ?? '',
      score: (map['score'] as num?)?.toDouble(),
      slogan: map['slogan'] ?? '',
      title: map['title'],
      coverImage: map['coverImage'],
      isVerified: map['isVerified'] ?? false,
      ownerName: map['ownerName'] ?? '',
    );
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'entity': entity.name,
      'score': score,
      'slogan': slogan,
      'title': title,
      'coverImage': coverImage,
      'isVerified': isVerified,
      'ownerName': ownerName,
    };
  }

  @override
  bool operator ==(covariant SearchSalonResult other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.score == score &&
        other.slogan == slogan &&
        other.title == title &&
        other.coverImage == coverImage &&
        other.isVerified == isVerified &&
        other.ownerName == ownerName;
  }

  @override
  int get hashCode =>
      id.hashCode ^
      score.hashCode ^
      slogan.hashCode ^
      title.hashCode ^
      coverImage.hashCode ^
      isVerified.hashCode ^
      ownerName.hashCode;
}


class SearchServiceResult extends SearchResult {
  final String serviceName;
  final String category;
  final String? parentServiceName;
  final double? priceMin;
  final double? priceMax;
  final String? imageUrl;

  const SearchServiceResult({
    required super.id,
    super.score,
    required this.serviceName,
    required this.category,
    this.parentServiceName,
    this.priceMin,
    this.priceMax,
    this.imageUrl,
  }) : super(entity: SearchEntityType.service);

  SearchServiceResult copyWith({
    String? id,
    double? score,
    String? serviceName,
    String? category,
    String? parentServiceName,
    double? priceMin,
    double? priceMax,
    String? imageUrl,
  }) {
    return SearchServiceResult(
      id: id ?? this.id,
      score: score ?? this.score,
      serviceName: serviceName ?? this.serviceName,
      category: category ?? this.category,
      parentServiceName: parentServiceName ?? this.parentServiceName,
      priceMin: priceMin ?? this.priceMin,
      priceMax: priceMax ?? this.priceMax,
      imageUrl: imageUrl ?? this.imageUrl,
    );
  }

  factory SearchServiceResult.fromMap(Map<String, dynamic> map) {
    return SearchServiceResult(
      id: map['id'] ?? '',
      score: (map['score'] as num?)?.toDouble(),
      serviceName: map['serviceName'] ?? '',
      category: map['category'] ?? '',
      parentServiceName: map['parentServiceName'],
      priceMin: (map['priceMin'] as num?)?.toDouble(),
      priceMax: (map['priceMax'] as num?)?.toDouble(),
      imageUrl: map['imageUrl'],
    );
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'entity': entity.name,
      'score': score,
      'serviceName': serviceName,
      'category': category,
      'parentServiceName': parentServiceName,
      'priceMin': priceMin,
      'priceMax': priceMax,
      'imageUrl': imageUrl,
    };
  }

  @override
  bool operator ==(covariant SearchServiceResult other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.score == score &&
        other.serviceName == serviceName &&
        other.category == category &&
        other.parentServiceName == parentServiceName &&
        other.priceMin == priceMin &&
        other.priceMax == priceMax &&
        other.imageUrl == imageUrl;
  }

  @override
  int get hashCode =>
      id.hashCode ^
      score.hashCode ^
      serviceName.hashCode ^
      category.hashCode ^
      parentServiceName.hashCode ^
      priceMin.hashCode ^
      priceMax.hashCode ^
      imageUrl.hashCode;
}


class SearchHashtagResult extends SearchResult {
  final String tag;
  final int postCount;

  const SearchHashtagResult({
    required super.id,
    super.score,
    required this.tag,
    required this.postCount,
  }) : super(entity: SearchEntityType.hashtag);

  SearchHashtagResult copyWith({
    String? id,
    double? score,
    String? tag,
    int? postCount,
  }) {
    return SearchHashtagResult(
      id: id ?? this.id,
      score: score ?? this.score,
      tag: tag ?? this.tag,
      postCount: postCount ?? this.postCount,
    );
  }

  factory SearchHashtagResult.fromMap(Map<String, dynamic> map) {
    return SearchHashtagResult(
      id: map['id'] ?? '',
      score: (map['score'] as num?)?.toDouble(),
      tag: map['tag'] ?? '',
      postCount: map['postCount'] ?? 0,
    );
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'entity': entity.name,
      'score': score,
      'tag': tag,
      'postCount': postCount,
    };
  }

  @override
  bool operator ==(covariant SearchHashtagResult other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.score == score &&
        other.tag == tag &&
        other.postCount == postCount;
  }

  @override
  int get hashCode =>
      id.hashCode ^
      score.hashCode ^
      tag.hashCode ^
      postCount.hashCode;
}
