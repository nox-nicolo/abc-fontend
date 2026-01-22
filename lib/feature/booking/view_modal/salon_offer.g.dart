// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'salon_offer.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(SalonOfferViewModel)
final salonOfferViewModelProvider = SalonOfferViewModelFamily._();

final class SalonOfferViewModelProvider
    extends
        $NotifierProvider<
          SalonOfferViewModel,
          AsyncValue<List<SalonOfferModel>>
        > {
  SalonOfferViewModelProvider._({
    required SalonOfferViewModelFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'salonOfferViewModelProvider',
         isAutoDispose: false,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$salonOfferViewModelHash();

  @override
  String toString() {
    return r'salonOfferViewModelProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  SalonOfferViewModel create() => SalonOfferViewModel();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AsyncValue<List<SalonOfferModel>> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AsyncValue<List<SalonOfferModel>>>(
        value,
      ),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is SalonOfferViewModelProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$salonOfferViewModelHash() =>
    r'011f7e79bc2d4732512c95bc1eb8e5f534147772';

final class SalonOfferViewModelFamily extends $Family
    with
        $ClassFamilyOverride<
          SalonOfferViewModel,
          AsyncValue<List<SalonOfferModel>>,
          AsyncValue<List<SalonOfferModel>>,
          AsyncValue<List<SalonOfferModel>>,
          String
        > {
  SalonOfferViewModelFamily._()
    : super(
        retry: null,
        name: r'salonOfferViewModelProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: false,
      );

  SalonOfferViewModelProvider call(String subServiceId) =>
      SalonOfferViewModelProvider._(argument: subServiceId, from: this);

  @override
  String toString() => r'salonOfferViewModelProvider';
}

abstract class _$SalonOfferViewModel
    extends $Notifier<AsyncValue<List<SalonOfferModel>>> {
  late final _$args = ref.$arg as String;
  String get subServiceId => _$args;

  AsyncValue<List<SalonOfferModel>> build(String subServiceId);
  @$mustCallSuper
  @override
  void runBuild() {
    final ref =
        this.ref
            as $Ref<
              AsyncValue<List<SalonOfferModel>>,
              AsyncValue<List<SalonOfferModel>>
            >;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<
                AsyncValue<List<SalonOfferModel>>,
                AsyncValue<List<SalonOfferModel>>
              >,
              AsyncValue<List<SalonOfferModel>>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, () => build(_$args));
  }
}
