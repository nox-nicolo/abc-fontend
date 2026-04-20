class ActivityFeedResponse {
  final List<ActivityItem> items;
  final String? nextCursor;

  ActivityFeedResponse({required this.items, this.nextCursor});

  factory ActivityFeedResponse.fromMap(Map<String, dynamic> map) {
    return ActivityFeedResponse(
      items: List<ActivityItem>.from(
        (map['items'] as List<dynamic>)
            .map((x) => ActivityItem.fromMap(x as Map<String, dynamic>)),
      ),
      nextCursor: map['next_cursor'],
    );
  }
}

class ActivityItem {
  final String id;
  final String type;
  final String message;
  final ActivityActor? actor;
  final String createdAt;
  final String? refId;

  ActivityItem({
    required this.id,
    required this.type,
    required this.message,
    this.actor,
    required this.createdAt,
    this.refId,
  });

  factory ActivityItem.fromMap(Map<String, dynamic> map) {
    return ActivityItem(
      id: map['id'] ?? '',
      type: map['type'] ?? '',
      message: map['message'] ?? '',
      actor: map['actor'] != null
          ? ActivityActor.fromMap(map['actor'] as Map<String, dynamic>)
          : null,
      createdAt: map['created_at'] ?? '',
      refId: map['ref_id'],
    );
  }
}

class ActivityActor {
  final String id;
  final String username;
  final String name;
  final String? profilePicture;

  ActivityActor({
    required this.id,
    required this.username,
    required this.name,
    this.profilePicture,
  });

  factory ActivityActor.fromMap(Map<String, dynamic> map) {
    return ActivityActor(
      id: map['id'] ?? '',
      username: map['username'] ?? '',
      name: map['name'] ?? '',
      profilePicture: map['profile_picture'],
    );
  }
}
