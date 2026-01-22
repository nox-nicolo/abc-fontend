// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class BookingStyleModel {
  BookingStyleModel({
    required this.id,
    required this.name,
    required this.image,
  });

  final String id;
  final String name;
  final String image;

  // ----------------------------------------
  // copyWith
  // ----------------------------------------
  BookingStyleModel copyWith({
    String? id,
    String? name,
    String? image,
  }) {
    return BookingStyleModel(
      id: id ?? this.id,
      name: name ?? this.name,
      image: image ?? this.image,
    );
  }

  // ----------------------------------------
  // toMap
  // ----------------------------------------
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'image': image,
    };
  }

  // ----------------------------------------
  // fromMap (DEFENSIVE)
  // ----------------------------------------
  factory BookingStyleModel.fromMap(Map<String, dynamic> map) {
    return BookingStyleModel(
      id: map['id']?.toString() ?? '',
      name: map['name']?.toString() ?? '',
      image: map['image']?.toString() ??
          map['file_name']?.toString() ??
          '',
    );
  }

  // ----------------------------------------
  // JSON helpers
  // ----------------------------------------
  String toJson() => json.encode(toMap());

  factory BookingStyleModel.fromJson(String source) =>
      BookingStyleModel.fromMap(
        json.decode(source) as Map<String, dynamic>,
      );

  @override
  String toString() {
    return 'BookingStyleModel(id: $id, name: $name, image: $image)';
  }

  @override
  bool operator ==(covariant BookingStyleModel other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.name == name &&
        other.image == image;
  }

  @override
  int get hashCode =>
      id.hashCode ^ name.hashCode ^ image.hashCode;
}
