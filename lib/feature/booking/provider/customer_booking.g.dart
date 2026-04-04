// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'customer_booking.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(customerBookingRepository)
final customerBookingRepositoryProvider = CustomerBookingRepositoryProvider._();

final class CustomerBookingRepositoryProvider
    extends
        $FunctionalProvider<
          CustomerBookingRepository,
          CustomerBookingRepository,
          CustomerBookingRepository
        >
    with $Provider<CustomerBookingRepository> {
  CustomerBookingRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'customerBookingRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$customerBookingRepositoryHash();

  @$internal
  @override
  $ProviderElement<CustomerBookingRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  CustomerBookingRepository create(Ref ref) {
    return customerBookingRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(CustomerBookingRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<CustomerBookingRepository>(value),
    );
  }
}

String _$customerBookingRepositoryHash() =>
    r'792ba31e10f6ea0d36a72c11cef23975304f13a7';
