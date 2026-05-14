// booking_draft.dart
import 'package:africa_beuty/core/model/services.dart';

class BookingDraft {
  final PostMinorCategoriesModel? style;

  // backend-required
  final String? salonServicePriceId;
  final DateTime? startAt;
  final String? note;

  // UI SNAPSHOTS (frontend-only)
  final String? salonName;
  final String? serviceName;
  final double? price;
  final String? currency;
  final int? durationMinutes;

  const BookingDraft({
    this.style,
    this.salonServicePriceId,
    this.startAt,
    this.note,
    this.salonName,
    this.serviceName,
    this.price,
    this.currency,
    this.durationMinutes,
  });

  BookingDraft copyWith({
    PostMinorCategoriesModel? style,
    String? salonServicePriceId,
    DateTime? startAt,
    String? note,
    String? salonName,
    String? serviceName,
    double? price,
    String? currency,
    int? durationMinutes,
  }) {
    return BookingDraft(
      style: style ?? this.style,
      salonServicePriceId:
          salonServicePriceId ?? this.salonServicePriceId,
      startAt: startAt ?? this.startAt,
      note: note ?? this.note,
      salonName: salonName ?? this.salonName,
      serviceName: serviceName ?? this.serviceName,
      price: price ?? this.price,
      currency: currency ?? this.currency,
      durationMinutes:
          durationMinutes ?? this.durationMinutes,
    );
  }
}
