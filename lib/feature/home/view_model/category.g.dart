// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'category.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(HomeCategoriesViewModel)
final homeCategoriesViewModelProvider = HomeCategoriesViewModelProvider._();

final class HomeCategoriesViewModelProvider
    extends
        $NotifierProvider<
          HomeCategoriesViewModel,
          AsyncValue<List<SelectedServiceModel>>
        > {
  HomeCategoriesViewModelProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'homeCategoriesViewModelProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$homeCategoriesViewModelHash();

  @$internal
  @override
  HomeCategoriesViewModel create() => HomeCategoriesViewModel();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AsyncValue<List<SelectedServiceModel>> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride:
          $SyncValueProvider<AsyncValue<List<SelectedServiceModel>>>(value),
    );
  }
}

String _$homeCategoriesViewModelHash() =>
    r'6cd96a719aeeed8707e209cad2f8f4d533f44c0c';

abstract class _$HomeCategoriesViewModel
    extends $Notifier<AsyncValue<List<SelectedServiceModel>>> {
  AsyncValue<List<SelectedServiceModel>> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref =
        this.ref
            as $Ref<
              AsyncValue<List<SelectedServiceModel>>,
              AsyncValue<List<SelectedServiceModel>>
            >;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<
                AsyncValue<List<SelectedServiceModel>>,
                AsyncValue<List<SelectedServiceModel>>
              >,
              AsyncValue<List<SelectedServiceModel>>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
