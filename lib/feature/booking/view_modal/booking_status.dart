// booking_list_viewmodel.dart
import 'package:africa_beuty/feature/booking/model/booking_status.dart';
import 'package:africa_beuty/feature/booking/provider/booking_status.dart';
import 'package:fpdart/fpdart.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'booking_status.g.dart';

@riverpod
class BookingListViewModel extends _$BookingListViewModel {
  @override
  AsyncValue<List<BookingListItem>> build(String status) {
    _fetch(status);
    return const AsyncValue.loading();
  }

  Future<void> _fetch(String status) async {
    final repo = ref.read(bookingListRepositoryProvider);
    final res = await repo.fetchBookings(status: status);

    switch (res) {
      case Left(value: final l):
        state = AsyncValue.error(l.message, StackTrace.current);
      case Right(value: final r):
        state = AsyncValue.data(r);
    }
  }
}
