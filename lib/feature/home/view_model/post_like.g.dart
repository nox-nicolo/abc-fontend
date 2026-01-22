// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'post_like.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(PostLikeViewModel)
final postLikeViewModelProvider = PostLikeViewModelProvider._();

final class PostLikeViewModelProvider
    extends $NotifierProvider<PostLikeViewModel, AsyncValue<PostLikeModel>?> {
  PostLikeViewModelProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'postLikeViewModelProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$postLikeViewModelHash();

  @$internal
  @override
  PostLikeViewModel create() => PostLikeViewModel();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AsyncValue<PostLikeModel>? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AsyncValue<PostLikeModel>?>(value),
    );
  }
}

String _$postLikeViewModelHash() => r'2de9c35cea6221c5cbfec3cf61edc32059d1bb8e';

abstract class _$PostLikeViewModel
    extends $Notifier<AsyncValue<PostLikeModel>?> {
  AsyncValue<PostLikeModel>? build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref =
        this.ref
            as $Ref<AsyncValue<PostLikeModel>?, AsyncValue<PostLikeModel>?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<
                AsyncValue<PostLikeModel>?,
                AsyncValue<PostLikeModel>?
              >,
              AsyncValue<PostLikeModel>?,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
