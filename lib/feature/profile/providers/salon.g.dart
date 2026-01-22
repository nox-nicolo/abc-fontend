// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'salon.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(salonProfile)
final salonProfileProvider = SalonProfileProvider._();

final class SalonProfileProvider
    extends
        $FunctionalProvider<
          SalonProfileRepository,
          SalonProfileRepository,
          SalonProfileRepository
        >
    with $Provider<SalonProfileRepository> {
  SalonProfileProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'salonProfileProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$salonProfileHash();

  @$internal
  @override
  $ProviderElement<SalonProfileRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  SalonProfileRepository create(Ref ref) {
    return salonProfile(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SalonProfileRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<SalonProfileRepository>(value),
    );
  }
}

String _$salonProfileHash() => r'49efb521e76c480ffcc8f63061419c13e6b14763';
