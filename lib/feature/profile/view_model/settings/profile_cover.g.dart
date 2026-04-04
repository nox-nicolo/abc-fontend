// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'profile_cover.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(SalonUpdateViewModel)
final salonUpdateViewModelProvider = SalonUpdateViewModelProvider._();

final class SalonUpdateViewModelProvider
    extends $NotifierProvider<SalonUpdateViewModel, AsyncValue<MediaUpdate?>> {
  SalonUpdateViewModelProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'salonUpdateViewModelProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$salonUpdateViewModelHash();

  @$internal
  @override
  SalonUpdateViewModel create() => SalonUpdateViewModel();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AsyncValue<MediaUpdate?> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AsyncValue<MediaUpdate?>>(value),
    );
  }
}

String _$salonUpdateViewModelHash() =>
    r'b668b7cec250fe4c7ed9d0162bffdda4627450f0';

abstract class _$SalonUpdateViewModel
    extends $Notifier<AsyncValue<MediaUpdate?>> {
  AsyncValue<MediaUpdate?> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref =
        this.ref as $Ref<AsyncValue<MediaUpdate?>, AsyncValue<MediaUpdate?>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<MediaUpdate?>, AsyncValue<MediaUpdate?>>,
              AsyncValue<MediaUpdate?>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
