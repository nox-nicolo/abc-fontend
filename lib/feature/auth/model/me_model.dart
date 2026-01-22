
import 'dart:convert';

class MeModel {
  MeModel(
    {
      required this.id, 
      required this.username, 
      required this.phone, 
      required this.role, 
      required this.profilePicture 
    }
  );

  final String id; 
  final String username; 
  final String phone; 
  final String role; 
  final String profilePicture; 

  MeModel copyWith({
    String? id,
    String? username,
    String? phone,
    String? role,
    String? profilePicture,
  }) {
    return MeModel(
      id: id ?? this.id,
      username: username ?? this.username,
      phone: phone ?? this.phone,
      role: role ?? this.role,
      profilePicture: profilePicture ?? this.profilePicture,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'username': username,
      'phone': phone,
      'role': role,
      'profile_picture': profilePicture,
    };
  }

  factory MeModel.fromMap(Map<String, dynamic> map) {
    return MeModel(
      id: map['id'] ?? "",
      username: map['username'] ?? "",
      phone: map['phone'] ?? "",
      role: map['role'] ?? "",
      profilePicture: map['profile_picture'] ?? "",
    );
  }

  String toJson() => json.encode(toMap()); 

  factory MeModel.fromJson(String source) => MeModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'MeModel(id: $id, username: $username, phone: $phone, role: $role, profilePicture: $profilePicture)';
  }

  @override
  bool operator ==(covariant MeModel other) {
    if (identical(this, other)) return true;

    return 
      other.id == id &&
      other.username == username &&
      other.phone == phone &&
      other.role == role &&
      other.profilePicture == profilePicture;
  }

  @override
  int get hashCode {
    return id.hashCode ^
      username.hashCode ^
      phone.hashCode ^
      role.hashCode ^
      profilePicture.hashCode;
  }
  

}

