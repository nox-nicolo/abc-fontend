import 'dart:convert';

class SalonGalleryUpdate {
  final List<String> imageUrls;

  SalonGalleryUpdate({required this.imageUrls});

  factory SalonGalleryUpdate.fromMap(Map<String, dynamic> map) {
    return SalonGalleryUpdate(
      imageUrls: List<String>.from(map['gallery_images'] ?? []),
    );
  }

  factory SalonGalleryUpdate.fromJson(String source) => 
      SalonGalleryUpdate.fromMap(json.decode(source));
}