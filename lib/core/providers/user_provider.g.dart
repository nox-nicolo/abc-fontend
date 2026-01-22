// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(CurrentUser)
final currentUserProvider = CurrentUserProvider._();

final class CurrentUserProvider
    extends $NotifierProvider<CurrentUser, MeModel?> {
  CurrentUserProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'currentUserProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$currentUserHash();

  @$internal
  @override
  CurrentUser create() => CurrentUser();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(MeModel? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<MeModel?>(value),
    );
  }
}

String _$currentUserHash() => r'5436d451adff480efd0043a675f8a78963178a2b';

abstract class _$CurrentUser extends $Notifier<MeModel?> {
  MeModel? build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<MeModel?, MeModel?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<MeModel?, MeModel?>,
              MeModel?,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
