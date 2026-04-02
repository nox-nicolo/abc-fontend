// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'service.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(SalonServicesViewModel)
final salonServicesViewModelProvider = SalonServicesViewModelProvider._();

final class SalonServicesViewModelProvider
    extends
        $NotifierProvider<
          SalonServicesViewModel,
          AsyncValue<List<SalonServiceItemModel>>
        > {
  SalonServicesViewModelProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'salonServicesViewModelProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$salonServicesViewModelHash();

  @$internal
  @override
  SalonServicesViewModel create() => SalonServicesViewModel();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AsyncValue<List<SalonServiceItemModel>> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride:
          $SyncValueProvider<AsyncValue<List<SalonServiceItemModel>>>(value),
    );
  }
}

String _$salonServicesViewModelHash() =>
    r'3064c23c2bfa2fcbb7420ec337c1a5c202898784';

abstract class _$SalonServicesViewModel
    extends $Notifier<AsyncValue<List<SalonServiceItemModel>>> {
  AsyncValue<List<SalonServiceItemModel>> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref =
        this.ref
            as $Ref<
              AsyncValue<List<SalonServiceItemModel>>,
              AsyncValue<List<SalonServiceItemModel>>
            >;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<
                AsyncValue<List<SalonServiceItemModel>>,
                AsyncValue<List<SalonServiceItemModel>>
              >,
              AsyncValue<List<SalonServiceItemModel>>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
