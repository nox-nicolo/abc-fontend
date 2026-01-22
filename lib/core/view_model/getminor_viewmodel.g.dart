// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'getminor_viewmodel.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(GetMinorServiceViewModel)
final getMinorServiceViewModelProvider = GetMinorServiceViewModelProvider._();

final class GetMinorServiceViewModelProvider
    extends
        $NotifierProvider<
          GetMinorServiceViewModel,
          AsyncValue<List<PostMinorCategoriesModel>>
        > {
  GetMinorServiceViewModelProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'getMinorServiceViewModelProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$getMinorServiceViewModelHash();

  @$internal
  @override
  GetMinorServiceViewModel create() => GetMinorServiceViewModel();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AsyncValue<List<PostMinorCategoriesModel>> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride:
          $SyncValueProvider<AsyncValue<List<PostMinorCategoriesModel>>>(value),
    );
  }
}

String _$getMinorServiceViewModelHash() =>
    r'58e64ec5ce4a1f89b7512c5562c7fa3e5392e4c9';

abstract class _$GetMinorServiceViewModel
    extends $Notifier<AsyncValue<List<PostMinorCategoriesModel>>> {
  AsyncValue<List<PostMinorCategoriesModel>> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref =
        this.ref
            as $Ref<
              AsyncValue<List<PostMinorCategoriesModel>>,
              AsyncValue<List<PostMinorCategoriesModel>>
            >;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<
                AsyncValue<List<PostMinorCategoriesModel>>,
                AsyncValue<List<PostMinorCategoriesModel>>
              >,
              AsyncValue<List<PostMinorCategoriesModel>>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
