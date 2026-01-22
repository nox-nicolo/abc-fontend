// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'post_repository_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(postRemoteRepoProvider)
final postRemoteRepoProviderProvider = PostRemoteRepoProviderProvider._();

final class PostRemoteRepoProviderProvider
    extends
        $FunctionalProvider<
          PostRepositoryImpl,
          PostRepositoryImpl,
          PostRepositoryImpl
        >
    with $Provider<PostRepositoryImpl> {
  PostRemoteRepoProviderProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'postRemoteRepoProviderProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$postRemoteRepoProviderHash();

  @$internal
  @override
  $ProviderElement<PostRepositoryImpl> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  PostRepositoryImpl create(Ref ref) {
    return postRemoteRepoProvider(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(PostRepositoryImpl value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<PostRepositoryImpl>(value),
    );
  }
}

String _$postRemoteRepoProviderHash() =>
    r'cdbddeb0db4078b711e0a57399450afd6408ccc6';
