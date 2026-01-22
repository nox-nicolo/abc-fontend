import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:africa_beuty/feature/booking/repository/start_booking.dart';

part 'start_booking.g.dart';

@riverpod
BookingRepository startBooking(Ref ref) {
  return BookingRepository();
}