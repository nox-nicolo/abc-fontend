// booking_action_viewmodel.dart

import 'package:africa_beuty/core/failure/failure.dart';
import 'package:africa_beuty/feature/booking/provider/booking_action.dart';
import 'package:africa_beuty/feature/booking/view_modal/booking_status.dart';
import 'package:fpdart/fpdart.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'booking_action.g.dart';

@riverpod
class BookingActionViewModel extends _$BookingActionViewModel {
  @override
  AsyncValue<void> build() {
    return const AsyncValue.data(null);
  }

  // --------------------------------------------------
  // ACCEPT BOOKING
  // --------------------------------------------------
  Future<void> accept(String bookingId) async {
    await _run(
      () => ref
          .read(bookingActionRepositoryProvider)
          .accept(bookingId),
    );
  }

  // --------------------------------------------------
  // REJECT BOOKING
  // --------------------------------------------------
  Future<void> reject(String bookingId) async {
    await _run(
      () => ref
          .read(bookingActionRepositoryProvider)
          .reject(bookingId),
    );
  }

  // --------------------------------------------------
  // COMPLETE BOOKING
  // --------------------------------------------------
  Future<void> complete(String bookingId) async {
    await _run(
      () => ref
          .read(bookingActionRepositoryProvider)
          .complete(bookingId),
    );
  }

  // --------------------------------------------------
  // INTERNAL EXECUTOR
  // --------------------------------------------------
  Future<void> _run(
    Future<Either<AppFailure, void>> Function() action,
  ) async {
    state = const AsyncValue.loading();

    final result = await action();

    switch (result) {
      case Left(value: final failure):
        state = AsyncValue.error(
          failure.message,
          StackTrace.current,
        );

      case Right():
        // 🔁 Refresh booking lists
        ref.invalidate(bookingListViewModelProvider('pending'));
        ref.invalidate(bookingListViewModelProvider('confirmed'));
        ref.invalidate(bookingListViewModelProvider('completed'));
        ref.invalidate(bookingListViewModelProvider('cancelled'));

        state = const AsyncValue.data(null);
    }
  }

  // --------------------------------------------------
  // OPTIONAL RESET
  // --------------------------------------------------
  void reset() {
    state = const AsyncValue.data(null);
  }
}
