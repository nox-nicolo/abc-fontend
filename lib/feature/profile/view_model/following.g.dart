// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'following.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(MyFollowingViewModel)
final myFollowingViewModelProvider = MyFollowingViewModelProvider._();

final class MyFollowingViewModelProvider
    extends
        $NotifierProvider<
          MyFollowingViewModel,
          AsyncValue<List<FollowedSalonModel>>
        > {
  MyFollowingViewModelProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'myFollowingViewModelProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$myFollowingViewModelHash();

  @$internal
  @override
  MyFollowingViewModel create() => MyFollowingViewModel();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AsyncValue<List<FollowedSalonModel>> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride:
          $SyncValueProvider<AsyncValue<List<FollowedSalonModel>>>(value),
    );
  }
}

String _$myFollowingViewModelHash() =>
    r'34855e84d4f68b9e5e1c9e3a4154fafaf1727578';

abstract class _$MyFollowingViewModel
    extends $Notifier<AsyncValue<List<FollowedSalonModel>>> {
  AsyncValue<List<FollowedSalonModel>> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref =
        this.ref
            as $Ref<
              AsyncValue<List<FollowedSalonModel>>,
              AsyncValue<List<FollowedSalonModel>>
            >;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<
                AsyncValue<List<FollowedSalonModel>>,
                AsyncValue<List<FollowedSalonModel>>
              >,
              AsyncValue<List<FollowedSalonModel>>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
