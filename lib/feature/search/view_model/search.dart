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

    // Clear results if empty
    if (query.isEmpty) {
      _debounce?.cancel();
      state = const AsyncData([]);
      return;
    }

    // Debounce search
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 400), () {
      _search(query);
    });
  }

  // ----------------------------------------------------------
  // SEARCH
  // ----------------------------------------------------------
  Future<void> _search(String query) async {
    state = const AsyncLoading();

    final res = await _repository.search(
      query: query,
      limit: 20,
    );

    state = switch (res) {
      Left(value: final failure) =>
        AsyncError(failure.message, StackTrace.current),

      Right(value: final results) =>
        AsyncData(results),
    };
  }

  // ----------------------------------------------------------
  // CLEAR
  // ----------------------------------------------------------
  void clear() {
    _debounce?.cancel();
    _query = '';
    state = const AsyncData([]);
  }

  // Optional getter if UI needs it
  String get query => _query;
}
