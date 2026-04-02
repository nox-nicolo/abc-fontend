// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_stylists.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(CreateStylistViewModel)
final createStylistViewModelProvider = CreateStylistViewModelProvider._();

final class CreateStylistViewModelProvider
    extends
        $NotifierProvider<
          CreateStylistViewModel,
          AsyncValue<CreateSalonStylistResponse?>
        > {
  CreateStylistViewModelProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'createStylistViewModelProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$createStylistViewModelHash();

  @$internal
  @override
  CreateStylistViewModel create() => CreateStylistViewModel();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AsyncValue<CreateSalonStylistResponse?> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride:
          $SyncValueProvider<AsyncValue<CreateSalonStylistResponse?>>(value),
    );
  }
}

String _$createStylistViewModelHash() =>
    r'd65ff1c817f060ec479deae31b994555a606bc30';

abstract class _$CreateStylistViewModel
    extends $Notifier<AsyncValue<CreateSalonStylistResponse?>> {
  AsyncValue<CreateSalonStylistResponse?> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref =
        this.ref
            as $Ref<
              AsyncValue<CreateSalonStylistResponse?>,
              AsyncValue<CreateSalonStylistResponse?>
            >;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<
                AsyncValue<CreateSalonStylistResponse?>,
                AsyncValue<CreateSalonStylistResponse?>
              >,
              AsyncValue<CreateSalonStylistResponse?>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
