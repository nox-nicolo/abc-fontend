// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'signin_viewmodel.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(SigninViewModel)
final signinViewModelProvider = SigninViewModelProvider._();

final class SigninViewModelProvider
    extends $NotifierProvider<SigninViewModel, AsyncValue<SigninModel>?> {
  SigninViewModelProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'signinViewModelProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$signinViewModelHash();

  @$internal
  @override
  SigninViewModel create() => SigninViewModel();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AsyncValue<SigninModel>? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AsyncValue<SigninModel>?>(value),
    );
  }
}

String _$signinViewModelHash() => r'a33c60fbaf2d5940024e79a9754fac205836b3ba';

abstract class _$SigninViewModel extends $Notifier<AsyncValue<SigninModel>?> {
  AsyncValue<SigninModel>? build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref =
        this.ref as $Ref<AsyncValue<SigninModel>?, AsyncValue<SigninModel>?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<SigninModel>?, AsyncValue<SigninModel>?>,
              AsyncValue<SigninModel>?,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
