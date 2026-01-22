// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'post_settings.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(PostSettingsViewModel)
final postSettingsViewModelProvider = PostSettingsViewModelProvider._();

final class PostSettingsViewModelProvider
    extends $AsyncNotifierProvider<PostSettingsViewModel, PostSettings> {
  PostSettingsViewModelProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'postSettingsViewModelProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$postSettingsViewModelHash();

  @$internal
  @override
  PostSettingsViewModel create() => PostSettingsViewModel();
}

String _$postSettingsViewModelHash() =>
    r'df07bf709785d224852aa4e0db976d856a811467';

abstract class _$PostSettingsViewModel extends $AsyncNotifier<PostSettings> {
  FutureOr<PostSettings> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AsyncValue<PostSettings>, PostSettings>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<PostSettings>, PostSettings>,
              AsyncValue<PostSettings>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
