// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'booking_action.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(BookingActionViewModel)
final bookingActionViewModelProvider = BookingActionViewModelProvider._();

final class BookingActionViewModelProvider
    extends $NotifierProvider<BookingActionViewModel, AsyncValue<void>> {
  BookingActionViewModelProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'bookingActionViewModelProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$bookingActionViewModelHash();

  @$internal
  @override
  BookingActionViewModel create() => BookingActionViewModel();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AsyncValue<void> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AsyncValue<void>>(value),
    );
  }
}

String _$bookingActionViewModelHash() =>
    r'7f7dd86408639a955eca57255dc174b8f907223f';

abstract class _$BookingActionViewModel extends $Notifier<AsyncValue<void>> {
  AsyncValue<void> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AsyncValue<void>, AsyncValue<void>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<void>, AsyncValue<void>>,
              AsyncValue<void>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
