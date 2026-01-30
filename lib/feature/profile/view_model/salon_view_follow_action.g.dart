// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'salon_view_follow_action.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(SalonFollowActionViewModel)
final salonFollowActionViewModelProvider =
    SalonFollowActionViewModelProvider._();

final class SalonFollowActionViewModelProvider
    extends $NotifierProvider<SalonFollowActionViewModel, bool> {
  SalonFollowActionViewModelProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'salonFollowActionViewModelProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$salonFollowActionViewModelHash();

  @$internal
  @override
  SalonFollowActionViewModel create() => SalonFollowActionViewModel();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(bool value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<bool>(value),
    );
  }
}

String _$salonFollowActionViewModelHash() =>
    r'4aed42e7cabd693ed33193e6c1cd6112b45a610c';

abstract class _$SalonFollowActionViewModel extends $Notifier<bool> {
  bool build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<bool, bool>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<bool, bool>,
              bool,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
