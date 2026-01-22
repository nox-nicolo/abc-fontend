import 'dart:convert';

class PostHashtagsModel {
  final String name;
  final int number;

  PostHashtagsModel({
    required this.name,
    required this.number,
  });

  PostHashtagsModel copyWith({
    String? name,
    int? number,
  }) {
    return PostHashtagsModel(
      name: name ?? this.name,
      number: number ?? this.number,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name, 
      'number': number,
    };
  }

  factory PostHashtagsModel.fromMap(Map<String, dynamic> map) {
    return PostHashtagsModel(
      name: map['name'] ?? "",
      number: map['number'] ?? 0,
    );
  }

  String toJson() => json.encode(toMap()); 

  factory PostHashtagsModel.fromJson(String source) => PostHashtagsModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'PostHashtagsModel(name: $name, number: $number)';
  }

  @override
  bool operator ==(covariant PostHashtagsModel other) {
    if (identical(this, other)) return true;

    return 
      other.name == name &&
      other.number == number;
  }

  @override
  int get hashCode {
    return 
      name.hashCode ^
      number.hashCode;
  }

}
