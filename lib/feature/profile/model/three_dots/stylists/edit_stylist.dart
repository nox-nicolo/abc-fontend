import 'dart:convert';

EditSalonStylistRequest editSalonStylistRequestFromJson(String str) =>
    EditSalonStylistRequest.fromJson(json.decode(str) as Map<String, dynamic>);

String editSalonStylistRequestToJson(EditSalonStylistRequest data) =>
    json.encode(data.toJson());

class EditSalonStylistRequest {
  final String title;
  final String bio;
  final bool isOwner;
  final bool isActive;

  const EditSalonStylistRequest({
    required this.title,
    required this.bio,
    required this.isOwner,
    required this.isActive,
  });

  factory EditSalonStylistRequest.fromJson(Map<String, dynamic> json) {
    return EditSalonStylistRequest(
      title: json['title'] as String? ?? '',
      bio: json['bio'] as String? ?? '',
      isOwner: json['is_owner'] as bool? ?? false,
      isActive: json['is_active'] as bool? ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title.trim(),
      'bio': bio.trim(),
      'is_owner': isOwner,
      'is_active': isActive,
    };
  }

  Map<String, dynamic> toMap() => toJson();

  EditSalonStylistRequest copyWith({
    String? title,
    String? bio,
    bool? isOwner,
    bool? isActive,
  }) {
    return EditSalonStylistRequest(
      title: title ?? this.title,
      bio: bio ?? this.bio,
      isOwner: isOwner ?? this.isOwner,
      isActive: isActive ?? this.isActive,
    );
  }
}