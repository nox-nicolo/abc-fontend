// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'view_single_stylist.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(SalonStylistDetailViewModel)
final salonStylistDetailViewModelProvider =
    SalonStylistDetailViewModelFamily._();

final class SalonStylistDetailViewModelProvider
    extends
        $NotifierProvider<
          SalonStylistDetailViewModel,
          AsyncValue<SalonStylistDetail>
        > {
  SalonStylistDetailViewModelProvider._({
    required SalonStylistDetailViewModelFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'salonStylistDetailViewModelProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$salonStylistDetailViewModelHash();

  @override
  String toString() {
    return r'salonStylistDetailViewModelProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  SalonStylistDetailViewModel create() => SalonStylistDetailViewModel();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AsyncValue<SalonStylistDetail> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AsyncValue<SalonStylistDetail>>(
        value,
      ),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is SalonStylistDetailViewModelProvider &&
        other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$salonStylistDetailViewModelHash() =>
    r'dcff1a6e45c08ddc452332d46f9b299c83b4e298';

final class SalonStylistDetailViewModelFamily extends $Family
    with
        $ClassFamilyOverride<
          SalonStylistDetailViewModel,
          AsyncValue<SalonStylistDetail>,
          AsyncValue<SalonStylistDetail>,
          AsyncValue<SalonStylistDetail>,
          String
        > {
  SalonStylistDetailViewModelFamily._()
    : super(
        retry: null,
        name: r'salonStylistDetailViewModelProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  SalonStylistDetailViewModelProvider call(String stylistId) =>
      SalonStylistDetailViewModelProvider._(argument: stylistId, from: this);

  @override
  String toString() => r'salonStylistDetailViewModelProvider';
}

abstract class _$SalonStylistDetailViewModel
    extends $Notifier<AsyncValue<SalonStylistDetail>> {
  late final _$args = ref.$arg as String;
  String get stylistId => _$args;

  AsyncValue<SalonStylistDetail> build(String stylistId);
  @$mustCallSuper
  @override
  void runBuild() {
    final ref =
        this.ref
            as $Ref<
              AsyncValue<SalonStylistDetail>,
              AsyncValue<SalonStylistDetail>
            >;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<
                AsyncValue<SalonStylistDetail>,
                AsyncValue<SalonStylistDetail>
              >,
              AsyncValue<SalonStylistDetail>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, () => build(_$args));
  }
}
