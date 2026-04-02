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
        $AsyncNotifierProvider<
          SalonServiceConfigDetailViewModel,
          SalonServiceConfigDetailResponseModel
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
    r'c448c41f712d9f17eaaf2fd36128d818e51082c8';

final class SalonServiceConfigDetailViewModelFamily extends $Family
    with
        $ClassFamilyOverride<
          SalonServiceConfigDetailViewModel,
          AsyncValue<SalonServiceConfigDetailResponseModel>,
          SalonServiceConfigDetailResponseModel,
          FutureOr<SalonServiceConfigDetailResponseModel>,
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
    extends $AsyncNotifier<SalonServiceConfigDetailResponseModel> {
  late final _$args = ref.$arg as ({String serviceId, String subServiceId});
  String get serviceId => _$args.serviceId;
  String get subServiceId => _$args.subServiceId;

  FutureOr<SalonServiceConfigDetailResponseModel> build({
    required String serviceId,
    required String subServiceId,
  });
  @$mustCallSuper
  @override
  void runBuild() {
    final ref =
        this.ref
            as $Ref<
              AsyncValue<SalonServiceConfigDetailResponseModel>,
              SalonServiceConfigDetailResponseModel
            >;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<
                AsyncValue<SalonServiceConfigDetailResponseModel>,
                SalonServiceConfigDetailResponseModel
              >,
              AsyncValue<SalonServiceConfigDetailResponseModel>,
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
