
import 'package:africa_beuty/feature/profile/model/three_dots/stylists/view_single_stylists.dart';
import 'package:africa_beuty/feature/profile/providers/stylist/stylists.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'view_single_stylist.g.dart';

@riverpod
class SalonStylistDetailViewModel extends _$SalonStylistDetailViewModel {
  @override
  AsyncValue<SalonStylistDetail> build(String stylistId) {
    Future.microtask(() => getSalonStylistDetail(stylistId));
    return const AsyncValue.loading();
  }

  Future<void> getSalonStylistDetail(String stylistId) async {
    state = const AsyncValue.loading();

    final repository = ref.read(salonStylistRepositoryProvider);
    final res = await repository.getSalonStylistDetail(stylistId: stylistId);

    if (!ref.mounted) return;

    res.fold(
      (l) => state = AsyncValue.error(l.message, StackTrace.current),
      (r) => state = AsyncValue.data(r),
    );
  }
}