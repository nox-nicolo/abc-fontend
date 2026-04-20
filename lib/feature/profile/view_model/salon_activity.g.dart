// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'salon_activity.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(SalonActivityViewModel)
final salonActivityViewModelProvider = SalonActivityViewModelFamily._();

final class SalonActivityViewModelProvider
    extends
        $NotifierProvider<
          SalonActivityViewModel,
          AsyncValue<List<ActivityItem>>
        > {
  SalonActivityViewModelProvider._({
    required SalonActivityViewModelFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'salonActivityViewModelProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$salonActivityViewModelHash();

  @override
  String toString() {
    return r'salonActivityViewModelProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  SalonActivityViewModel create() => SalonActivityViewModel();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AsyncValue<List<ActivityItem>> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AsyncValue<List<ActivityItem>>>(
        value,
      ),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is SalonActivityViewModelProvider &&
        other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$salonActivityViewModelHash() =>
    r'523e87a1d55ebb20e9006c2af4d355f2bab1570a';

final class SalonActivityViewModelFamily extends $Family
    with
        $ClassFamilyOverride<
          SalonActivityViewModel,
          AsyncValue<List<ActivityItem>>,
          AsyncValue<List<ActivityItem>>,
          AsyncValue<List<ActivityItem>>,
          String
        > {
  SalonActivityViewModelFamily._()
    : super(
        retry: null,
        name: r'salonActivityViewModelProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  SalonActivityViewModelProvider call(String salonId) =>
      SalonActivityViewModelProvider._(argument: salonId, from: this);

  @override
  String toString() => r'salonActivityViewModelProvider';
}

abstract class _$SalonActivityViewModel
    extends $Notifier<AsyncValue<List<ActivityItem>>> {
  late final _$args = ref.$arg as String;
  String get salonId => _$args;

  AsyncValue<List<ActivityItem>> build(String salonId);
  @$mustCallSuper
  @override
  void runBuild() {
    final ref =
        this.ref
            as $Ref<
              AsyncValue<List<ActivityItem>>,
              AsyncValue<List<ActivityItem>>
            >;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<
                AsyncValue<List<ActivityItem>>,
                AsyncValue<List<ActivityItem>>
              >,
              AsyncValue<List<ActivityItem>>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, () => build(_$args));
  }
}
