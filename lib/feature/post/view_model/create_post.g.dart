// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_post.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(CreatePostViewModel)
final createPostViewModelProvider = CreatePostViewModelProvider._();

final class CreatePostViewModelProvider
    extends $NotifierProvider<CreatePostViewModel, CreatePostState> {
  CreatePostViewModelProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'createPostViewModelProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$createPostViewModelHash();

  @$internal
  @override
  CreatePostViewModel create() => CreatePostViewModel();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(CreatePostState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<CreatePostState>(value),
    );
  }
}

String _$createPostViewModelHash() =>
    r'639a07d2d67a95c011569b0d55c25e48c3471a50';

abstract class _$CreatePostViewModel extends $Notifier<CreatePostState> {
  CreatePostState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<CreatePostState, CreatePostState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<CreatePostState, CreatePostState>,
              CreatePostState,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
