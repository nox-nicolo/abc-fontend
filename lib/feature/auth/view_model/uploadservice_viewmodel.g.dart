// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'uploadservice_viewmodel.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(UploadServiceViewModel)
final uploadServiceViewModelProvider = UploadServiceViewModelProvider._();

final class UploadServiceViewModelProvider
    extends
        $NotifierProvider<
          UploadServiceViewModel,
          AsyncValue<UploadServiceModel>?
        > {
  UploadServiceViewModelProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'uploadServiceViewModelProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$uploadServiceViewModelHash();

  @$internal
  @override
  UploadServiceViewModel create() => UploadServiceViewModel();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AsyncValue<UploadServiceModel>? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AsyncValue<UploadServiceModel>?>(
        value,
      ),
    );
  }
}

String _$uploadServiceViewModelHash() =>
    r'b72ed9474e1df52bf784d63ae7c4376ecd7fdac9';

abstract class _$UploadServiceViewModel
    extends $Notifier<AsyncValue<UploadServiceModel>?> {
  AsyncValue<UploadServiceModel>? build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref =
        this.ref
            as $Ref<
              AsyncValue<UploadServiceModel>?,
              AsyncValue<UploadServiceModel>?
            >;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<
                AsyncValue<UploadServiceModel>?,
                AsyncValue<UploadServiceModel>?
              >,
              AsyncValue<UploadServiceModel>?,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
