// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'me_viewmodel.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(MeViewModel)
final meViewModelProvider = MeViewModelProvider._();

final class MeViewModelProvider
    extends $NotifierProvider<MeViewModel, AsyncValue<MeModel>?> {
  MeViewModelProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'meViewModelProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$meViewModelHash();

  @$internal
  @override
  MeViewModel create() => MeViewModel();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AsyncValue<MeModel>? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AsyncValue<MeModel>?>(value),
    );
  }
}

String _$meViewModelHash() => r'f4724f304f9546d9b63315a3cee5d3dfad7d275c';

abstract class _$MeViewModel extends $Notifier<AsyncValue<MeModel>?> {
  AsyncValue<MeModel>? build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AsyncValue<MeModel>?, AsyncValue<MeModel>?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<MeModel>?, AsyncValue<MeModel>?>,
              AsyncValue<MeModel>?,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
