import 'dart:async';

import 'package:africa_beuty/feature/search/model/hashtag.dart';
import 'package:africa_beuty/feature/search/provider/hashtag.dart';
import 'package:africa_beuty/feature/search/repository/hashtag.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'hashtags.g.dart';

@riverpod
class HashtagViewModel extends _$HashtagViewModel {
  late final HashtagRepository _repository;

  String? _cursor;
  String? _hashtagId;
  bool _isFetchingMore = false;

  @override
  AsyncValue<HashtagGridModel> build(String hashtagId) {
    _repository = ref.read(hashtagRepositoryProvider);
    _hashtagId = hashtagId;

    // initial load
    _loadInitial();

    return const AsyncLoading();
  }

  // ----------------------------------------------------------
  // INITIAL LOAD
  // ----------------------------------------------------------
  Future<void> _loadInitial() async {
    state = const AsyncLoading();

    final res = await _repository.getHashtagGrid(
      hashtagId: _hashtagId!,
      limit: 24,
    );

    res.match(
      (failure) {
        state = AsyncError(
          failure.message,
          StackTrace.current,
        );
      },
      (data) {
        _cursor = data.cursor;
        state = AsyncData(data);
      },
    );
  }


  // ----------------------------------------------------------
  // LOAD MORE (PAGINATION)
  // ----------------------------------------------------------
  Future<void> loadMore() async {
    if (_isFetchingMore || _cursor == null) return;

    final current = state.value;
    if (current == null) return;

    _isFetchingMore = true;

    final res = await _repository.getHashtagGrid(
      hashtagId: _hashtagId!,
      cursor: _cursor,
      limit: 24,
    );

    res.match(
      (failure) {
        // Silent fail for pagination (no state reset)
      },
      (next) {
        _cursor = next.cursor;

        state = AsyncData(
          current.copyWith(
            posts: [...current.posts, ...next.posts],
            cursor: next.cursor,
          ),
        );
      },
    );

    _isFetchingMore = false;
  }

  // ----------------------------------------------------------
  // REFRESH
  // ----------------------------------------------------------
  Future<void> refresh() async {
    _cursor = null;
    await _loadInitial();
  }
}
