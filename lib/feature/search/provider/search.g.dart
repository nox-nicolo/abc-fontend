// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'search.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(search)
final searchProvider = SearchProvider._();

final class SearchProvider
    extends
        $FunctionalProvider<
          SearchRepositoryImpl,
          SearchRepositoryImpl,
          SearchRepositoryImpl
        >
    with $Provider<SearchRepositoryImpl> {
  SearchProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'searchProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$searchHash();

  @$internal
  @override
  $ProviderElement<SearchRepositoryImpl> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  SearchRepositoryImpl create(Ref ref) {
    return search(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SearchRepositoryImpl value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<SearchRepositoryImpl>(value),
    );
  }
}

String _$searchHash() => r'31a3669da6555fd583d6c62eb52cdcba98febf29';
