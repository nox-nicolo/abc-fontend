// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'code_renew.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(CodeRenewViewModel)
final codeRenewViewModelProvider = CodeRenewViewModelProvider._();

final class CodeRenewViewModelProvider
    extends
        $NotifierProvider<
          CodeRenewViewModel,
          AsyncValue<VerificationCodeModel>?
        > {
  CodeRenewViewModelProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'codeRenewViewModelProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$codeRenewViewModelHash();

  @$internal
  @override
  CodeRenewViewModel create() => CodeRenewViewModel();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AsyncValue<VerificationCodeModel>? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AsyncValue<VerificationCodeModel>?>(
        value,
      ),
    );
  }
}

String _$codeRenewViewModelHash() =>
    r'28ac321365dce722020cf4faf41c67527d5dda90';

abstract class _$CodeRenewViewModel
    extends $Notifier<AsyncValue<VerificationCodeModel>?> {
  AsyncValue<VerificationCodeModel>? build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref =
        this.ref
            as $Ref<
              AsyncValue<VerificationCodeModel>?,
              AsyncValue<VerificationCodeModel>?
            >;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<
                AsyncValue<VerificationCodeModel>?,
                AsyncValue<VerificationCodeModel>?
              >,
              AsyncValue<VerificationCodeModel>?,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
