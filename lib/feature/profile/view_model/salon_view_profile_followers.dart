import 'package:africa_beuty/feature/profile/providers/salon_view_profile.dart';
import 'package:africa_beuty/feature/profile/states/salon_view_profile_viewstate.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'salon_view_profile_followers.g.dart';

@riverpod
class SalonFollowersViewModel extends _$SalonFollowersViewModel {
  @override
  SalonFollowersState build(String salonId) {
    return SalonFollowersState.initial();
  }

  Future<void> loadInitial(String salonId) async {
    if (!state.isLoading) return;

    final repository = ref.read(salonRepositoryProvider);
    final res = await repository.getSalonFollowers(salonId);

    res.fold(
      (_) {
        state = state.copyWith(isLoading: false);
      },
      (data) {
        state = state.copyWith(
          items: data.items,
          count: data.count,
          nextCursor: data.nextCursor,
          isLoading: false,
        );
      },
    );
  }

  Future<void> loadMore(String salonId) async {
    if (state.isLoadingMore || state.nextCursor == null) return;

    state = state.copyWith(isLoadingMore: true);

    final repository = ref.read(salonRepositoryProvider);
    final res = await repository.getSalonFollowers(
      salonId,
      cursor: state.nextCursor,
    );

    res.fold(
      (_) {
        state = state.copyWith(isLoadingMore: false);
      },
      (data) {
        state = state.copyWith(
          items: [...state.items, ...data.items],
          nextCursor: data.nextCursor,
          isLoadingMore: false,
        );
      },
    );
  }

  Future<void> refresh(String salonId) async {
    state = SalonFollowersState.initial();
    await loadInitial(salonId);
  }
}
