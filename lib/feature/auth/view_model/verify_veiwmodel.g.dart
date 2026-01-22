// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'verify_veiwmodel.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(VerifyVeiwModel)
final verifyVeiwModelProvider = VerifyVeiwModelProvider._();

final class VerifyVeiwModelProvider
    extends $NotifierProvider<VerifyVeiwModel, AsyncValue<VerificationModel>?> {
  VerifyVeiwModelProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'verifyVeiwModelProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$verifyVeiwModelHash();

  @$internal
  @override
  VerifyVeiwModel create() => VerifyVeiwModel();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AsyncValue<VerificationModel>? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AsyncValue<VerificationModel>?>(
        value,
      ),
    );
  }
}

String _$verifyVeiwModelHash() => r'9b8fe92cb7c634003d7d0575cabca7b918c22ab9';

abstract class _$VerifyVeiwModel
    extends $Notifier<AsyncValue<VerificationModel>?> {
  AsyncValue<VerificationModel>? build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref =
        this.ref
            as $Ref<
              AsyncValue<VerificationModel>?,
              AsyncValue<VerificationModel>?
            >;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<
                AsyncValue<VerificationModel>?,
                AsyncValue<VerificationModel>?
              >,
              AsyncValue<VerificationModel>?,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
