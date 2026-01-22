// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'selected_category.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(SelectedCategory)
final selectedCategoryProvider = SelectedCategoryProvider._();

final class SelectedCategoryProvider
    extends $NotifierProvider<SelectedCategory, PostMinorCategoriesModel?> {
  SelectedCategoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'selectedCategoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$selectedCategoryHash();

  @$internal
  @override
  SelectedCategory create() => SelectedCategory();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(PostMinorCategoriesModel? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<PostMinorCategoriesModel?>(value),
    );
  }
}

String _$selectedCategoryHash() => r'630ee74ba38f423ee7db6406ffd632dcc2620d4e';

abstract class _$SelectedCategory extends $Notifier<PostMinorCategoriesModel?> {
  PostMinorCategoriesModel? build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref =
        this.ref as $Ref<PostMinorCategoriesModel?, PostMinorCategoriesModel?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<PostMinorCategoriesModel?, PostMinorCategoriesModel?>,
              PostMinorCategoriesModel?,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
