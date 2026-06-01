// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class MajorServiceModel {
  MajorServiceModel({
    required this.id,
    required this.name,
    required this.fileName,
    required this.rated,
  });

  final String id;
  final String name;
  final String fileName;
  final double rated;

  MajorServiceModel copyWith({
    String? id,
    String? name,
    String? fileName,
    double? rated,
  }) {
    return MajorServiceModel(
      id: id ?? this.id,
      name: name ?? this.name,
      fileName: fileName ?? this.fileName,
      rated: rated ?? this.rated,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'fileName': fileName,
      'rated': rated,
    };
  }

  factory MajorServiceModel.fromMap(Map<String, dynamic> map) {
    return MajorServiceModel(
      id: map['id'] ?? "",
      name: map['name'] ?? "",
      fileName: map['fileName'] ?? "",
      rated: (map['rated'] as num?)?.toDouble() ?? 0.0,
    );
  }

  String toJson() => json.encode(toMap());

  factory MajorServiceModel.fromJson(String source) =>
      MajorServiceModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'MajorServiceModel(id: $id, name: $name, fileName: $fileName, rated: $rated)';
  }

  @override
  bool operator ==(covariant MajorServiceModel other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.name == name &&
        other.fileName == fileName &&
        other.rated == rated;
  }

  @override
  int get hashCode {
    return id.hashCode ^ name.hashCode ^ fileName.hashCode ^ rated.hashCode;
  }
}

// Minor Category Model

class PostMinorCategoriesModel {
  PostMinorCategoriesModel({
    required this.id,
    required this.serviceId,
    required this.name,
    required this.fileName,
    required this.description,
    required this.rated,
  });

  final String id;
  final String serviceId;
  final String name;
  final String fileName;
  final String description;
  final double rated;

  PostMinorCategoriesModel copyWith({
    String? id,
    String? serviceId,
    String? name,
    String? fileName,
    String? description,
    double? rated,
  }) {
    return PostMinorCategoriesModel(
      id: id ?? this.id,
      serviceId: serviceId ?? this.serviceId,
      name: name ?? this.name,
      fileName: fileName ?? this.fileName,
      description: description ?? this.description,
      rated: rated ?? this.rated,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'serviceId': serviceId,
      'name': name,
      'fileName': fileName,
      'description': description,
      'rated': rated,
    };
  }

  factory PostMinorCategoriesModel.fromMap(Map<String, dynamic> map) {
    return PostMinorCategoriesModel(
      id: map['id'] as String,
      serviceId: map['serviceId'] as String,
      name: map['name'] as String,
      fileName: map['fileName'] as String,
      description: map['description'] as String,
      rated: (map['rated'] as num?)?.toDouble() ?? 0.0,
    );
  }

  String toJson() => json.encode(toMap());

  factory PostMinorCategoriesModel.fromJson(String source) =>
      PostMinorCategoriesModel.fromMap(
        json.decode(source) as Map<String, dynamic>,
      );

  @override
  String toString() {
    return 'PostMinorCategoriesModel(id: $id, serviceId: $serviceId, name: $name, fileName: $fileName, description: $description, rated: $rated)';
  }

  @override
  bool operator ==(covariant PostMinorCategoriesModel other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.serviceId == serviceId &&
        other.name == name &&
        other.fileName == fileName &&
        other.description == description &&
        other.rated == rated;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        serviceId.hashCode ^
        name.hashCode ^
        fileName.hashCode ^
        description.hashCode ^
        rated.hashCode;
  }
}
