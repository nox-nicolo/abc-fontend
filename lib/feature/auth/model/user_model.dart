// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class UserModel {

  UserModel(
    {
      required this.name,
      required this.email,
      required this.id,
      required this.role,
      required this.username,
    }
  );

  final String name;
  final String email;
  final String id;
  final String role;
  final String username; 

  UserModel copyWith({
    String? name,
    String? email,
    String? id,
    String? role,
    String? username,
  }) {
    return UserModel(
      name: name ?? this.name,
      email: email ?? this.email,
      id: id ?? this.id,
      role: role ?? this.role,
      username: username ?? this.username,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'email': email,
      'id': id,
      'role': role,
      'username': username,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      name: map['name'] as String,
      email: map['email'] as String,
      id: map['id'] as String,
      role: map['role'] as String,
      username: map['username'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory UserModel.fromJson(String source) => UserModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override 
  String toString() {
    return 'UserModel(name: $name, email: $email, id: $id, role: $role, username: $username)';
  }

  @override 
  bool operator ==(covariant UserModel other) {
    if (identical(this, other)) return true;
  
    return 
      other.name == name &&
      other.email == email &&
      other.id == id &&
      other.role == role &&
      other.username == username;
  }

  @override 
  int get hashCode {
    return name.hashCode ^
      email.hashCode ^
      id.hashCode ^
      role.hashCode ^
      username.hashCode;
  }
  
}
