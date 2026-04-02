// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(CreateService)
final createServiceProvider = CreateServiceProvider._();

final class CreateServiceProvider
    extends $NotifierProvider<CreateService, AsyncValue<String?>> {
  CreateServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'createServiceProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$createServiceHash();

  @$internal
  @override
  CreateService create() => CreateService();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AsyncValue<String?> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AsyncValue<String?>>(value),
    );
  }
}

String _$createServiceHash() => r'a4c8588ba186505ec9fc3d09bbefdac6400a6d20';

abstract class _$CreateService extends $Notifier<AsyncValue<String?>> {
  AsyncValue<String?> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AsyncValue<String?>, AsyncValue<String?>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<String?>, AsyncValue<String?>>,
              AsyncValue<String?>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
