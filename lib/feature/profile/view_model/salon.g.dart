// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'salon.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(SalonProfileViewModel)
final salonProfileViewModelProvider = SalonProfileViewModelProvider._();

final class SalonProfileViewModelProvider
    extends
        $NotifierProvider<
          SalonProfileViewModel,
          AsyncValue<SalonProfileModel>
        > {
  SalonProfileViewModelProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'salonProfileViewModelProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$salonProfileViewModelHash();

  @$internal
  @override
  SalonProfileViewModel create() => SalonProfileViewModel();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AsyncValue<SalonProfileModel> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AsyncValue<SalonProfileModel>>(
        value,
      ),
    );
  }
}

String _$salonProfileViewModelHash() =>
    r'782363a35e0ed6135a4caa26b9b2e4efe086e958';

abstract class _$SalonProfileViewModel
    extends $Notifier<AsyncValue<SalonProfileModel>> {
  AsyncValue<SalonProfileModel> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref =
        this.ref
            as $Ref<
              AsyncValue<SalonProfileModel>,
              AsyncValue<SalonProfileModel>
            >;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<
                AsyncValue<SalonProfileModel>,
                AsyncValue<SalonProfileModel>
              >,
              AsyncValue<SalonProfileModel>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
