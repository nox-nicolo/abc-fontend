import 'package:africa_beuty/feature/booking/model/availability.dart';
import 'package:africa_beuty/feature/booking/repository/availability.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final availabilityRepositoryProvider = Provider<AvailabilityRepository>(
  (ref) => AvailabilityRepository(),
);

class AvailabilityRequest {
  const AvailabilityRequest({
    required this.salonServicePriceId,
    required this.startDate,
    this.days = 14,
  });

  final String salonServicePriceId;
  final DateTime startDate;
  final int days;

  @override
  bool operator ==(Object other) {
    return other is AvailabilityRequest &&
        other.salonServicePriceId == salonServicePriceId &&
        DateUtils.isSameDay(other.startDate, startDate) &&
        other.days == days;
  }

  @override
  int get hashCode =>
      Object.hash(salonServicePriceId, DateUtils.dateOnly(startDate), days);
}

final availabilityProvider = FutureProvider.autoDispose
    .family<List<AvailabilityDay>, AvailabilityRequest>((ref, request) async {
      final result = await ref
          .read(availabilityRepositoryProvider)
          .getAvailability(
            salonServicePriceId: request.salonServicePriceId,
            startDate: request.startDate,
            days: request.days,
          );
      return result.match((failure) => throw failure.message, (days) => days);
    });
