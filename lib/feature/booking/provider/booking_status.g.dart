// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'booking_status.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(bookingListRepository)
final bookingListRepositoryProvider = BookingListRepositoryProvider._();

final class BookingListRepositoryProvider
    extends
        $FunctionalProvider<
          BookingListRepository,
          BookingListRepository,
          BookingListRepository
        >
    with $Provider<BookingListRepository> {
  BookingListRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'bookingListRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$bookingListRepositoryHash();

  @$internal
  @override
  $ProviderElement<BookingListRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  BookingListRepository create(Ref ref) {
    return bookingListRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(BookingListRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<BookingListRepository>(value),
    );
  }
}

String _$bookingListRepositoryHash() =>
    r'ba018d923547dd38416cd4c173a3f5f01a24b306';
