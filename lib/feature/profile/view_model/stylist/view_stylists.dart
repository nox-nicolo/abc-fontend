
import 'package:africa_beuty/feature/profile/model/three_dots/stylists/view_stylists.dart';
import 'package:africa_beuty/feature/profile/providers/stylist/stylists.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'view_stylists.g.dart';

@riverpod
class SalonStylistViewModel extends _$SalonStylistViewModel {
  @override
  AsyncValue<StylistListResponse> build() {
    return const AsyncValue.loading();
  }

  Future<void> getSalonStylists({
    int limit = 20,
    int offset = 0,
  }) async {
    state = const AsyncValue.loading();

    final stylistRepository = ref.read(salonStylistRepositoryProvider);
    final res = await stylistRepository.getSalonStylists(
      limit: limit,
      offset: offset,
    );

    if (!ref.mounted) return;

    res.fold(
      (l) {
        state = AsyncValue.error(l.message, StackTrace.current);
      },
      (r) {
        state = AsyncValue.data(r);
      },
    );
  }
}