// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'remote_category_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(categoryRemoteRepository)
final categoryRemoteRepositoryProvider = CategoryRemoteRepositoryProvider._();

final class CategoryRemoteRepositoryProvider
    extends
        $FunctionalProvider<
          RemotePostCategories,
          RemotePostCategories,
          RemotePostCategories
        >
    with $Provider<RemotePostCategories> {
  CategoryRemoteRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'categoryRemoteRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$categoryRemoteRepositoryHash();

  @$internal
  @override
  $ProviderElement<RemotePostCategories> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  RemotePostCategories create(Ref ref) {
    return categoryRemoteRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(RemotePostCategories value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<RemotePostCategories>(value),
    );
  }
}

String _$categoryRemoteRepositoryHash() =>
    r'cbbd30738ec1313196cfcf66c91589c52e05f945';
