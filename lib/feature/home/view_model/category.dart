import 'package:africa_beuty/feature/home/model/categories.dart';
import 'package:africa_beuty/feature/home/provider/home.dart';
import 'package:africa_beuty/feature/home/repository/home.dart';
import 'package:fpdart/fpdart.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'category.g.dart';

@riverpod
class HomeCategoriesViewModel extends _$HomeCategoriesViewModel {
  late final HomeRepository _repository;

  @override
  AsyncValue<List<SelectedServiceModel>> build() {
    _repository = ref.read(homeRepositoryImplProvider);
    _load();
    return const AsyncLoading();
  }

  // ----------------------------------------------------------
  // LOAD SELECTED CATEGORIES
  // ----------------------------------------------------------
  Future<void> _load() async {
    final res = await _repository.getCategories();

    state = switch (res) {
      Left(value: final failure) =>
        AsyncError(failure.message, StackTrace.current),

      Right(value: final categories) =>
        AsyncData(categories),
    };
  }

  // ----------------------------------------------------------
  // REFRESH
  // ----------------------------------------------------------
  Future<void> refresh() async {
    state = const AsyncLoading();
    await _load();
  }
}
