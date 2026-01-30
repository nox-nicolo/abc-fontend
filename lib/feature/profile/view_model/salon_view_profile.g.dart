// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'salon_view_profile.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(SalonViewProfileViewModel)
final salonViewProfileViewModelProvider = SalonViewProfileViewModelFamily._();

final class SalonViewProfileViewModelProvider
    extends
        $AsyncNotifierProvider<
          SalonViewProfileViewModel,
          SalonViewProfileModel
        > {
  SalonViewProfileViewModelProvider._({
    required SalonViewProfileViewModelFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'salonViewProfileViewModelProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$salonViewProfileViewModelHash();

  @override
  String toString() {
    return r'salonViewProfileViewModelProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  SalonViewProfileViewModel create() => SalonViewProfileViewModel();

  @override
  bool operator ==(Object other) {
    return other is SalonViewProfileViewModelProvider &&
        other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$salonViewProfileViewModelHash() =>
    r'7b1015dcae5070a8db652e062f6bc8c20d20f8c8';

final class SalonViewProfileViewModelFamily extends $Family
    with
        $ClassFamilyOverride<
          SalonViewProfileViewModel,
          AsyncValue<SalonViewProfileModel>,
          SalonViewProfileModel,
          FutureOr<SalonViewProfileModel>,
          String
        > {
  SalonViewProfileViewModelFamily._()
    : super(
        retry: null,
        name: r'salonViewProfileViewModelProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  SalonViewProfileViewModelProvider call(String salonId) =>
      SalonViewProfileViewModelProvider._(argument: salonId, from: this);

  @override
  String toString() => r'salonViewProfileViewModelProvider';
}

abstract class _$SalonViewProfileViewModel
    extends $AsyncNotifier<SalonViewProfileModel> {
  late final _$args = ref.$arg as String;
  String get salonId => _$args;

  FutureOr<SalonViewProfileModel> build(String salonId);
  @$mustCallSuper
  @override
  void runBuild() {
    final ref =
        this.ref
            as $Ref<AsyncValue<SalonViewProfileModel>, SalonViewProfileModel>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<
                AsyncValue<SalonViewProfileModel>,
                SalonViewProfileModel
              >,
              AsyncValue<SalonViewProfileModel>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, () => build(_$args));
  }
}
