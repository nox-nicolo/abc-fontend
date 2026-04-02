// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'view_stylists.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(SalonStylistViewModel)
final salonStylistViewModelProvider = SalonStylistViewModelProvider._();

final class SalonStylistViewModelProvider
    extends
        $NotifierProvider<
          SalonStylistViewModel,
          AsyncValue<StylistListResponse>
        > {
  SalonStylistViewModelProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'salonStylistViewModelProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$salonStylistViewModelHash();

  @$internal
  @override
  SalonStylistViewModel create() => SalonStylistViewModel();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AsyncValue<StylistListResponse> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AsyncValue<StylistListResponse>>(
        value,
      ),
    );
  }
}

String _$salonStylistViewModelHash() =>
    r'9fb36801e48b5588f9d0e73e6e21f45dcd8c2bec';

abstract class _$SalonStylistViewModel
    extends $Notifier<AsyncValue<StylistListResponse>> {
  AsyncValue<StylistListResponse> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref =
        this.ref
            as $Ref<
              AsyncValue<StylistListResponse>,
              AsyncValue<StylistListResponse>
            >;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<
                AsyncValue<StylistListResponse>,
                AsyncValue<StylistListResponse>
              >,
              AsyncValue<StylistListResponse>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
