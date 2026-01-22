class BookingListItem {
  final String id;
  final String status;

  final String customerId;
  final String customerName;

  final DateTime startAt;
  final DateTime endAt;

  final String serviceName;
  final int durationMinutes;

  final double price;
  final String currency;

  final String? note;
  final String? cancelReason;

  const BookingListItem({
    required this.id,
    required this.status,
    required this.customerId,
    required this.customerName,
    required this.startAt,
    required this.endAt,
    required this.serviceName,
    required this.durationMinutes,
    required this.price,
    required this.currency,
    this.note,
    this.cancelReason,
  });

  factory BookingListItem.fromMap(Map<String, dynamic> map) {
    return BookingListItem(
      id: map['id']?.toString() ?? '',
      status: map['status']?.toString() ?? 'pending',

      customerId: map['customer_id']?.toString() ?? '',
      customerName: map['customer_name']?.toString() ?? '',

      startAt: DateTime.parse(map['start_at']),
      endAt: DateTime.parse(map['end_at']),

      serviceName:
          map['service_name_snapshot']?.toString() ?? '',

      durationMinutes:
          (map['duration_minutes_snapshot'] as num?)?.toInt() ?? 0,

      price:
          (map['price_snapshot'] as num?)?.toDouble() ?? 0,

      currency:
          map['currency_snapshot']?.toString() ?? 'TZS',

      note: map['note']?.toString(),
      cancelReason: map['cancel_reason']?.toString(),
    );
  }

  static List<BookingListItem> listFromJson(List list) {
    return list
        .map((e) => BookingListItem.fromMap(e))
        .toList();
  }
}
