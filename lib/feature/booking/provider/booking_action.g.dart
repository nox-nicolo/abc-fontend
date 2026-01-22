// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'booking_action.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(bookingActionRepository)
final bookingActionRepositoryProvider = BookingActionRepositoryProvider._();

final class BookingActionRepositoryProvider
    extends
        $FunctionalProvider<
          BookingActionRepository,
          BookingActionRepository,
          BookingActionRepository
        >
    with $Provider<BookingActionRepository> {
  BookingActionRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'bookingActionRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$bookingActionRepositoryHash();

  @$internal
  @override
  $ProviderElement<BookingActionRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  BookingActionRepository create(Ref ref) {
    return bookingActionRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(BookingActionRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<BookingActionRepository>(value),
    );
  }
}

String _$bookingActionRepositoryHash() =>
    r'31942bb3e6d2506b6d4a42fe88d083cee33f8889';
