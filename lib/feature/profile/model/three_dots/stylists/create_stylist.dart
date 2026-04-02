import 'dart:convert';

CreateSalonStylistRequest createSalonStylistRequestFromJson(String str) =>
    CreateSalonStylistRequest.fromJson(json.decode(str) as Map<String, dynamic>);

String createSalonStylistRequestToJson(CreateSalonStylistRequest data) =>
    json.encode(data.toJson());

CreateSalonStylistResponse createSalonStylistResponseFromJson(String str) =>
    CreateSalonStylistResponse.fromJson(json.decode(str) as Map<String, dynamic>);

String createSalonStylistResponseToJson(CreateSalonStylistResponse data) =>
    json.encode(data.toJson());

class CreateSalonStylistRequest {
  final String title;
  final String bio;
  final bool isOwner;
  final bool isActive;
  final String userId;

  const CreateSalonStylistRequest({
    required this.title,
    required this.bio,
    required this.isOwner,
    required this.isActive,
    required this.userId,
  });

  factory CreateSalonStylistRequest.fromJson(Map<String, dynamic> json) {
    return CreateSalonStylistRequest(
      title: json['title'] as String? ?? '',
      bio: json['bio'] as String? ?? '',
      isOwner: json['is_owner'] as bool? ?? false,
      isActive: json['is_active'] as bool? ?? true,
      userId: json['user_id'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title.trim(),
      'bio': bio.trim(),
      'is_owner': isOwner,
      'is_active': isActive,
      'user_id': userId,
    };
  }

  Map<String, dynamic> toMap() => toJson();

  CreateSalonStylistRequest copyWith({
    String? title,
    String? bio,
    bool? isOwner,
    bool? isActive,
    String? userId,
  }) {
    return CreateSalonStylistRequest(
      title: title ?? this.title,
      bio: bio ?? this.bio,
      isOwner: isOwner ?? this.isOwner,
      isActive: isActive ?? this.isActive,
      userId: userId ?? this.userId,
    );
  }
}

class CreateSalonStylistResponse {
  final String message;

  const CreateSalonStylistResponse({
    required this.message,
  });

  factory CreateSalonStylistResponse.fromJson(Map<String, dynamic> json) {
    return CreateSalonStylistResponse(
      message: json['message'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'message': message,
    };
  }

  CreateSalonStylistResponse copyWith({
    String? message,
  }) {
    return CreateSalonStylistResponse(
      message: message ?? this.message,
    );
  }
}