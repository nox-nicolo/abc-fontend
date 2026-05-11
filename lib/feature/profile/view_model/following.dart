import 'package:africa_beuty/feature/profile/model/following.dart';
import 'package:africa_beuty/feature/profile/providers/customer_profile.dart';
import 'package:fpdart/fpdart.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'following.g.dart';

@riverpod
class MyFollowingViewModel extends _$MyFollowingViewModel {
  @override
  AsyncValue<List<FollowedSalonModel>> build() {
    _fetch();
    return const AsyncValue.loading();
  }

  Future<void> _fetch() async {
    final repo = ref.read(customerProfileRepositoryProvider);
    final res = await repo.getMyFollowing();
    if (!ref.mounted) return;
    switch (res) {
      case Left(value: final l):
        state = AsyncValue.error(l.message, StackTrace.current);
      case Right(value: final r):
        state = AsyncValue.data(r);
    }
  }

  Future<void> refresh() => _fetch();

  Future<bool> unfollow(String salonId) async {
    final current = state.value;
    if (current != null) {
      state = AsyncValue.data(
        current.where((s) => s.salonId != salonId).toList(),
      );
    }

    final repo = ref.read(customerProfileRepositoryProvider);
    final res = await repo.unfollowSalon(salonId);
    switch (res) {
      case Left(value: final l):
        if (current != null) {
          state = AsyncValue.data(current);
        } else {
          state = AsyncValue.error(l.message, StackTrace.current);
        }
        return false;
      case Right():
        return true;
    }
  }
}
