// booking_action_viewmodel.dart

import 'package:africa_beuty/core/failure/failure.dart';
import 'package:africa_beuty/feature/booking/model/booking_status.dart';
import 'package:africa_beuty/feature/booking/model/start_booking.dart';
import 'package:africa_beuty/feature/booking/provider/booking_action.dart';
import 'package:africa_beuty/feature/booking/view_modal/booking_status.dart';
import 'package:africa_beuty/feature/notifications/view_model/notification.dart';
import 'package:fpdart/fpdart.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'booking_action.g.dart';

@riverpod
class BookingActionViewModel extends _$BookingActionViewModel {
  @override
  AsyncValue<void> build() {
    return const AsyncValue.data(null);
  }

  Future<void> accept(String bookingId) async {
    await _run(
      () => ref.read(bookingActionRepositoryProvider).accept(bookingId),
      bookingId: bookingId,
      optimisticStatus: 'confirmed',
    );
  }

  Future<void> reject(String bookingId) async {
    await _run(
      () => ref.read(bookingActionRepositoryProvider).reject(bookingId),
      bookingId: bookingId,
      optimisticStatus: 'cancelled',
    );
  }

  Future<void> complete(String bookingId) async {
    await _run(
      () => ref.read(bookingActionRepositoryProvider).complete(bookingId),
      bookingId: bookingId,
      optimisticStatus: 'completed',
    );
  }

  Future<void> assignStylist(String bookingId, String stylistId) async {
    await _run(
      () => ref
          .read(bookingActionRepositoryProvider)
          .assignStylist(bookingId, stylistId: stylistId),
      bookingId: bookingId,
      optimisticStatus: '',
    );
  }

  Future<void> _run(
    Future<Either<AppFailure, BookingModel>> Function() action, {
    required String bookingId,
    required String optimisticStatus,
  }) async {
    if (state.isLoading) return;

    state = const AsyncValue.loading();
    final snapshots = _snapshots();
    if (optimisticStatus.isNotEmpty) {
      _applyOptimisticStatus(bookingId, optimisticStatus, snapshots);
    }

    final result = await action();

    switch (result) {
      case Left(value: final failure):
        _restore(snapshots);
        state = AsyncValue.error(failure.message, StackTrace.current);

      case Right(value: final booking):
        _reconcile(booking);
        _refreshAfterSuccess();
        state = const AsyncValue.data(null);
    }
  }

  List<String> get _statuses => const [
    'pending',
    'confirmed',
    'completed',
    'cancelled',
  ];

  Map<String, List<BookingListItem>?> _snapshots() {
    return {
      for (final status in _statuses)
        status: ref.read(bookingListViewModelProvider(status)).value,
    };
  }

  void _applyOptimisticStatus(
    String bookingId,
    String optimisticStatus,
    Map<String, List<BookingListItem>?> snapshots,
  ) {
    final original = _findSnapshotBooking(bookingId, snapshots);
    if (original != null) {
      final optimisticBooking = original.copyWith(status: optimisticStatus);
      for (final status in _statuses) {
        ref
            .read(bookingListViewModelProvider(status).notifier)
            .insertOrReplace(optimisticBooking);
      }
      return;
    }

    for (final status in _statuses) {
      ref
          .read(bookingListViewModelProvider(status).notifier)
          .applyOptimisticStatus(bookingId, optimisticStatus);
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
          .read(bookingListViewModelProvider(entry.key).notifier)
          .restore(entry.value);
    }
  }

  void _reconcile(BookingModel booking) {
    final item = BookingListItem(
      id: booking.id,
      status: booking.status,
      customerId: booking.customerId,
      customerName: booking.customerName ?? '',
      salonServicePriceId: booking.salonServicePriceId,
      stylistId: booking.stylistId,
      stylistName: booking.stylistName,
      stylistAvatar: booking.stylistAvatar,
      startAt: booking.startAt,
      endAt: booking.endAt,
      serviceName: booking.serviceNameSnapshot,
      durationMinutes: booking.durationMinutesSnapshot,
      price: booking.priceSnapshot,
      currency: booking.currencySnapshot,
      note: booking.note,
      cancelReason: booking.cancelReason,
    );

    for (final status in _statuses) {
      ref
          .read(bookingListViewModelProvider(status).notifier)
          .insertOrReplace(item);
    }
  }

  void _refreshAfterSuccess() {
    for (final status in _statuses) {
      ref.invalidate(bookingListViewModelProvider(status));
    }
    ref.invalidate(unreadCountProvider);
    ref.invalidate(notificationsViewModelProvider);
  }

  void reset() {
    state = const AsyncValue.data(null);
  }
}
