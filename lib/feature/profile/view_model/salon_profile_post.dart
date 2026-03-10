
import 'package:africa_beuty/feature/profile/model/salon_posts.dart';
import 'package:africa_beuty/feature/profile/providers/salon.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'salon_profile_post.g.dart';

@riverpod
class ProfilePostsViewModel extends _$ProfilePostsViewModel {
  String? _nextCursor;
  bool _hasMore = true;
  bool isLoadingMore = false;

  @override
  AsyncValue<List<PostModel>> build(String userId) {
    // We return loading initially. 
    // 'userId' is automatically saved as a property of this class.
    return const AsyncValue.loading();
  }

  Future<void> getInitialPosts() async {
    _nextCursor = null;
    _hasMore = true;
    
    state = const AsyncValue.loading();

    final repository = ref.read(salonProfileProvider);
    
    // Use 'userId' directly here (it comes from the build method)
    final res = await repository.getProfilePosts(profileUserId: userId);

    res.fold(
      (l) => state = AsyncValue.error(l.message, StackTrace.current),
      (r) {
        _nextCursor = r.nextCursor;
        _hasMore = r.nextCursor != null;
        state = AsyncValue.data(r.items);
      },
    );
  }

  Future<void> getMorePosts() async {
    if (state.isLoading || !_hasMore || _nextCursor == null || isLoadingMore) return;

    isLoadingMore = true;
    final prev = state.value ?? const <PostModel>[];

    final repo = ref.read(salonProfileProvider);
    final res = await repo.getProfilePosts(profileUserId: userId, cursor: _nextCursor);

    res.fold(
      (l) {
        isLoadingMore = false;
        // keep previous data; optionally show a snackbar
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

class ProfilePostsState {
  final List<PostModel> items;
  final bool isLoadingMore;

  const ProfilePostsState({required this.items, this.isLoadingMore = false});
}