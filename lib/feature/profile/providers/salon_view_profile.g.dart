// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'salon_view_profile.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(salonRepository)
final salonRepositoryProvider = SalonRepositoryProvider._();

final class SalonRepositoryProvider
    extends
        $FunctionalProvider<SalonRepository, SalonRepository, SalonRepository>
    with $Provider<SalonRepository> {
  SalonRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'salonRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$salonRepositoryHash();

  @$internal
  @override
  $ProviderElement<SalonRepository> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  SalonRepository create(Ref ref) {
    return salonRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SalonRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<SalonRepository>(value),
    );
  }
}

String _$salonRepositoryHash() => r'3da9f200bf37032dd34c6c1d0208a662e54bc406';
