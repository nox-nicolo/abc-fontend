// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'getmajor_viewmodel.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(GetMajorServiceViewModel)
final getMajorServiceViewModelProvider = GetMajorServiceViewModelProvider._();

final class GetMajorServiceViewModelProvider
    extends
        $NotifierProvider<
          GetMajorServiceViewModel,
          AsyncValue<List<MajorServiceModel>>?
        > {
  GetMajorServiceViewModelProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'getMajorServiceViewModelProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$getMajorServiceViewModelHash();

  @$internal
  @override
  GetMajorServiceViewModel create() => GetMajorServiceViewModel();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AsyncValue<List<MajorServiceModel>>? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride:
          $SyncValueProvider<AsyncValue<List<MajorServiceModel>>?>(value),
    );
  }
}

String _$getMajorServiceViewModelHash() =>
    r'1ea1f9ab1db946a566b76863a307f72aaf2e3e5e';

abstract class _$GetMajorServiceViewModel
    extends $Notifier<AsyncValue<List<MajorServiceModel>>?> {
  AsyncValue<List<MajorServiceModel>>? build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref =
        this.ref
            as $Ref<
              AsyncValue<List<MajorServiceModel>>?,
              AsyncValue<List<MajorServiceModel>>?
            >;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<
                AsyncValue<List<MajorServiceModel>>?,
                AsyncValue<List<MajorServiceModel>>?
              >,
              AsyncValue<List<MajorServiceModel>>?,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
