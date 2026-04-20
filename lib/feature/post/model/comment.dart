class CommentAuthorModel {
  final String id;
  final String username;
  final String? profilePicture;

  const CommentAuthorModel({
    required this.id,
    required this.username,
    this.profilePicture,
  });

  factory CommentAuthorModel.fromMap(Map<String, dynamic> map) {
    return CommentAuthorModel(
      id: map['id'] ?? '',
      username: map['username'] ?? '',
      profilePicture: map['profile_picture'],
    );
  }
}

class CommentModel {
  final String id;
  final String postId;
  final String content;
  final CommentAuthorModel author;
  final String? parentCommentId;
  final int replyCount;
  final DateTime createdAt;
  final bool isMine;

  const CommentModel({
    required this.id,
    required this.postId,
    required this.content,
    required this.author,
    this.parentCommentId,
    required this.replyCount,
    required this.createdAt,
    required this.isMine,
  });

  factory CommentModel.fromMap(Map<String, dynamic> map) {
    return CommentModel(
      id: map['id'],
      postId: map['post_id'] ?? '',
      content: map['content'] ?? '',
      author: CommentAuthorModel.fromMap(map['author'] ?? {}),
      parentCommentId: map['parent_comment_id'],
      replyCount: map['reply_count'] ?? 0,
      createdAt: DateTime.parse(map['created_at']),
      isMine: map['is_mine'] ?? false,
    );
  }
}

class CommentListPage {
  final List<CommentModel> items;
  final String? nextCursor;

  const CommentListPage({required this.items, this.nextCursor});

  factory CommentListPage.fromMap(Map<String, dynamic> map) {
    return CommentListPage(
      items: (map['items'] as List<dynamic>? ?? [])
          .map((e) => CommentModel.fromMap(e))
          .toList(),
      nextCursor: map['next_cursor'],
    );
  }
}
