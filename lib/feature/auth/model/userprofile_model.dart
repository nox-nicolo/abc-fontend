
import 'dart:convert';

class SetAccountModel {
  SetAccountModel(
    {
      required this.pictureUrl, 
      required this.username, 
    }
  );

  final String pictureUrl; 
  final String username; 

  SetAccountModel copyWith({
    String? pictureUrl,
    String? username,
  }) {
    return SetAccountModel(
      pictureUrl: pictureUrl ?? this.pictureUrl,
      username: username ?? this.username,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'pictureUrl': pictureUrl,
      'username': username,
    };
  }

  factory SetAccountModel.fromMap(Map<String, dynamic> map) {
    return SetAccountModel(
      pictureUrl: map['pictureUrl'] ?? "",
      username: map['username'] ?? "",
    );
  }

  String toJson() => json.encode(toMap()); 

  factory SetAccountModel.fromJson(String source) => SetAccountModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'SetAccountModel(pictureUrl: $pictureUrl, username: $username)';
  }

  @override
  bool operator ==(covariant SetAccountModel other) {
    if (identical(this, other)) return true;

    return 
      other.pictureUrl == pictureUrl &&
      other.username == username;
  }

  @override
  int get hashCode {
    return pictureUrl.hashCode ^
      username.hashCode ;
  }
  

}




class UploadAccountModel {
  UploadAccountModel(
    {
      required this.message, 
    }
  );

  final String message; 

  UploadAccountModel copyWith({
    String? message,
  }) {
    return UploadAccountModel(
      message: message ?? this.message,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'message': message,
    };
  }

  factory UploadAccountModel.fromMap(Map<String, dynamic> map) {
    return UploadAccountModel(
      message: map['message'] ?? "",
    );
  }

  String toJson() => json.encode(toMap()); 

  factory UploadAccountModel.fromJson(String source) => UploadAccountModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'UploadAccountModel( message: $message)';
  }

  @override
  bool operator ==(covariant UploadAccountModel other) {
    if (identical(this, other)) return true;

    return 
      other.message == message;
  }

  @override
  int get hashCode {
    return 
      message.hashCode ;
  }
  

}



class UploadServiceModel {
  UploadServiceModel(
    {
      required this.message, 
    }
  );

  final String message; 

  UploadServiceModel copyWith({
    String? message,
  }) {
    return UploadServiceModel(
      message: message ?? this.message,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'message': message,
    };
  }

  factory UploadServiceModel.fromMap(Map<String, dynamic> map) {
    return UploadServiceModel(
      message: map['message'] ?? "",
    );
  }

  String toJson() => json.encode(toMap()); 

  factory UploadServiceModel.fromJson(String source) => UploadServiceModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'UploadServiceModel( message: $message)';
  }

  @override
  bool operator ==(covariant UploadServiceModel other) {
    if (identical(this, other)) return true;

    return 
      other.message == message;
  }

  @override
  int get hashCode {
    return 
      message.hashCode ;
  }
  

}