import 'package:africa_beuty/feature/home/model/home_posts.dart';
import 'package:africa_beuty/feature/home/provider/home.dart';
import 'package:africa_beuty/feature/home/repository/home.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'home_posts.g.dart';

@riverpod
class FeedViewModel extends _$FeedViewModel {
  late final HomeRepository _repository;
  String? _cursor;
  bool _isLoadingMore = false;
  int _requestId = 0;

  bool get hasMore => _cursor != null;
  bool get isLoadingMore => _isLoadingMore;

  @override
  AsyncValue<List<PostModel>> build() {
    _repository = ref.read(homeRepositoryImplProvider);
    _load();
    return const AsyncLoading();
  }

  // ----------------------------------------------------------
  // INITIAL LOAD
  // ----------------------------------------------------------
  Future<void> _load() async {
    final requestId = ++_requestId;
    final res = await _repository.getFeed(limit: 20, cursor: _cursor);

    if (!ref.mounted || requestId != _requestId) return;

    state = res.fold(
      (failure) => state.hasValue
          ? state
          : AsyncError(failure.message, StackTrace.current),
      (response) {
        _cursor = response.nextCursor;
        return AsyncData(response.items);
      },
    );
  }

  // ----------------------------------------------------------
  // LOAD MORE (PAGINATION)
  // ----------------------------------------------------------
  Future<void> loadMore() async {
    if (_isLoadingMore || _cursor == null || state.value == null) return;
    _isLoadingMore = true;

    final res = await _repository.getFeed(limit: 20, cursor: _cursor);

    res.fold(
      (_) {
        _isLoadingMore = false;
      },
      (response) {
        _cursor = response.nextCursor; // ✅ advance cursor
        state = AsyncData([
          ...state.value!,
          ...response.items, // ✅ append items
        ]);
        _isLoadingMore = false;
      },
    );
  }

  // ----------------------------------------------------------
  // REFRESH
  // ----------------------------------------------------------
  Future<void> refresh() async {
    _cursor = null;
    if (!state.hasValue) {
      state = const AsyncLoading();
    }
    await _load();
  }
}
