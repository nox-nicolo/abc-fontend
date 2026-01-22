// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'start_booking.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(StartBookingViewModel)
final startBookingViewModelProvider = StartBookingViewModelProvider._();

final class StartBookingViewModelProvider
    extends
        $NotifierProvider<StartBookingViewModel, AsyncValue<BookingModel?>> {
  StartBookingViewModelProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'startBookingViewModelProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$startBookingViewModelHash();

  @$internal
  @override
  StartBookingViewModel create() => StartBookingViewModel();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AsyncValue<BookingModel?> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AsyncValue<BookingModel?>>(value),
    );
  }
}

String _$startBookingViewModelHash() =>
    r'262cee3771af255a109ba2790e5527ac0f6079fd';

abstract class _$StartBookingViewModel
    extends $Notifier<AsyncValue<BookingModel?>> {
  AsyncValue<BookingModel?> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref =
        this.ref as $Ref<AsyncValue<BookingModel?>, AsyncValue<BookingModel?>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<BookingModel?>, AsyncValue<BookingModel?>>,
              AsyncValue<BookingModel?>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
