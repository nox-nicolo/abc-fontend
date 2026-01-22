
import 'package:africa_beuty/feature/booking/model/start_booking.dart';
import 'package:africa_beuty/feature/booking/provider/start_booking.dart';
import 'package:fpdart/fpdart.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'start_booking.g.dart';

@riverpod
class StartBookingViewModel extends _$StartBookingViewModel {
  @override
  AsyncValue<BookingModel?> build() {
    return const AsyncValue.data(null);
  }

  // --------------------------------------------------
  // Create booking (typed request)
  // --------------------------------------------------
  Future<void> createBooking({
    required CreateBookingRequestModel request,
  }) async {
    // 1️Loading
    state = const AsyncValue.loading();

    final bookingRepository = ref.read(startBookingProvider);

    final res = await bookingRepository.createBooking(
      payload: request.toMap(),
    );

    // Result
    switch (res) {
      case Left(value: final failure):
        state = AsyncValue.error(
          failure.message,
          StackTrace.current,
        );

      case Right(value: final booking):
        state = AsyncValue.data(booking);
    }
  }

  // --------------------------------------------------
  // Optional reset
  // --------------------------------------------------
  void reset() {
    state = const AsyncValue.data(null);
  }
}
