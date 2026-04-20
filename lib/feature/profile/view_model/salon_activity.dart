import 'package:africa_beuty/feature/profile/model/salon_activity.dart';
import 'package:africa_beuty/feature/profile/providers/salon.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'salon_activity.g.dart';

@riverpod
class SalonActivityViewModel extends _$SalonActivityViewModel {
  String? _nextCursor;
  bool _hasMore = true;
  bool isLoadingMore = false;

  @override
  AsyncValue<List<ActivityItem>> build(String salonId) {
    return const AsyncValue.loading();
  }

  Future<void> getInitialActivity() async {
    _nextCursor = null;
    _hasMore = true;

    state = const AsyncValue.loading();

    final repository = ref.read(salonProfileProvider);
    final res = await repository.getActivityFeed(salonId: salonId);

    res.fold(
      (l) => state = AsyncValue.error(l.message, StackTrace.current),
      (r) {
        _nextCursor = r.nextCursor;
        _hasMore = r.nextCursor != null;
        state = AsyncValue.data(r.items);
      },
    );
  }

  Future<void> getMoreActivity() async {
    if (state.isLoading || !_hasMore || _nextCursor == null || isLoadingMore) {
      return;
    }

    isLoadingMore = true;
    final prev = state.value ?? const <ActivityItem>[];

    final repo = ref.read(salonProfileProvider);
    final res = await repo.getActivityFeed(
      salonId: salonId,
      cursor: _nextCursor,
    );

    res.fold(
      (l) {
        isLoadingMore = false;
        state = AsyncValue.data(prev);
      },
      (r) {
        _nextCursor = r.nextCursor;
        _hasMore = r.nextCursor != null;
        isLoadingMore = false;
        state = AsyncValue.data([...prev, ...r.items]);
      },
    );
  }
}
