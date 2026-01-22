import 'package:africa_beuty/feature/booking/model/salon_offer.dart';
import 'package:africa_beuty/feature/booking/provider/salon_offer.dart';
import 'package:fpdart/fpdart.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'salon_offer.g.dart';

@Riverpod(keepAlive: true)
class SalonOfferViewModel extends _$SalonOfferViewModel {
  @override
  AsyncValue<List<SalonOfferModel>> build(
    String subServiceId,
  ) {
    fetch(subServiceId);
    return const AsyncValue.loading();
  }

  Future<void> fetch(String subServiceId) async {
    state = const AsyncValue.loading();

    final repo = ref.read(salonOfferRepositoryProvider);
    final res =
        await repo.getSalonsByStyle(subServiceId: subServiceId);

    switch (res) {
      case Left(value: final l):
        state = AsyncValue.error(l.message, StackTrace.current);
      case Right(value: final r):
        state = AsyncValue.data(r);
    }
  }
}
