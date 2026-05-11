class AvailabilitySlot {
  const AvailabilitySlot({
    required this.startAt,
    required this.endAt,
    required this.remainingCapacity,
  });

  final DateTime startAt;
  final DateTime endAt;
  final int remainingCapacity;

  factory AvailabilitySlot.fromMap(Map<String, dynamic> map) {
    return AvailabilitySlot(
      startAt: DateTime.parse(map['start_at'] as String).toLocal(),
      endAt: DateTime.parse(map['end_at'] as String).toLocal(),
      remainingCapacity: (map['remaining_capacity'] as num?)?.toInt() ?? 1,
    );
  }
}

class AvailabilityDay {
  const AvailabilityDay({
    required this.date,
    required this.isOpen,
    required this.slots,
    this.reason,
  });

  final DateTime date;
  final bool isOpen;
  final String? reason;
  final List<AvailabilitySlot> slots;

  factory AvailabilityDay.fromMap(Map<String, dynamic> map) {
    return AvailabilityDay(
      date: DateTime.parse(map['date'] as String),
      isOpen: map['is_open'] == true,
      reason: map['reason'] as String?,
      slots: ((map['slots'] as List?) ?? const [])
          .whereType<Map<String, dynamic>>()
          .map(AvailabilitySlot.fromMap)
          .toList(),
    );
  }
}
