// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'booking_draft.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(BookingDraftNotifier)
final bookingDraftProvider = BookingDraftNotifierProvider._();

final class BookingDraftNotifierProvider
    extends $NotifierProvider<BookingDraftNotifier, BookingDraft> {
  BookingDraftNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'bookingDraftProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$bookingDraftNotifierHash();

  @$internal
  @override
  BookingDraftNotifier create() => BookingDraftNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(BookingDraft value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<BookingDraft>(value),
    );
  }
}

String _$bookingDraftNotifierHash() =>
    r'00fcd87a47e2988b4a20b8e3c7323b32acf8f9a7';

abstract class _$BookingDraftNotifier extends $Notifier<BookingDraft> {
  BookingDraft build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<BookingDraft, BookingDraft>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<BookingDraft, BookingDraft>,
              BookingDraft,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
