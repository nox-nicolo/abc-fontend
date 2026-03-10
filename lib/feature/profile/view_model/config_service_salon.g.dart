// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'config_service_salon.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(SalonServiceConfigDetailViewModel)
final salonServiceConfigDetailViewModelProvider =
    SalonServiceConfigDetailViewModelFamily._();

final class SalonServiceConfigDetailViewModelProvider
    extends
        $NotifierProvider<
          SalonServiceConfigDetailViewModel,
          AsyncValue<SalonServiceConfigModel>
        > {
  SalonServiceConfigDetailViewModelProvider._({
    required SalonServiceConfigDetailViewModelFamily super.from,
    required ({String serviceId, String subServiceId}) super.argument,
  }) : super(
         retry: null,
         name: r'salonServiceConfigDetailViewModelProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() =>
      _$salonServiceConfigDetailViewModelHash();

  @override
  String toString() {
    return r'salonServiceConfigDetailViewModelProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  SalonServiceConfigDetailViewModel create() =>
      SalonServiceConfigDetailViewModel();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AsyncValue<SalonServiceConfigModel> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AsyncValue<SalonServiceConfigModel>>(
        value,
      ),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is SalonServiceConfigDetailViewModelProvider &&
        other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$salonServiceConfigDetailViewModelHash() =>
    r'd0060adc104f9ee4de0879815327e942da7a29c5';

final class SalonServiceConfigDetailViewModelFamily extends $Family
    with
        $ClassFamilyOverride<
          SalonServiceConfigDetailViewModel,
          AsyncValue<SalonServiceConfigModel>,
          AsyncValue<SalonServiceConfigModel>,
          AsyncValue<SalonServiceConfigModel>,
          ({String serviceId, String subServiceId})
        > {
  SalonServiceConfigDetailViewModelFamily._()
    : super(
        retry: null,
        name: r'salonServiceConfigDetailViewModelProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  SalonServiceConfigDetailViewModelProvider call({
    required String serviceId,
    required String subServiceId,
  }) => SalonServiceConfigDetailViewModelProvider._(
    argument: (serviceId: serviceId, subServiceId: subServiceId),
    from: this,
  );

  @override
  String toString() => r'salonServiceConfigDetailViewModelProvider';
}

abstract class _$SalonServiceConfigDetailViewModel
    extends $Notifier<AsyncValue<SalonServiceConfigModel>> {
  late final _$args = ref.$arg as ({String serviceId, String subServiceId});
  String get serviceId => _$args.serviceId;
  String get subServiceId => _$args.subServiceId;

  AsyncValue<SalonServiceConfigModel> build({
    required String serviceId,
    required String subServiceId,
  });
  @$mustCallSuper
  @override
  void runBuild() {
    final ref =
        this.ref
            as $Ref<
              AsyncValue<SalonServiceConfigModel>,
              AsyncValue<SalonServiceConfigModel>
            >;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<
                AsyncValue<SalonServiceConfigModel>,
                AsyncValue<SalonServiceConfigModel>
              >,
              AsyncValue<SalonServiceConfigModel>,
              Object?,
              Object?
            >;
    element.handleCreate(
      ref,
      () =>
          build(serviceId: _$args.serviceId, subServiceId: _$args.subServiceId),
    );
  }
}
