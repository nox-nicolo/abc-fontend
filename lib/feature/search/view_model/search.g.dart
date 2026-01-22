// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'search.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(SearchViewModel)
final searchViewModelProvider = SearchViewModelProvider._();

final class SearchViewModelProvider
    extends $NotifierProvider<SearchViewModel, AsyncValue<List<SearchResult>>> {
  SearchViewModelProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'searchViewModelProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$searchViewModelHash();

  @$internal
  @override
  SearchViewModel create() => SearchViewModel();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AsyncValue<List<SearchResult>> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AsyncValue<List<SearchResult>>>(
        value,
      ),
    );
  }
}

String _$searchViewModelHash() => r'43fdadba5145f8468ffed28a0dfd9ab705db3829';

abstract class _$SearchViewModel
    extends $Notifier<AsyncValue<List<SearchResult>>> {
  AsyncValue<List<SearchResult>> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref =
        this.ref
            as $Ref<
              AsyncValue<List<SearchResult>>,
              AsyncValue<List<SearchResult>>
            >;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<
                AsyncValue<List<SearchResult>>,
                AsyncValue<List<SearchResult>>
              >,
              AsyncValue<List<SearchResult>>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
