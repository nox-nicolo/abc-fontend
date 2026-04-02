// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'top_salon.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(TopSalonViewModel)
final topSalonViewModelProvider = TopSalonViewModelProvider._();

final class TopSalonViewModelProvider
    extends
        $NotifierProvider<TopSalonViewModel, AsyncValue<List<TopSalonModel>>> {
  TopSalonViewModelProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'topSalonViewModelProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$topSalonViewModelHash();

  @$internal
  @override
  TopSalonViewModel create() => TopSalonViewModel();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AsyncValue<List<TopSalonModel>> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AsyncValue<List<TopSalonModel>>>(
        value,
      ),
    );
  }
}

String _$topSalonViewModelHash() => r'98ed47adc3ddba08a72e4ef9d845e7e5d1d7770f';

abstract class _$TopSalonViewModel
    extends $Notifier<AsyncValue<List<TopSalonModel>>> {
  AsyncValue<List<TopSalonModel>> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref =
        this.ref
            as $Ref<
              AsyncValue<List<TopSalonModel>>,
              AsyncValue<List<TopSalonModel>>
            >;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<
                AsyncValue<List<TopSalonModel>>,
                AsyncValue<List<TopSalonModel>>
              >,
              AsyncValue<List<TopSalonModel>>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
