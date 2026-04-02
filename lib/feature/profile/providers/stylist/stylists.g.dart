// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'stylists.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(salonStylistRepository)
final salonStylistRepositoryProvider = SalonStylistRepositoryProvider._();

final class SalonStylistRepositoryProvider
    extends
        $FunctionalProvider<
          SalonStylistRepository,
          SalonStylistRepository,
          SalonStylistRepository
        >
    with $Provider<SalonStylistRepository> {
  SalonStylistRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'salonStylistRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$salonStylistRepositoryHash();

  @$internal
  @override
  $ProviderElement<SalonStylistRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  SalonStylistRepository create(Ref ref) {
    return salonStylistRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SalonStylistRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<SalonStylistRepository>(value),
    );
  }
}

String _$salonStylistRepositoryHash() =>
    r'bbc8bf13a10b91549d0f9d5461c6ae80a78ce98e';
