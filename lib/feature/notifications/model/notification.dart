class NotificationActorModel {
  final String id;
  final String username;
  final String? profilePicture;
  final String? role;
  final String? salonId;

  const NotificationActorModel({
    required this.id,
    required this.username,
    this.profilePicture,
    this.role,
    this.salonId,
  });

  factory NotificationActorModel.fromMap(Map<String, dynamic> map) {
    return NotificationActorModel(
      id: map['id'] ?? '',
      username: map['username'] ?? '',
      profilePicture: map['profile_picture'],
      role: map['role'],
      salonId: map['salon_id'],
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
  final bool isGrouped;
  final int groupCount;
  final bool isRead;
  final String deliveryStatus;
  final DateTime createdAt;

  const NotificationModel({
    required this.id,
    required this.type,
    required this.actor,
    this.postId,
    this.commentId,
    this.bookingId,
    this.preview,
    this.isGrouped = false,
    this.groupCount = 1,
    required this.isRead,
    this.deliveryStatus = 'sent',
    required this.createdAt,
  });

  NotificationModel copyWith({bool? isRead, String? deliveryStatus}) {
    return NotificationModel(
      id: id,
      type: type,
      actor: actor,
      postId: postId,
      commentId: commentId,
      bookingId: bookingId,
      preview: preview,
      isGrouped: isGrouped,
      groupCount: groupCount,
      isRead: isRead ?? this.isRead,
      deliveryStatus: deliveryStatus ?? this.deliveryStatus,
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
      isGrouped: map['is_grouped'] == true,
      groupCount: (map['group_count'] as num?)?.toInt() ?? 1,
      isRead: map['is_read'] ?? false,
      deliveryStatus: map['delivery_status'] ?? 'sent',
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
