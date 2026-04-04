import 'package:africa_beuty/feature/booking/model/booking_status.dart';
import 'package:africa_beuty/feature/booking/model/start_booking.dart';
import 'package:africa_beuty/feature/booking/provider/customer_booking.dart';
import 'package:fpdart/fpdart.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'customer_booking.g.dart';

// ── My Bookings list (parameterized by status, '' = all) ─────────────────────
@riverpod
class MyBookingsViewModel extends _$MyBookingsViewModel {
  @override
  AsyncValue<List<BookingListItem>> build(String status) {
    _fetch(status);
    return const AsyncValue.loading();
  }

  Future<void> _fetch(String status) async {
    final repo = ref.read(customerBookingRepositoryProvider);
    final res = await repo.getMyBookings(
      status: status.isEmpty ? null : status,
    );
    switch (res) {
      case Left(value: final l):
        state = AsyncValue.error(l.message, StackTrace.current);
      case Right(value: final r):
        state = AsyncValue.data(r);
    }
  }

  Future<void> refresh(String status) => _fetch(status);
}

// ── Single booking detail ─────────────────────────────────────────────────────
@riverpod
class BookingDetailViewModel extends _$BookingDetailViewModel {
  @override
  AsyncValue<BookingModel> build(String bookingId) {
    _fetch(bookingId);
    return const AsyncValue.loading();
  }

  Future<void> _fetch(String bookingId) async {
    final repo = ref.read(customerBookingRepositoryProvider);
    final res = await repo.getBooking(bookingId);
    switch (res) {
      case Left(value: final l):
        state = AsyncValue.error(l.message, StackTrace.current);
      case Right(value: final r):
        state = AsyncValue.data(r);
    }
  }
}

// ── Customer actions (cancel, reschedule, review) ────────────────────────────
@riverpod
class CustomerBookingActionViewModel extends _$CustomerBookingActionViewModel {
  @override
  AsyncValue<void> build() => const AsyncValue.data(null);

  Future<void> cancel(String bookingId, {String? reason}) async {
    state = const AsyncValue.loading();
    final res = await ref
        .read(customerBookingRepositoryProvider)
        .cancel(bookingId, reason: reason);
    _handle(res);
  }

  Future<void> reschedule(String bookingId, DateTime startAt) async {
    state = const AsyncValue.loading();
    final res = await ref
        .read(customerBookingRepositoryProvider)
        .reschedule(bookingId, startAt);
    _handle(res);
  }

  Future<void> review(
    String bookingId, {
    required int rating,
    String? comment,
  }) async {
    state = const AsyncValue.loading();
    final res = await ref
        .read(customerBookingRepositoryProvider)
        .review(bookingId, rating: rating, comment: comment);
    _handle(res);
  }

  void _handle(dynamic result) {
    switch (result) {
      case Left(value: final failure):
        state = AsyncValue.error(failure.message, StackTrace.current);
      case Right():
        for (final s in ['', 'pending', 'confirmed', 'completed', 'cancelled']) {
          ref.invalidate(myBookingsViewModelProvider(s));
        }
        state = const AsyncValue.data(null);
    }
  }

  void reset() => state = const AsyncValue.data(null);
}
