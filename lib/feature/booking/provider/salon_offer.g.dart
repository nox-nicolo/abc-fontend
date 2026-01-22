// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'salon_offer.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(salonOfferRepository)
final salonOfferRepositoryProvider = SalonOfferRepositoryProvider._();

final class SalonOfferRepositoryProvider
    extends
        $FunctionalProvider<
          SalonOfferRepository,
          SalonOfferRepository,
          SalonOfferRepository
        >
    with $Provider<SalonOfferRepository> {
  SalonOfferRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'salonOfferRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$salonOfferRepositoryHash();

  @$internal
  @override
  $ProviderElement<SalonOfferRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  SalonOfferRepository create(Ref ref) {
    return salonOfferRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SalonOfferRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<SalonOfferRepository>(value),
    );
  }
}

String _$salonOfferRepositoryHash() =>
    r'5059b5a3a3f9413e99285be12dbcc66ff63df9ec';
