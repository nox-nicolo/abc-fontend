// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

// Model for tagging people in posts
class PostTagPeopleModel {
  final String id;
  final String username; 
  final String name; 
  final String profilePicture;

  PostTagPeopleModel({
    required this.id,
    required this.username,
    required this.name,
    required this.profilePicture,
  });

  PostTagPeopleModel copyWith({
    String? id,
    String? username,
    String? name,
    String? profilePicture,
  }) {
    return PostTagPeopleModel(
      id: id ?? this.id,
      username: username ?? this.username,
      name: name ?? this.name,
      profilePicture: profilePicture ?? this.profilePicture,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'username': username,
      'name': name,
      'profilePicture': profilePicture,
    };
  }

  factory PostTagPeopleModel.fromMap(Map<String, dynamic> map) {
    return PostTagPeopleModel(
      id: map['id'] as String,
      username: map['username'] as String,
      name: map['name'] as String,
      profilePicture: map['profilePicture'] as String,
    );
  }

  String toJson() => json.encode(toMap());
  factory PostTagPeopleModel.fromJson(String source) => PostTagPeopleModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'PostTagPeopleModel(id: $id, username: $username, name: $name, profilePicture: $profilePicture)';
  }

  @override
  bool operator ==(covariant PostTagPeopleModel other) {
    if (identical(this, other)) return true;
    
    // An object is uniquely identified by its ID.
    return other.id == id;
  }

  // Senior dev style: Use only the unique ID for hashcode calculation
  @override
  int get hashCode {
    return id.hashCode;
  }
}