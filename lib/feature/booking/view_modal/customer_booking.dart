import 'package:africa_beuty/feature/booking/model/booking_status.dart';
import 'package:africa_beuty/feature/booking/model/start_booking.dart';
import 'package:africa_beuty/feature/booking/provider/customer_booking.dart';
import 'package:africa_beuty/feature/notifications/view_model/notification.dart';
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

  void applyOptimisticStatus(String bookingId, String nextStatus) {
    final current = state.value;
    if (current == null) return;

    final shouldKeep = status.isEmpty || status == nextStatus;
    final updated = <BookingListItem>[];

    for (final booking in current) {
      if (booking.id != bookingId) {
        updated.add(booking);
        continue;
      }

      if (shouldKeep) {
        updated.add(booking.copyWith(status: nextStatus));
      }
    }

    state = AsyncValue.data(updated);
  }

  void applyOptimisticReview(
    String bookingId, {
    required int rating,
    String? comment,
  }) {
    final current = state.value;
    if (current == null) return;

    state = AsyncValue.data([
      for (final booking in current)
        if (booking.id == bookingId)
          booking.copyWith(
            hasReview: true,
            reviewRating: rating,
            reviewComment: comment,
            reviewCreatedAt: DateTime.now(),
          )
        else
          booking,
    ]);
  }

  void restore(List<BookingListItem>? snapshot) {
    if (snapshot == null) return;
    state = AsyncValue.data(snapshot);
  }

  void insertOrReplace(BookingListItem booking) {
    final current = state.value;
    if (current == null) return;

    final shouldShow = status.isEmpty || status == booking.status;
    final withoutBooking = current.where((b) => b.id != booking.id).toList();

    state = AsyncValue.data(
      shouldShow ? [booking, ...withoutBooking] : withoutBooking,
    );
  }
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

  void applyOptimisticStatus(String status, {String? cancelReason}) {
    final booking = state.value;
    if (booking == null) return;

    state = AsyncValue.data(
      booking.copyWith(
        status: status,
        cancelReason: cancelReason,
        updatedAt: DateTime.now(),
      ),
    );
  }

  void applyOptimisticReview({required int rating, String? comment}) {
    final booking = state.value;
    if (booking == null) return;

    state = AsyncValue.data(
      booking.copyWith(
        hasReview: true,
        reviewRating: rating,
        reviewComment: comment,
        reviewCreatedAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
    );
  }

  void restore(BookingModel? snapshot) {
    if (snapshot == null) return;
    state = AsyncValue.data(snapshot);
  }
}

// ── Customer actions (cancel, reschedule, review) ────────────────────────────
@riverpod
class CustomerBookingActionViewModel extends _$CustomerBookingActionViewModel {
  @override
  AsyncValue<void> build() => const AsyncValue.data(null);

  Future<void> cancel(String bookingId, {String? reason}) async {
    if (state.isLoading) return;
    state = const AsyncValue.loading();
    final snapshots = _snapshots();
    final detailSnapshot = ref
        .read(bookingDetailViewModelProvider(bookingId))
        .value;
    _applyOptimisticStatus(bookingId, 'cancelled', snapshots);
    ref
        .read(bookingDetailViewModelProvider(bookingId).notifier)
        .applyOptimisticStatus('cancelled', cancelReason: reason);

    final res = await ref
        .read(customerBookingRepositoryProvider)
        .cancel(bookingId, reason: reason);
    _handle(res, snapshots: snapshots, detailSnapshot: detailSnapshot);
  }

  Future<void> reschedule(String bookingId, DateTime startAt) async {
    if (state.isLoading) return;
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
    if (state.isLoading) return;
    state = const AsyncValue.loading();
    final snapshots = _snapshots();
    final detailSnapshot = ref
        .read(bookingDetailViewModelProvider(bookingId))
        .value;
    for (final status in _statuses) {
      ref
          .read(myBookingsViewModelProvider(status).notifier)
          .applyOptimisticReview(bookingId, rating: rating, comment: comment);
    }
    ref
        .read(bookingDetailViewModelProvider(bookingId).notifier)
        .applyOptimisticReview(rating: rating, comment: comment);
    final res = await ref
        .read(customerBookingRepositoryProvider)
        .review(bookingId, rating: rating, comment: comment);
    _handle(res, snapshots: snapshots, detailSnapshot: detailSnapshot);
  }

  void _handle(
    dynamic result, {
    Map<String, List<BookingListItem>?>? snapshots,
    BookingModel? detailSnapshot,
  }) {
    switch (result) {
      case Left(value: final failure):
        if (snapshots != null) _restore(snapshots);
        if (detailSnapshot != null) {
          ref
              .read(bookingDetailViewModelProvider(detailSnapshot.id).notifier)
              .restore(detailSnapshot);
        }
        state = AsyncValue.error(failure.message, StackTrace.current);
      case Right():
        _refreshAfterSuccess();
        state = const AsyncValue.data(null);
    }
  }

  List<String> get _statuses => const [
    '',
    'pending',
    'confirmed',
    'completed',
    'cancelled',
  ];

  Map<String, List<BookingListItem>?> _snapshots() {
    return {
      for (final status in _statuses)
        status: ref.read(myBookingsViewModelProvider(status)).value,
    };
  }

  void _applyOptimisticStatus(
    String bookingId,
    String nextStatus,
    Map<String, List<BookingListItem>?> snapshots,
  ) {
    final original = _findSnapshotBooking(bookingId, snapshots);
    if (original != null) {
      final optimisticBooking = original.copyWith(status: nextStatus);
      for (final status in _statuses) {
        ref
            .read(myBookingsViewModelProvider(status).notifier)
            .insertOrReplace(optimisticBooking);
      }
      return;
    }

    for (final status in _statuses) {
      ref
          .read(myBookingsViewModelProvider(status).notifier)
          .applyOptimisticStatus(bookingId, nextStatus);
    }
  }

  BookingListItem? _findSnapshotBooking(
    String bookingId,
    Map<String, List<BookingListItem>?> snapshots,
  ) {
    for (final bookings in snapshots.values) {
      if (bookings == null) continue;
      for (final booking in bookings) {
        if (booking.id == bookingId) return booking;
      }
    }
    return null;
  }

  void _restore(Map<String, List<BookingListItem>?> snapshots) {
    for (final entry in snapshots.entries) {
      ref
          .read(myBookingsViewModelProvider(entry.key).notifier)
          .restore(entry.value);
    }
  }

  void _refreshAfterSuccess() {
    for (final status in _statuses) {
      ref.invalidate(myBookingsViewModelProvider(status));
    }
    ref.invalidate(unreadCountProvider);
    ref.invalidate(notificationsViewModelProvider);
  }

  void reset() => state = const AsyncValue.data(null);
}
