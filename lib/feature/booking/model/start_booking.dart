// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:africa_beuty/core/utils/api_datetime.dart';

class CreateBookingRequestModel {
  CreateBookingRequestModel({
    required this.salonServicePriceId,
    required this.startAt,
    this.note,
  });

  final String salonServicePriceId;
  final DateTime startAt;
  final String? note;

  // --------------------------------------------------
  // copyWith
  // --------------------------------------------------
  CreateBookingRequestModel copyWith({
    String? salonServicePriceId,
    DateTime? startAt,
    String? note,
  }) {
    return CreateBookingRequestModel(
      salonServicePriceId: salonServicePriceId ?? this.salonServicePriceId,
      startAt: startAt ?? this.startAt,
      note: note ?? this.note,
    );
  }

  // --------------------------------------------------
  // toMap (BACKEND CONTRACT)
  // --------------------------------------------------
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'salon_service_price_id': salonServicePriceId,
      'start_at': startAt.toIso8601String(),
      if (note != null && note!.isNotEmpty) 'note': note,
    };
  }

  // --------------------------------------------------
  // fromMap (OPTIONAL — usually not needed)
  // --------------------------------------------------
  factory CreateBookingRequestModel.fromMap(Map<String, dynamic> map) {
    return CreateBookingRequestModel(
      salonServicePriceId: map['salon_service_price_id']?.toString() ?? '',
      startAt: tryParseApiDateTime(map['start_at']) ?? DateTime.now().toUtc(),
      note: map['note']?.toString(),
    );
  }

  // --------------------------------------------------
  // JSON helpers
  // --------------------------------------------------
  String toJson() => json.encode(toMap());

  factory CreateBookingRequestModel.fromJson(String source) =>
      CreateBookingRequestModel.fromMap(
        json.decode(source) as Map<String, dynamic>,
      );

  @override
  String toString() {
    return 'CreateBookingRequestModel(salonServicePriceId: $salonServicePriceId, startAt: $startAt, note: $note)';
  }

  @override
  bool operator ==(covariant CreateBookingRequestModel other) {
    if (identical(this, other)) return true;

    return other.salonServicePriceId == salonServicePriceId &&
        other.startAt == startAt &&
        other.note == note;
  }

  @override
  int get hashCode {
    return salonServicePriceId.hashCode ^ startAt.hashCode ^ note.hashCode;
  }
}

class BookingModel {
  BookingModel({
    required this.id,
    required this.customerId,
    this.customerName,
    required this.salonId,
    required this.status,
    required this.startAt,
    required this.endAt,
    required this.serviceNameSnapshot,
    required this.priceSnapshot,
    required this.currencySnapshot,
    required this.durationMinutesSnapshot,
    this.note,
    this.cancelReason,
    this.hasReview = false,
    this.reviewRating,
    this.reviewComment,
    this.reviewCreatedAt,
    required this.createdAt,
    required this.updatedAt,
  });

  final String id;
  final String customerId;
  final String? customerName;
  final String salonId;
  final String status;

  final DateTime startAt;
  final DateTime endAt;

  final String serviceNameSnapshot;
  final double priceSnapshot;
  final String currencySnapshot;
  final int durationMinutesSnapshot;

  final String? note;
  final String? cancelReason;
  final bool hasReview;
  final int? reviewRating;
  final String? reviewComment;
  final DateTime? reviewCreatedAt;

  final DateTime createdAt;
  final DateTime updatedAt;

