import 'dart:convert';

StylistSearchResponse stylistSearchResponseFromJson(String str) =>
    StylistSearchResponse.fromJson(json.decode(str) as Map<String, dynamic>);

String stylistSearchResponseToJson(StylistSearchResponse data) =>
    json.encode(data.toJson());

class StylistSearchResponse {
  final List<StylistSearchItem> items;
  final String query;
  final int count;

  const StylistSearchResponse({
    required this.items,
    required this.query,
    required this.count,
  });

  factory StylistSearchResponse.fromJson(Map<String, dynamic> json) {
    return StylistSearchResponse(
      items: (json['items'] as List<dynamic>? ?? [])
          .map((e) => StylistSearchItem.fromJson(e as Map<String, dynamic>))
          .toList(),
      query: json['query'] as String? ?? '',
      count: json['count'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'items': items.map((e) => e.toJson()).toList(),
      'query': query,
      'count': count,
    };
  }

  StylistSearchResponse copyWith({
    List<StylistSearchItem>? items,
    String? query,
    int? count,
  }) {
    return StylistSearchResponse(
      items: items ?? this.items,
      query: query ?? this.query,
      count: count ?? this.count,
    );
  }
}

class StylistSearchItem {
  final String id;
  final String username;
  final String name;
  final StylistSearchProfilePicture? profilePicture;
  final String profilePictureUrl;

  const StylistSearchItem({
    required this.id,
    required this.username,
    required this.name,
    required this.profilePicture,
    required this.profilePictureUrl,
  });

  factory StylistSearchItem.fromJson(Map<String, dynamic> json) {
    return StylistSearchItem(
      id: json['id'] as String? ?? '',
      username: json['username'] as String? ?? '',
      name: json['name'] as String? ?? '',
      profilePicture: json['profile_picture'] != null
          ? StylistSearchProfilePicture.fromJson(
              json['profile_picture'] as Map<String, dynamic>,
            )
          : null,
      profilePictureUrl: json['profile_picture_url'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'name': name,
      'profile_picture': profilePicture?.toJson(),
      'profile_picture_url': profilePictureUrl,
    };
  }

  StylistSearchItem copyWith({
    String? id,
    String? username,
    String? name,
    StylistSearchProfilePicture? profilePicture,
    String? profilePictureUrl,
  }) {
    return StylistSearchItem(
      id: id ?? this.id,
      username: username ?? this.username,
      name: name ?? this.name,
      profilePicture: profilePicture ?? this.profilePicture,
      profilePictureUrl: profilePictureUrl ?? this.profilePictureUrl,
    );
  }
}

class StylistSearchProfilePicture {
  final String id;
  final String fileName;

  const StylistSearchProfilePicture({
    required this.id,
    required this.fileName,
  });

  factory StylistSearchProfilePicture.fromJson(Map<String, dynamic> json) {
    return StylistSearchProfilePicture(
      id: json['id'] as String? ?? '',
      fileName: json['file_name'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'file_name': fileName,
    };
  }

  StylistSearchProfilePicture copyWith({
    String? id,
    String? fileName,
  }) {
    return StylistSearchProfilePicture(
      id: id ?? this.id,
      fileName: fileName ?? this.fileName,
    );
  }
}