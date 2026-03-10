// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'config_service_update_create.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(ConfigServiceUpdateCreateViewModel)
final configServiceUpdateCreateViewModelProvider =
    ConfigServiceUpdateCreateViewModelProvider._();

final class ConfigServiceUpdateCreateViewModelProvider
    extends
        $NotifierProvider<
          ConfigServiceUpdateCreateViewModel,
          AsyncValue<void>
        > {
  ConfigServiceUpdateCreateViewModelProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'configServiceUpdateCreateViewModelProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() =>
      _$configServiceUpdateCreateViewModelHash();

  @$internal
  @override
  ConfigServiceUpdateCreateViewModel create() =>
      ConfigServiceUpdateCreateViewModel();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AsyncValue<void> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AsyncValue<void>>(value),
    );
  }
}

String _$configServiceUpdateCreateViewModelHash() =>
    r'0b0b116a9190a8fda6d5a5834b3601958046cea5';

abstract class _$ConfigServiceUpdateCreateViewModel
    extends $Notifier<AsyncValue<void>> {
  AsyncValue<void> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AsyncValue<void>, AsyncValue<void>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<void>, AsyncValue<void>>,
              AsyncValue<void>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
