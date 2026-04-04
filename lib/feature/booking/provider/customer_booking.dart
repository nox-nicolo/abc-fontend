import 'package:africa_beuty/feature/booking/repository/customer_booking.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'customer_booking.g.dart';

@riverpod
CustomerBookingRepository customerBookingRepository(Ref ref) {
  return CustomerBookingRepository();
}
