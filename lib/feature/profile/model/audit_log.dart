class AuditLogResponse {
  const AuditLogResponse({
    required this.items,
    required this.total,
    required this.limit,
    required this.offset,
  });

  final List<AuditLogItem> items;
  final int total;
  final int limit;
  final int offset;

  factory AuditLogResponse.fromMap(Map<String, dynamic> map) {
    return AuditLogResponse(
      items: (map['items'] as List<dynamic>? ?? [])
          .whereType<Map<String, dynamic>>()
          .map(AuditLogItem.fromMap)
          .toList(),
      total: (map['total'] as num?)?.toInt() ?? 0,
      limit: (map['limit'] as num?)?.toInt() ?? 30,
      offset: (map['offset'] as num?)?.toInt() ?? 0,
    );
  }
}

class AuditLogItem {
  const AuditLogItem({
    required this.id,
    required this.eventType,
    required this.title,
    required this.metadata,
    required this.createdAt,
    this.description,
  });

  final String id;
  final String eventType;
  final String title;
  final String? description;
  final Map<String, dynamic> metadata;
  final DateTime createdAt;

  factory AuditLogItem.fromMap(Map<String, dynamic> map) {
    return AuditLogItem(
      id: map['id']?.toString() ?? '',
      eventType: map['event_type']?.toString() ?? '',
      title: map['title']?.toString() ?? 'Account activity',
      description: map['description']?.toString(),
      metadata: Map<String, dynamic>.from(
        map['metadata'] as Map<dynamic, dynamic>? ?? const {},
      ),
      createdAt:
          DateTime.tryParse(map['created_at']?.toString() ?? '') ??
          DateTime.now(),
    );
  }
}
