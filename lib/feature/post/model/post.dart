class PostModel {
  final String id;
  final String content;
  final String authorId;
  final DateTime createdAt;

  PostModel({
    required this.id,
    required this.content,
    required this.authorId,
    required this.createdAt,
  });

  factory PostModel.fromJson(Map<String, dynamic> json) {
    return PostModel(
      id: json['id'],
      content: json['content'],
      authorId: json['authorId'],
      createdAt: DateTime.parse(json['createdAt']),
    );
  }
}