// booking_list_provider.dart
import 'package:africa_beuty/feature/booking/repository/booking_status.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'booking_status.g.dart';

@riverpod
BookingListRepository bookingListRepository(Ref ref) {
  return BookingListRepository();
}
