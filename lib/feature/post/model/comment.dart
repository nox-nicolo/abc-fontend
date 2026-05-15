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
  final int likesCount;
  final bool isLiked;
  final DateTime createdAt;
  final bool isMine;
  final bool isPending;

  const CommentModel({
    required this.id,
    required this.postId,
    required this.content,
    required this.author,
    this.parentCommentId,
    required this.replyCount,
    required this.likesCount,
    required this.isLiked,
    required this.createdAt,
    required this.isMine,
    this.isPending = false,
  });

  CommentModel copyWith({
    String? id,
    String? postId,
    String? content,
    CommentAuthorModel? author,
    String? parentCommentId,
    int? replyCount,
    int? likesCount,
    bool? isLiked,
    DateTime? createdAt,
    bool? isMine,
    bool? isPending,
  }) {
    return CommentModel(
      id: id ?? this.id,
      postId: postId ?? this.postId,
      content: content ?? this.content,
      author: author ?? this.author,
      parentCommentId: parentCommentId ?? this.parentCommentId,
      replyCount: replyCount ?? this.replyCount,
      likesCount: likesCount ?? this.likesCount,
      isLiked: isLiked ?? this.isLiked,
      createdAt: createdAt ?? this.createdAt,
      isMine: isMine ?? this.isMine,
      isPending: isPending ?? this.isPending,
    );
  }

  factory CommentModel.fromMap(Map<String, dynamic> map) {
    return CommentModel(
      id: map['id'],
      postId: map['post_id'] ?? '',
      content: map['content'] ?? '',
      author: CommentAuthorModel.fromMap(map['author'] ?? {}),
      parentCommentId: map['parent_comment_id'],
      replyCount: map['reply_count'] ?? 0,
      likesCount: map['likes_count'] ?? 0,
      isLiked: map['is_liked'] ?? false,
      createdAt: DateTime.parse(map['created_at']),
      isMine: map['is_mine'] ?? false,
      isPending: false,
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
