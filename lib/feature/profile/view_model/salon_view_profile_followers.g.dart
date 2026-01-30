// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'salon_view_profile_followers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(SalonFollowersViewModel)
final salonFollowersViewModelProvider = SalonFollowersViewModelFamily._();

final class SalonFollowersViewModelProvider
    extends $NotifierProvider<SalonFollowersViewModel, SalonFollowersState> {
  SalonFollowersViewModelProvider._({
    required SalonFollowersViewModelFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'salonFollowersViewModelProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$salonFollowersViewModelHash();

  @override
  String toString() {
    return r'salonFollowersViewModelProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  SalonFollowersViewModel create() => SalonFollowersViewModel();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SalonFollowersState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<SalonFollowersState>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is SalonFollowersViewModelProvider &&
        other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$salonFollowersViewModelHash() =>
    r'23377f21f5c7e58eea7b133efb2b55d0d03aa221';

final class SalonFollowersViewModelFamily extends $Family
    with
        $ClassFamilyOverride<
          SalonFollowersViewModel,
          SalonFollowersState,
          SalonFollowersState,
          SalonFollowersState,
          String
        > {
  SalonFollowersViewModelFamily._()
    : super(
        retry: null,
        name: r'salonFollowersViewModelProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  SalonFollowersViewModelProvider call(String salonId) =>
      SalonFollowersViewModelProvider._(argument: salonId, from: this);

  @override
  String toString() => r'salonFollowersViewModelProvider';
}

abstract class _$SalonFollowersViewModel
    extends $Notifier<SalonFollowersState> {
  late final _$args = ref.$arg as String;
  String get salonId => _$args;

  SalonFollowersState build(String salonId);
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<SalonFollowersState, SalonFollowersState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<SalonFollowersState, SalonFollowersState>,
              SalonFollowersState,
              Object?,
              Object?
            >;
    element.handleCreate(ref, () => build(_$args));
  }
}
