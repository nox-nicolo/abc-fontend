import 'dart:async';

import 'package:africa_beuty/feature/search/model/search.dart';
import 'package:africa_beuty/feature/search/provider/search.dart';
import 'package:africa_beuty/feature/search/repository/search.dart';
import 'package:fpdart/fpdart.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'search.g.dart';

@riverpod
class SearchViewModel extends _$SearchViewModel {
  late final SearchRepository _repository;
  Timer? _debounce;

  String _query = '';
  String? _nextCursor;
  bool _isLoadingMore = false;
  int _requestSerial = 0;

  @override
  AsyncValue<List<SearchResult>> build() {
    _repository = ref.read(searchProvider);

    ref.onDispose(() {
      _debounce?.cancel();
    });

    // Initial state: no results
    return const AsyncData([]);
  }

  // ----------------------------------------------------------
  // QUERY CHANGED (DEBOUNCED)
  // ----------------------------------------------------------
  void onQueryChanged(String value) {
    final query = value.trim();
    _query = query;
    final requestId = ++_requestSerial;

    // Clear results if empty
    if (query.isEmpty) {
      _debounce?.cancel();
      _nextCursor = null;
      state = const AsyncData([]);
      return;
    }

    // Debounce search
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 400), () {
      _search(query, requestId);
    });
  }

  // ----------------------------------------------------------
  // SEARCH
  // ----------------------------------------------------------
  Future<void> _search(String query, int requestId) async {
    _nextCursor = null;
    state = const AsyncLoading();

    final res = await _repository.search(query: query, limit: 20);

    if (query != _query || requestId != _requestSerial) return;

    state = switch (res) {
      Left(value: final failure) => AsyncError(
        failure.message,
        StackTrace.current,
      ),

      Right(value: final page) => () {
        _nextCursor = page.nextCursor;
        return AsyncData(page.results);
      }(),
    };
  }

  Future<void> loadMore() async {
    final cursor = _nextCursor;
    if (cursor == null || _isLoadingMore || _query.isEmpty) return;

    final current =
        state.whenOrNull(data: (results) => results) ?? const <SearchResult>[];
    _isLoadingMore = true;
    final query = _query;

    final res = await _repository.search(
      query: query,
      limit: 20,
      cursor: cursor,
    );

    _isLoadingMore = false;
    if (query != _query) return;

    state = switch (res) {
      Left(value: final failure) => AsyncError(
        failure.message,
        StackTrace.current,
      ),
      Right(value: final page) => () {
        _nextCursor = page.nextCursor;
        return AsyncData([...current, ...page.results]);
      }(),
    };
  }

  // ----------------------------------------------------------
  // CLEAR
  // ----------------------------------------------------------
  void clear() {
    _debounce?.cancel();
    _query = '';
    _nextCursor = null;
    _requestSerial++;
    state = const AsyncData([]);
  }

  // Optional getter if UI needs it
  String get query => _query;
  bool get canLoadMore => _nextCursor != null && !_isLoadingMore;
  bool get isLoadingMore => _isLoadingMore;
}
