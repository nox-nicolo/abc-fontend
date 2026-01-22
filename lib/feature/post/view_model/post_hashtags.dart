import 'package:africa_beuty/feature/post/model/post_hashtags.dart';
import 'package:africa_beuty/feature/post/providers/post_hashtags.dart';
import 'package:africa_beuty/feature/post/repositories/post_hashtags.dart';
import 'package:africa_beuty/feature/post/repositories/post_hashtags_local.dart';
import 'package:africa_beuty/feature/post/state/hashtag.dart';
import 'package:fpdart/fpdart.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'post_hashtags.g.dart';

@riverpod
class HashtagViewModel extends _$HashtagViewModel {
  HashtagRepositoryImpl get _remote => ref.read(hashtagRemoteRepoProviderProvider);
  HashtagLocalRepository get _local => ref.read(hashtagLocalRepoProviderProvider);

  @override
  AsyncValue<HashtagState> build() {
    // initial state: maybe load cached recent immediately
    return AsyncValue.data(const HashtagState());
  }

  /// Load recent from local cache and then suggestions from remote
  Future<void> loadInitial() async {
    // show loading if there is no data yet
    if (state.value == null || (state.value?.results.isEmpty ?? true)) {
      state = const AsyncValue.loading();
    }

    // Load local recent immediately (non-blocking)
    final cached = await _local.getRecentHashtags();
    if (cached.isNotEmpty) {
      state = AsyncValue.data(HashtagState(recent: cached));
    }

    // Fetch suggestions/trending
    final res = await _remote.suggestions();
    state = switch (res) {
      Left(value: final l) => AsyncValue.error(l.message, StackTrace.current),
      Right(value: final r) => AsyncValue.data(
        (state.value ?? const HashtagState()).copyWith(results: r),
      ),
    };
  }

  /// Search by query (remote). Empty query resets results.
  Future<void> search(String query) async {
    if (query.trim().isEmpty) {
      state = AsyncValue.data((state.value ?? const HashtagState()).copyWith(results: []));
      return;
    }
    // set a lightweight loading flag inside state if you have one,
    // for now replace whole AsyncValue with results-loading indicator
    state = AsyncValue.data((state.value ?? const HashtagState()).copyWith(loading: true));

    final res = await _remote.search(query);
    state = switch (res) {
      Left(value: final l) => AsyncValue.error(l.message, StackTrace.current),
      Right(value: final r) => AsyncValue.data(
        (state.value ?? const HashtagState()).copyWith(results: r, loading: false),
      ),
    };
  }

  /// Toggle selection of a hashtag (string)
  void toggleSelect(String tag) {
    final cur = state.value ?? const HashtagState();
    final exists = cur.selected.any((s) => s.toLowerCase() == tag.toLowerCase());
    final updated = exists
        ? cur.selected.where((s) => s.toLowerCase() != tag.toLowerCase()).toList()
        : [...cur.selected, tag];

    state = AsyncValue.data(cur.copyWith(selected: updated));
  }

  /// Explicitly set the selected hashtags (replaces provider selection).
  /// Use this when page receives an initial selection to *synchronize* state.
  void setSelected(List<String> tags) {
    final cur = state.value ?? const HashtagState();
    // normalize unique tags, preserving order of provided tags
    final normalized = <String>[];
    for (final t in tags) {
      final tag = t.trim();
      if (tag.isEmpty) continue;
      if (!normalized.any((e) => e.toLowerCase() == tag.toLowerCase())) {
        normalized.add(tag);
      }
    }
    state = AsyncValue.data(cur.copyWith(selected: normalized));
  }

  /// Add new hashtag (user-created). Also push to recent local cache.
  Future<void> addNewHashtag(String raw) async {
    final tag = raw.trim().startsWith('#') ? raw.trim() : '#${raw.trim()}';
    if (tag.length <= 1) return;
    // update selected
    final cur = state.value ?? const HashtagState();
    final updatedSelected = [...cur.selected];
    if (!updatedSelected.any((s) => s.toLowerCase() == tag.toLowerCase())) {
      updatedSelected.add(tag);
    }

    // update local recent cache
    await _local.addToRecent(tag);

    // update state
    final newRecent = [
      PostHashtagsModel(name: tag, number: 1),
      ...cur.recent.where((r) => r.name.toLowerCase() != tag.toLowerCase())
    ];

    state = AsyncValue.data(cur.copyWith(selected: updatedSelected, recent: newRecent));
  }

  /// Persist selected hashtags to recent cache (call when user confirms done)
  Future<void> persistSelectedAsRecent() async {
    final cur = state.value ?? const HashtagState();
    // convert to models (number left as 1)
    final models = cur.selected.map((s) => PostHashtagsModel(name: s, number: 1)).toList();
    // merge with existing recent (de-duplicate)
    final merged = [
      ...models,
      ...cur.recent.where((r) => !models.any((m) => m.name.toLowerCase() == r.name.toLowerCase()))
    ];
    await _local.saveRecentHashtags(merged.take(50).toList());
    state = AsyncValue.data(cur.copyWith(recent: merged.take(50).toList()));
  }

  /// Clear selected list
  void clearSelection() {
    final cur = state.value ?? const HashtagState();
    state = AsyncValue.data(cur.copyWith(selected: []));
  }
}
