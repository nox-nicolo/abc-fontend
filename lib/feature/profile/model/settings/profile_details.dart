import 'dart:convert';

class SalonProfileUpdate {
  final String title;
  final String slogan;
  final String description;

  SalonProfileUpdate({
    required this.title,
    required this.slogan,
    required this.description,
  });

  factory SalonProfileUpdate.fromMap(Map<String, dynamic> map) {
    return SalonProfileUpdate(
      title: map['title']?.toString() ?? '',
      slogan: map['slogan']?.toString() ?? '',
      description: map['description']?.toString() ?? '',
    );
  }

  factory SalonProfileUpdate.fromJson(String source) => 
      SalonProfileUpdate.fromMap(json.decode(source) as Map<String, dynamic>);
}