import 'package:africa_beuty/feature/booking/repository/booking_action.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'booking_action.g.dart';

@riverpod
BookingActionRepository bookingActionRepository(Ref ref) {
  return BookingActionRepository();
}