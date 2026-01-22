// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'singup_viewmodel.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(SignupViewModel)
final signupViewModelProvider = SignupViewModelProvider._();

final class SignupViewModelProvider
    extends $NotifierProvider<SignupViewModel, AsyncValue<SignupModel>?> {
  SignupViewModelProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'signupViewModelProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$signupViewModelHash();

  @$internal
  @override
  SignupViewModel create() => SignupViewModel();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AsyncValue<SignupModel>? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AsyncValue<SignupModel>?>(value),
    );
  }
}

String _$signupViewModelHash() => r'0d9545cbaecba521f04f138174faef5cd24a4f13';

abstract class _$SignupViewModel extends $Notifier<AsyncValue<SignupModel>?> {
  AsyncValue<SignupModel>? build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref =
        this.ref as $Ref<AsyncValue<SignupModel>?, AsyncValue<SignupModel>?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<SignupModel>?, AsyncValue<SignupModel>?>,
              AsyncValue<SignupModel>?,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
