// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'hashtag.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(hashtagRepository)
final hashtagRepositoryProvider = HashtagRepositoryProvider._();

final class HashtagRepositoryProvider
    extends
        $FunctionalProvider<
          HashtagRepositoryImpl,
          HashtagRepositoryImpl,
          HashtagRepositoryImpl
        >
    with $Provider<HashtagRepositoryImpl> {
  HashtagRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'hashtagRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$hashtagRepositoryHash();

  @$internal
  @override
  $ProviderElement<HashtagRepositoryImpl> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  HashtagRepositoryImpl create(Ref ref) {
    return hashtagRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(HashtagRepositoryImpl value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<HashtagRepositoryImpl>(value),
    );
  }
}

String _$hashtagRepositoryHash() => r'494c87751ef9229e4b48d88706f6438a669ac5af';
