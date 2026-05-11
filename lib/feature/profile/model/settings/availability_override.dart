class AvailabilityOverride {
  const AvailabilityOverride({
    required this.id,
    required this.date,
    required this.isClosed,
    this.openTime,
    this.closeTime,
    this.reason,
  });

  final String id;
  final DateTime date;
  final bool isClosed;
  final String? openTime;
  final String? closeTime;
  final String? reason;

  factory AvailabilityOverride.fromMap(Map<String, dynamic> map) {
    return AvailabilityOverride(
      id: map['id'] as String,
      date: DateTime.parse(map['date'] as String),
      isClosed: map['is_closed'] == true,
      openTime: map['open_time'] as String?,
      closeTime: map['close_time'] as String?,
      reason: map['reason'] as String?,
    );
  }
}