  // --------------------------------------------------
  // copyWith
  // --------------------------------------------------
  BookingModel copyWith({
    String? id,
    String? customerId,
    String? customerName,
    String? salonId,
    String? status,
    DateTime? startAt,
    DateTime? endAt,
    String? serviceNameSnapshot,
    double? priceSnapshot,
    String? currencySnapshot,
    int? durationMinutesSnapshot,
    String? note,
    String? cancelReason,
    bool? hasReview,
    int? reviewRating,
    String? reviewComment,
    DateTime? reviewCreatedAt,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return BookingModel(
      id: id ?? this.id,
      customerId: customerId ?? this.customerId,
      customerName: customerName ?? this.customerName,
      salonId: salonId ?? this.salonId,
      status: status ?? this.status,
      startAt: startAt ?? this.startAt,
      endAt: endAt ?? this.endAt,
      serviceNameSnapshot: serviceNameSnapshot ?? this.serviceNameSnapshot,
      priceSnapshot: priceSnapshot ?? this.priceSnapshot,
      currencySnapshot: currencySnapshot ?? this.currencySnapshot,
      durationMinutesSnapshot:
          durationMinutesSnapshot ?? this.durationMinutesSnapshot,
      note: note ?? this.note,
      cancelReason: cancelReason ?? this.cancelReason,
      hasReview: hasReview ?? this.hasReview,
      reviewRating: reviewRating ?? this.reviewRating,
      reviewComment: reviewComment ?? this.reviewComment,
      reviewCreatedAt: reviewCreatedAt ?? this.reviewCreatedAt,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  // --------------------------------------------------
  // toMap
  // --------------------------------------------------
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'customer_id': customerId,
      'customer_name': customerName,
      'salon_id': salonId,
      'status': status,
      'start_at': startAt.toIso8601String(),
      'end_at': endAt.toIso8601String(),
      'service_name_snapshot': serviceNameSnapshot,
      'price_snapshot': priceSnapshot,
      'currency_snapshot': currencySnapshot,
      'duration_minutes_snapshot': durationMinutesSnapshot,
      'note': note,
      'cancel_reason': cancelReason,
      'has_review': hasReview,
      'review_rating': reviewRating,
      'review_comment': reviewComment,
      'review_created_at': reviewCreatedAt?.toIso8601String(),
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  // --------------------------------------------------
  // fromMap (DEFENSIVE)
  // --------------------------------------------------
  factory BookingModel.fromMap(Map<String, dynamic> map) {
    return BookingModel(
      id: map['id']?.toString() ?? '',
      customerId: map['customer_id']?.toString() ?? '',
      customerName: map['customer_name']?.toString(),
      salonId: map['salon_id']?.toString() ?? '',
      status: map['status']?.toString() ?? 'pending',
      startAt: tryParseApiDateTime(map['start_at']) ?? DateTime.now().toUtc(),
      endAt: tryParseApiDateTime(map['end_at']) ?? DateTime.now().toUtc(),
      serviceNameSnapshot: map['service_name_snapshot']?.toString() ?? '',
      priceSnapshot: (map['price_snapshot'] as num?)?.toDouble() ?? 0.0,
      currencySnapshot: map['currency_snapshot']?.toString() ?? '',
      durationMinutesSnapshot:
          (map['duration_minutes_snapshot'] as num?)?.toInt() ?? 0,
      note: map['note']?.toString(),
      cancelReason: map['cancel_reason']?.toString(),
      hasReview: map['has_review'] == true,
      reviewRating: (map['review_rating'] as num?)?.toInt(),
      reviewComment: map['review_comment']?.toString(),
      reviewCreatedAt: tryParseApiDateTime(map['review_created_at']),
      createdAt:
          tryParseApiDateTime(map['created_at']) ?? DateTime.now().toUtc(),
      updatedAt:
          tryParseApiDateTime(map['updated_at']) ?? DateTime.now().toUtc(),
    );
  }

  // --------------------------------------------------
  // JSON helpers
  // --------------------------------------------------
  String toJson() => json.encode(toMap());

  factory BookingModel.fromJson(String source) =>
      BookingModel.fromMap(json.decode(source) as Map<String, dynamic>);

  // --------------------------------------------------
  // Equality
  // --------------------------------------------------
  @override
  String toString() {
    return 'BookingModel(id: $id, customerId: $customerId, salonId: $salonId, status: $status, startAt: $startAt, endAt: $endAt, serviceNameSnapshot: $serviceNameSnapshot, priceSnapshot: $priceSnapshot, currencySnapshot: $currencySnapshot, durationMinutesSnapshot: $durationMinutesSnapshot, note: $note, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(covariant BookingModel other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.customerId == customerId &&
        other.salonId == salonId &&
        other.status == status &&
        other.startAt == startAt &&
        other.endAt == endAt &&
        other.serviceNameSnapshot == serviceNameSnapshot &&
        other.priceSnapshot == priceSnapshot &&
        other.currencySnapshot == currencySnapshot &&
        other.durationMinutesSnapshot == durationMinutesSnapshot &&
        other.note == note &&
        other.hasReview == hasReview &&
        other.reviewRating == reviewRating &&
        other.reviewComment == reviewComment &&
        other.reviewCreatedAt == reviewCreatedAt &&
        other.createdAt == createdAt &&
        other.updatedAt == updatedAt;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        customerId.hashCode ^
        salonId.hashCode ^
        status.hashCode ^
        startAt.hashCode ^
        endAt.hashCode ^
        serviceNameSnapshot.hashCode ^
        priceSnapshot.hashCode ^
        currencySnapshot.hashCode ^
        durationMinutesSnapshot.hashCode ^
        note.hashCode ^
        hasReview.hashCode ^
        reviewRating.hashCode ^
        reviewComment.hashCode ^
        reviewCreatedAt.hashCode ^
        createdAt.hashCode ^
        updatedAt.hashCode;
  }
}
