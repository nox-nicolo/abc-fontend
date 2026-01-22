// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'uploadaccount_viewmodel.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(UploadAccountViewModel)
final uploadAccountViewModelProvider = UploadAccountViewModelProvider._();

final class UploadAccountViewModelProvider
    extends
        $NotifierProvider<
          UploadAccountViewModel,
          AsyncValue<UploadAccountModel>?
        > {
  UploadAccountViewModelProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'uploadAccountViewModelProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$uploadAccountViewModelHash();

  @$internal
  @override
  UploadAccountViewModel create() => UploadAccountViewModel();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AsyncValue<UploadAccountModel>? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AsyncValue<UploadAccountModel>?>(
        value,
      ),
    );
  }
}

String _$uploadAccountViewModelHash() =>
    r'9d94dba47a17472d30c43794bc7e057a231ba0cb';

abstract class _$UploadAccountViewModel
    extends $Notifier<AsyncValue<UploadAccountModel>?> {
  AsyncValue<UploadAccountModel>? build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref =
        this.ref
            as $Ref<
              AsyncValue<UploadAccountModel>?,
              AsyncValue<UploadAccountModel>?
            >;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<
                AsyncValue<UploadAccountModel>?,
                AsyncValue<UploadAccountModel>?
              >,
              AsyncValue<UploadAccountModel>?,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
