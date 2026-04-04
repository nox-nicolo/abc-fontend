// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'customer_profile.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(customerProfileRepository)
final customerProfileRepositoryProvider = CustomerProfileRepositoryProvider._();

final class CustomerProfileRepositoryProvider
    extends
        $FunctionalProvider<
          CustomerProfileRepository,
          CustomerProfileRepository,
          CustomerProfileRepository
        >
    with $Provider<CustomerProfileRepository> {
  CustomerProfileRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'customerProfileRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$customerProfileRepositoryHash();

  @$internal
  @override
  $ProviderElement<CustomerProfileRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  CustomerProfileRepository create(Ref ref) {
    return customerProfileRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(CustomerProfileRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<CustomerProfileRepository>(value),
    );
  }
}

String _$customerProfileRepositoryHash() =>
    r'0896def918f0139218bb64872d055d92e5141278';
