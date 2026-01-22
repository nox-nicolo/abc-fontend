// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'booking_status.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(BookingListViewModel)
final bookingListViewModelProvider = BookingListViewModelFamily._();

final class BookingListViewModelProvider
    extends
        $NotifierProvider<
          BookingListViewModel,
          AsyncValue<List<BookingListItem>>
        > {
  BookingListViewModelProvider._({
    required BookingListViewModelFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'bookingListViewModelProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$bookingListViewModelHash();

  @override
  String toString() {
    return r'bookingListViewModelProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  BookingListViewModel create() => BookingListViewModel();

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
    return other is BookingListViewModelProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$bookingListViewModelHash() =>
    r'ba894f9a3dfbd8f9815a8eb43196bff0ce693dbc';

final class BookingListViewModelFamily extends $Family
    with
        $ClassFamilyOverride<
          BookingListViewModel,
          AsyncValue<List<BookingListItem>>,
          AsyncValue<List<BookingListItem>>,
          AsyncValue<List<BookingListItem>>,
          String
        > {
  BookingListViewModelFamily._()
    : super(
        retry: null,
        name: r'bookingListViewModelProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  BookingListViewModelProvider call(String status) =>
      BookingListViewModelProvider._(argument: status, from: this);

  @override
  String toString() => r'bookingListViewModelProvider';
}

abstract class _$BookingListViewModel
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
