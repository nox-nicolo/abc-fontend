// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class VerificationModel {

  VerificationModel(
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

  VerificationModel copyWith({
    String? userId,
    String? accessToken,
    String? id,
    String? refreshToken,
    String? tokenType,
  }) {
    return VerificationModel(
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

  factory VerificationModel.fromMap(Map<String, dynamic> map) {
    return VerificationModel(
      userId: map['user_id'] ?? "",
      accessToken: map['access_token'] ?? "",
      refreshToken: map['refresh_token'] ?? "",
      tokenType: map['token_type'] ?? "",
    );
  }

  String toJson() => json.encode(toMap());

  factory VerificationModel.fromJson(String source) => VerificationModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override 
  String toString() {
    return 'VerificationModel(userId: $userId, accessToken: $accessToken, refreshToken: $refreshToken, tokenType: $tokenType)';
  }

  @override 
  bool operator ==(covariant VerificationModel other) {
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




class VerificationCodeModel {

  VerificationCodeModel( 
    {
      required this.code,
    }
    
  );

  final String code;

  VerificationCodeModel copyWith({
    String? code,
  }) {
    return VerificationCodeModel(
      code: code ?? this.code
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic> {
      'code': code
    };
  }

  factory VerificationCodeModel.fromMap(Map<String, dynamic> map) {
    return VerificationCodeModel(
      code: map["map"] ?? "",
    );
  }

  String toJson() => json.encode(toMap());

  factory VerificationCodeModel.fromJson(String source) => VerificationCodeModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override 
  String toString() => 'VerificationCodeModel(code: $code)';

  @override 
  bool operator == (covariant VerificationCodeModel other) {
   if (identical(this, other)) return true; 

   return other.code == code;
  }

  @override 
  int get hashCode => code.hashCode;

  
}