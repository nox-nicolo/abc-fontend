class NotificationActorModel {
  final String id;
  final String username;
  final String? profilePicture;

  const NotificationActorModel({
    required this.id,
    required this.username,
    this.profilePicture,
  });

  factory NotificationActorModel.fromMap(Map<String, dynamic> map) {
    return NotificationActorModel(
      id: map['id'] ?? '',
      username: map['username'] ?? '',
      profilePicture: map['profile_picture'],
    );
  }
}

class NotificationModel {
  final String id;
  // "like" | "comment" | "reply"
  // | "booking_new" | "booking_confirmed" | "booking_rejected"
  // | "booking_cancelled" | "booking_completed" | "booking_rescheduled"
  final String type;
  final NotificationActorModel actor;
  final String? postId;
  final String? commentId;
  final String? bookingId;
  final String? preview;
  final bool isRead;
  final DateTime createdAt;

  const NotificationModel({
    required this.id,
    required this.type,
    required this.actor,
    this.postId,
    this.commentId,
    this.bookingId,
    this.preview,
    required this.isRead,
    required this.createdAt,
  });

  NotificationModel copyWith({bool? isRead}) {
    return NotificationModel(
      id: id,
      type: type,
      actor: actor,
      postId: postId,
      commentId: commentId,
      bookingId: bookingId,
      preview: preview,
      isRead: isRead ?? this.isRead,
      createdAt: createdAt,
    );
  }

  factory NotificationModel.fromMap(Map<String, dynamic> map) {
    return NotificationModel(
      id: map['id'] ?? '',
      type: map['type'] ?? '',
      actor: NotificationActorModel.fromMap(map['actor'] ?? {}),
      postId: map['post_id'],
      commentId: map['comment_id'],
      bookingId: map['booking_id'],
      preview: map['preview'],
      isRead: map['is_read'] ?? false,
      createdAt: DateTime.parse(map['created_at']),
    );
  }
}

class NotificationListPage {
  final List<NotificationModel> items;
  final String? nextCursor;

  const NotificationListPage({required this.items, this.nextCursor});

  factory NotificationListPage.fromMap(Map<String, dynamic> map) {
    return NotificationListPage(
      items: (map['items'] as List<dynamic>? ?? [])
          .map((e) => NotificationModel.fromMap(e))
          .toList(),
      nextCursor: map['next_cursor'],
    );
  }
}
