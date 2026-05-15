import 'package:africa_beuty/feature/home/model/categories.dart';
import 'package:africa_beuty/feature/home/provider/home.dart';
import 'package:africa_beuty/feature/home/repository/home.dart';
import 'package:fpdart/fpdart.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'category.g.dart';

@riverpod
class HomeCategoriesViewModel extends _$HomeCategoriesViewModel {
  late final HomeRepository _repository;
  int _requestId = 0;

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
    final requestId = ++_requestId;
    final res = await _repository.getCategories();

    if (!ref.mounted || requestId != _requestId) return;

    state = switch (res) {
      Left(value: final failure) =>
        state.hasValue
            ? state
            : AsyncError(failure.message, StackTrace.current),

      Right(value: final categories) => AsyncData(categories),
    };
  }

  // ----------------------------------------------------------
  // REFRESH
  // ----------------------------------------------------------
  Future<void> refresh() async {
    if (!state.hasValue) {
      state = const AsyncLoading();
    }
    await _load();
  }
}
