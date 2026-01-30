
import 'package:africa_beuty/feature/profile/model/salon_view_profile.dart';
import 'package:africa_beuty/feature/profile/providers/salon_view_profile.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'salon_view_profile.g.dart';

@riverpod
class SalonViewProfileViewModel extends _$SalonViewProfileViewModel {
  @override
  Future<SalonViewProfileModel> build(String salonId) async {
    final repository = ref.read(salonRepositoryProvider);

    final res = await repository.getSalonProfile(salonId);

    return res.fold(
      (failure) => throw failure,
      (profile) => profile,
    );
  }
}
