// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'post_hashtags.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(hashtagRemoteRepoProvider)
final hashtagRemoteRepoProviderProvider = HashtagRemoteRepoProviderProvider._();

final class HashtagRemoteRepoProviderProvider
    extends
        $FunctionalProvider<
          HashtagRepositoryImpl,
          HashtagRepositoryImpl,
          HashtagRepositoryImpl
        >
    with $Provider<HashtagRepositoryImpl> {
  HashtagRemoteRepoProviderProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'hashtagRemoteRepoProviderProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$hashtagRemoteRepoProviderHash();

  @$internal
  @override
  $ProviderElement<HashtagRepositoryImpl> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  HashtagRepositoryImpl create(Ref ref) {
    return hashtagRemoteRepoProvider(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(HashtagRepositoryImpl value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<HashtagRepositoryImpl>(value),
    );
  }
}

String _$hashtagRemoteRepoProviderHash() =>
    r'307ab9143801465f83d34419cfb7ede201cee279';

@ProviderFor(hashtagLocalRepoProvider)
final hashtagLocalRepoProviderProvider = HashtagLocalRepoProviderProvider._();

final class HashtagLocalRepoProviderProvider
    extends
        $FunctionalProvider<
          HashtagLocalRepository,
          HashtagLocalRepository,
          HashtagLocalRepository
        >
    with $Provider<HashtagLocalRepository> {
  HashtagLocalRepoProviderProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'hashtagLocalRepoProviderProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$hashtagLocalRepoProviderHash();

  @$internal
  @override
  $ProviderElement<HashtagLocalRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  HashtagLocalRepository create(Ref ref) {
    return hashtagLocalRepoProvider(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(HashtagLocalRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<HashtagLocalRepository>(value),
    );
  }
}

String _$hashtagLocalRepoProviderHash() =>
    r'b48ee3c4d4e5e61120ed765df36e689c38cead09';
