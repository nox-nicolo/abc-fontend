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

    return res.fold((failure) => throw failure, (profile) => profile);
  }

  void applyOptimisticFollow(bool isFollowing) {
    final profile = state.value;
    if (profile == null || profile.viewer.isFollowing == isFollowing) return;

    final nextCount = profile.metrics.followersCount + (isFollowing ? 1 : -1);

    state = AsyncValue.data(
      profile.copyWith(
        viewer: profile.viewer.copyWith(isFollowing: isFollowing),
        metrics: profile.metrics.copyWith(
          followersCount: nextCount < 0 ? 0 : nextCount,
        ),
      ),
    );
  }

  void applyOptimisticSaved(bool isSaved) {
    final profile = state.value;
    if (profile == null || profile.viewer.isSaved == isSaved) return;

    state = AsyncValue.data(
      profile.copyWith(viewer: profile.viewer.copyWith(isSaved: isSaved)),
    );
  }

  void restore(SalonViewProfileModel? snapshot) {
    if (snapshot == null) return;
    state = AsyncValue.data(snapshot);
  }
}
