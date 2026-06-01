import 'package:africa_beuty/core/utils/api_datetime.dart';
import 'package:africa_beuty/core/utils/image_url.dart';

class BookingListItem {
  final String id;
  final String status;

  final String customerId;
  final String customerName;
  final String salonServicePriceId;
  final String? stylistId;
  final String? stylistName;
  final String? stylistAvatar;

  final DateTime startAt;
  final DateTime endAt;

  final String serviceName;
  final int durationMinutes;

  final double price;
  final String currency;

  final String? note;
  final String? cancelReason;
  final bool hasReview;
  final int? reviewRating;
  final String? reviewComment;
  final DateTime? reviewCreatedAt;

  const BookingListItem({
    required this.id,
    required this.status,
    required this.customerId,
    required this.customerName,
    required this.salonServicePriceId,
    this.stylistId,
    this.stylistName,
    this.stylistAvatar,
    required this.startAt,
    required this.endAt,
    required this.serviceName,
    required this.durationMinutes,
    required this.price,
    required this.currency,
    this.note,
    this.cancelReason,
    this.hasReview = false,
    this.reviewRating,
    this.reviewComment,
    this.reviewCreatedAt,
  });

  BookingListItem copyWith({
    String? id,
    String? status,
    String? customerId,
    String? customerName,
    String? salonServicePriceId,
    String? stylistId,
    String? stylistName,
    String? stylistAvatar,
    DateTime? startAt,
    DateTime? endAt,
    String? serviceName,
    int? durationMinutes,
    double? price,
    String? currency,
    String? note,
    String? cancelReason,
    bool? hasReview,
    int? reviewRating,
    String? reviewComment,
    DateTime? reviewCreatedAt,
  }) {
    return BookingListItem(
      id: id ?? this.id,
      status: status ?? this.status,
      customerId: customerId ?? this.customerId,
      customerName: customerName ?? this.customerName,
      salonServicePriceId: salonServicePriceId ?? this.salonServicePriceId,
      stylistId: stylistId ?? this.stylistId,
      stylistName: stylistName ?? this.stylistName,
      stylistAvatar: stylistAvatar ?? this.stylistAvatar,
      startAt: startAt ?? this.startAt,
      endAt: endAt ?? this.endAt,
      serviceName: serviceName ?? this.serviceName,
      durationMinutes: durationMinutes ?? this.durationMinutes,
      price: price ?? this.price,
      currency: currency ?? this.currency,
      note: note ?? this.note,
      cancelReason: cancelReason ?? this.cancelReason,
      hasReview: hasReview ?? this.hasReview,
      reviewRating: reviewRating ?? this.reviewRating,
      reviewComment: reviewComment ?? this.reviewComment,
      reviewCreatedAt: reviewCreatedAt ?? this.reviewCreatedAt,
    );
  }

  factory BookingListItem.fromMap(Map<String, dynamic> map) {
    return BookingListItem(
      id: map['id']?.toString() ?? '',
      status: map['status']?.toString() ?? 'pending',

      customerId: map['customer_id']?.toString() ?? '',
      customerName: map['customer_name']?.toString() ?? '',
      salonServicePriceId: map['salon_service_price_id']?.toString() ?? '',
      stylistId: map['stylist_id']?.toString(),
      stylistName: map['stylist_name']?.toString(),
      stylistAvatar: resolveImageUrl(
        map['stylist_avatar'] ??
            map['stylist_profile_picture'] ??
            map['stylist_image'],
      ),

      startAt: parseApiDateTime(map['start_at']).toLocal(),
      endAt: parseApiDateTime(map['end_at']).toLocal(),

      serviceName: map['service_name_snapshot']?.toString() ?? '',

      durationMinutes: (map['duration_minutes_snapshot'] as num?)?.toInt() ?? 0,

      price: (map['price_snapshot'] as num?)?.toDouble() ?? 0,

      currency: map['currency_snapshot']?.toString() ?? 'TZS',

      note: map['note']?.toString(),
      cancelReason: map['cancel_reason']?.toString(),
      hasReview: map['has_review'] == true,
      reviewRating: (map['review_rating'] as num?)?.toInt(),
      reviewComment: map['review_comment']?.toString(),
      reviewCreatedAt: tryParseApiDateTime(map['review_created_at'])?.toLocal(),
    );
  }

  static List<BookingListItem> listFromJson(List list) {
    return list.map((e) => BookingListItem.fromMap(e)).toList();
  }
}
