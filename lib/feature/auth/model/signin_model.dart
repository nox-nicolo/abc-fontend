// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class SigninModel {

  SigninModel(
    {
      required this.userId,
      required this.accessToken,
      required this.refreshToken,
      required this.tokenType,
    }
  );

  final String userId;
  final String accessToken;
  final String refreshToken;
  final String tokenType; 

  SigninModel copyWith({
    String? userId,
    String? accessToken,
    String? id,
    String? refreshToken,
    String? tokenType,
  }) {
    return SigninModel(
      userId: userId ?? this.userId,
      accessToken: accessToken ?? this.accessToken,
      refreshToken: refreshToken ?? this.refreshToken,
      tokenType: tokenType ?? this.tokenType,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'userId': userId,
      'accessToken': accessToken,
      'refreshToken': refreshToken,
      'tokenType': tokenType,
    };
  }

  factory SigninModel.fromMap(Map<String, dynamic> map) {
    return SigninModel(
      userId: map['user_id'] ?? "",
      accessToken: map['access_token'] ?? "",
      refreshToken: map['refresh_token'] ?? "",
      tokenType: map['token_type'] ?? "",
    );
  }

  String toJson() => json.encode(toMap());

  factory SigninModel.fromJson(String source) => SigninModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override 
  String toString() {
    return 'SigninModel(userId: $userId, accessToken: $accessToken, refreshToken: $refreshToken, tokenType: $tokenType)';
  }

  @override 
  bool operator ==(covariant SigninModel other) {
    if (identical(this, other)) return true;
  
    return 
      other.userId == userId &&
      other.accessToken == accessToken &&
      other.refreshToken == refreshToken &&
      other.tokenType == tokenType;
  }

  @override 
  int get hashCode {
    return userId.hashCode ^
      accessToken.hashCode ^
      refreshToken.hashCode ^
      tokenType.hashCode;
  }
  
}
