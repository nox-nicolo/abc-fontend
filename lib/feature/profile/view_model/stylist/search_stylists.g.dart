// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'search_stylists.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(StylistSearchViewModel)
final stylistSearchViewModelProvider = StylistSearchViewModelProvider._();

final class StylistSearchViewModelProvider
    extends
        $NotifierProvider<
          StylistSearchViewModel,
          AsyncValue<StylistSearchResponse>
        > {
  StylistSearchViewModelProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'stylistSearchViewModelProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$stylistSearchViewModelHash();

  @$internal
  @override
  StylistSearchViewModel create() => StylistSearchViewModel();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AsyncValue<StylistSearchResponse> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AsyncValue<StylistSearchResponse>>(
        value,
      ),
    );
  }
}

String _$stylistSearchViewModelHash() =>
    r'60409ea6e31aa0abb2f6ff1cbe66b67cd9025890';

abstract class _$StylistSearchViewModel
    extends $Notifier<AsyncValue<StylistSearchResponse>> {
  AsyncValue<StylistSearchResponse> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref =
        this.ref
            as $Ref<
              AsyncValue<StylistSearchResponse>,
              AsyncValue<StylistSearchResponse>
            >;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<
                AsyncValue<StylistSearchResponse>,
                AsyncValue<StylistSearchResponse>
              >,
              AsyncValue<StylistSearchResponse>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
