// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'services.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(salonServiceRepository)
final salonServiceRepositoryProvider = SalonServiceRepositoryProvider._();

final class SalonServiceRepositoryProvider
    extends
        $FunctionalProvider<
          SalonServiceRepository,
          SalonServiceRepository,
          SalonServiceRepository
        >
    with $Provider<SalonServiceRepository> {
  SalonServiceRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'salonServiceRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$salonServiceRepositoryHash();

  @$internal
  @override
  $ProviderElement<SalonServiceRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  SalonServiceRepository create(Ref ref) {
    return salonServiceRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SalonServiceRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<SalonServiceRepository>(value),
    );
  }
}

String _$salonServiceRepositoryHash() =>
    r'f5714a6a95314e0cfdeac4a8719801bd6f5b1078';
