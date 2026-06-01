import 'package:africa_beuty/feature/booking/model/booking_stylist.dart';
import 'package:africa_beuty/feature/booking/repository/salon_offer.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'salon_offer.g.dart';

@riverpod
SalonOfferRepository salonOfferRepository(Ref ref) {
  return SalonOfferRepository();
}

class BookingStylistsRequest {
  const BookingStylistsRequest({
    required this.salonServicePriceId,
    this.startAt,
    this.excludeBookingId,
  });

  final String salonServicePriceId;
  final DateTime? startAt;
  final String? excludeBookingId;

  @override
  bool operator ==(Object other) {
    return other is BookingStylistsRequest &&
        other.salonServicePriceId == salonServicePriceId &&
        other.startAt == startAt &&
        other.excludeBookingId == excludeBookingId;
  }

  @override
  int get hashCode =>
      Object.hash(salonServicePriceId, startAt, excludeBookingId);
}

final bookingStylistsProvider = FutureProvider.autoDispose
    .family<List<BookingStylistModel>, BookingStylistsRequest>((
      ref,
      request,
    ) async {
      final result = await ref
          .read(salonOfferRepositoryProvider)
          .getStylistsForOffer(
            salonServicePriceId: request.salonServicePriceId,
            startAt: request.startAt,
            excludeBookingId: request.excludeBookingId,
          );
      return result.match(
        (failure) => throw failure.message,
        (stylists) => stylists,
      );
    });
