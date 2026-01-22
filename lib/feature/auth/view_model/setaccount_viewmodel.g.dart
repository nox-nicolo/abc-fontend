// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'setaccount_viewmodel.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(SetProfileViewModel)
final setProfileViewModelProvider = SetProfileViewModelProvider._();

final class SetProfileViewModelProvider
    extends
        $NotifierProvider<SetProfileViewModel, AsyncValue<SetAccountModel>?> {
  SetProfileViewModelProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'setProfileViewModelProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$setProfileViewModelHash();

  @$internal
  @override
  SetProfileViewModel create() => SetProfileViewModel();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AsyncValue<SetAccountModel>? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AsyncValue<SetAccountModel>?>(value),
    );
  }
}

String _$setProfileViewModelHash() =>
    r'd5390fc410c9e4c06d72a4a985a66a1b26615a77';

abstract class _$SetProfileViewModel
    extends $Notifier<AsyncValue<SetAccountModel>?> {
  AsyncValue<SetAccountModel>? build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref =
        this.ref
            as $Ref<AsyncValue<SetAccountModel>?, AsyncValue<SetAccountModel>?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<
                AsyncValue<SetAccountModel>?,
                AsyncValue<SetAccountModel>?
              >,
              AsyncValue<SetAccountModel>?,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
