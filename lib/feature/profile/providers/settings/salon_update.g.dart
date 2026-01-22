// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'salon_update.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(salonUpdate)
final salonUpdateProvider = SalonUpdateProvider._();

final class SalonUpdateProvider
    extends
        $FunctionalProvider<
          UpdateSalonRepository,
          UpdateSalonRepository,
          UpdateSalonRepository
        >
    with $Provider<UpdateSalonRepository> {
  SalonUpdateProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'salonUpdateProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$salonUpdateHash();

  @$internal
  @override
  $ProviderElement<UpdateSalonRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  UpdateSalonRepository create(Ref ref) {
    return salonUpdate(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(UpdateSalonRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<UpdateSalonRepository>(value),
    );
  }
}

String _$salonUpdateHash() => r'c145ab978b8dc7348a3abe4ce8606128c0afb8cf';
