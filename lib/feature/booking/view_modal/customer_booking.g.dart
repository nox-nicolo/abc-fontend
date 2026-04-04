// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'customer_booking.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(MyBookingsViewModel)
final myBookingsViewModelProvider = MyBookingsViewModelFamily._();

final class MyBookingsViewModelProvider
    extends
        $NotifierProvider<
          MyBookingsViewModel,
          AsyncValue<List<BookingListItem>>
        > {
  MyBookingsViewModelProvider._({
    required MyBookingsViewModelFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'myBookingsViewModelProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$myBookingsViewModelHash();

  @override
  String toString() {
    return r'myBookingsViewModelProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  MyBookingsViewModel create() => MyBookingsViewModel();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AsyncValue<List<BookingListItem>> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AsyncValue<List<BookingListItem>>>(
        value,
      ),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is MyBookingsViewModelProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$myBookingsViewModelHash() =>
    r'4184e3e3ff5718bf88059de15b9acf5662a030cb';

final class MyBookingsViewModelFamily extends $Family
    with
        $ClassFamilyOverride<
          MyBookingsViewModel,
          AsyncValue<List<BookingListItem>>,
          AsyncValue<List<BookingListItem>>,
          AsyncValue<List<BookingListItem>>,
          String
        > {
  MyBookingsViewModelFamily._()
    : super(
        retry: null,
        name: r'myBookingsViewModelProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  MyBookingsViewModelProvider call(String status) =>
      MyBookingsViewModelProvider._(argument: status, from: this);

  @override
  String toString() => r'myBookingsViewModelProvider';
}

abstract class _$MyBookingsViewModel
    extends $Notifier<AsyncValue<List<BookingListItem>>> {
  late final _$args = ref.$arg as String;
  String get status => _$args;

  AsyncValue<List<BookingListItem>> build(String status);
  @$mustCallSuper
  @override
  void runBuild() {
    final ref =
        this.ref
            as $Ref<
              AsyncValue<List<BookingListItem>>,
              AsyncValue<List<BookingListItem>>
            >;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<
                AsyncValue<List<BookingListItem>>,
                AsyncValue<List<BookingListItem>>
              >,
              AsyncValue<List<BookingListItem>>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, () => build(_$args));
  }
}

@ProviderFor(BookingDetailViewModel)
final bookingDetailViewModelProvider = BookingDetailViewModelFamily._();

final class BookingDetailViewModelProvider
    extends
        $NotifierProvider<BookingDetailViewModel, AsyncValue<BookingModel>> {
  BookingDetailViewModelProvider._({
    required BookingDetailViewModelFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'bookingDetailViewModelProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$bookingDetailViewModelHash();

  @override
  String toString() {
    return r'bookingDetailViewModelProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  BookingDetailViewModel create() => BookingDetailViewModel();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AsyncValue<BookingModel> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AsyncValue<BookingModel>>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is BookingDetailViewModelProvider &&
        other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$bookingDetailViewModelHash() =>
    r'fb3d4f603afceaf6aa1b3db7a85cd2ce9c01c1b0';

final class BookingDetailViewModelFamily extends $Family
    with
        $ClassFamilyOverride<
          BookingDetailViewModel,
          AsyncValue<BookingModel>,
          AsyncValue<BookingModel>,
          AsyncValue<BookingModel>,
          String
        > {
  BookingDetailViewModelFamily._()
    : super(
        retry: null,
        name: r'bookingDetailViewModelProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  BookingDetailViewModelProvider call(String bookingId) =>
      BookingDetailViewModelProvider._(argument: bookingId, from: this);

  @override
  String toString() => r'bookingDetailViewModelProvider';
}

abstract class _$BookingDetailViewModel
    extends $Notifier<AsyncValue<BookingModel>> {
  late final _$args = ref.$arg as String;
  String get bookingId => _$args;

  AsyncValue<BookingModel> build(String bookingId);
  @$mustCallSuper
  @override
  void runBuild() {
    final ref =
        this.ref as $Ref<AsyncValue<BookingModel>, AsyncValue<BookingModel>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<BookingModel>, AsyncValue<BookingModel>>,
              AsyncValue<BookingModel>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, () => build(_$args));
  }
}

@ProviderFor(CustomerBookingActionViewModel)
final customerBookingActionViewModelProvider =
    CustomerBookingActionViewModelProvider._();

final class CustomerBookingActionViewModelProvider
    extends
        $NotifierProvider<CustomerBookingActionViewModel, AsyncValue<void>> {
  CustomerBookingActionViewModelProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'customerBookingActionViewModelProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$customerBookingActionViewModelHash();

  @$internal
  @override
  CustomerBookingActionViewModel create() => CustomerBookingActionViewModel();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AsyncValue<void> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AsyncValue<void>>(value),
    );
  }
}

String _$customerBookingActionViewModelHash() =>
    r'fa9c9f0c7f974ceb7e30a0e82d8b0a0d01e97259';

abstract class _$CustomerBookingActionViewModel
    extends $Notifier<AsyncValue<void>> {
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
