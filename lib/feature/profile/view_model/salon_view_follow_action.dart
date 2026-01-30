import 'package:africa_beuty/feature/profile/providers/salon_view_profile.dart';
import 'package:africa_beuty/feature/profile/view_model/salon_view_profile.dart';
import 'package:africa_beuty/feature/profile/view_model/salon_view_profile_followers.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'salon_view_follow_action.g.dart';

@riverpod
class SalonFollowActionViewModel extends _$SalonFollowActionViewModel {
  @override
  bool build() {
    // simple loading flag
    return false;
  }

  Future<void> follow({
    required String salonId,
  }) async {
    if (state) return;
    state = true;

    final repo = ref.read(salonRepositoryProvider);
    final res = await repo.followSalon(salonId);

    res.fold(
      (_) {},
      (_) {
        //  Refresh salon profile
        ref.invalidate(salonViewProfileViewModelProvider(salonId));

        // Optional: refresh followers list if opened
        ref.invalidate(salonFollowersViewModelProvider(salonId));
      },
    );

    state = false;
  }

  Future<bool> unfollow({
    required String salonId,
  }) async {
    state = true;

    final repo = ref.read(salonRepositoryProvider);
    final res = await repo.unfollowSalon(salonId);

    res.fold(
      (_) {},
      (_) {
        ref.invalidate(salonViewProfileViewModelProvider(salonId));
        ref.invalidate(salonFollowersViewModelProvider(salonId));
      },
    );

    state = false;

    return res.isRight();
  }
}
