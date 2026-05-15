import 'package:africa_beuty/feature/home/model/top_salon.dart';
import 'package:africa_beuty/feature/home/provider/home.dart';
import 'package:africa_beuty/feature/home/repository/home.dart';
import 'package:fpdart/fpdart.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'top_salon.g.dart';

@riverpod
class TopSalonViewModel extends _$TopSalonViewModel {
  late final HomeRepository _repository;
  int _requestId = 0;

  @override
  AsyncValue<List<TopSalonModel>> build() {
    _repository = ref.read(homeRepositoryImplProvider);
    _load();
    return const AsyncLoading();
  }

  // ----------------------------------------------------------
  // LOAD TOP SALONS
  // ----------------------------------------------------------
  Future<void> _load() async {
    final requestId = ++_requestId;
    final res = await _repository.getTopSalons();

    if (!ref.mounted || requestId != _requestId) return;

    state = switch (res) {
      Left(value: final failure) =>
        state.hasValue
            ? state
            : AsyncError(failure.message, StackTrace.current),

      Right(value: final salons) => AsyncData(salons),
    };
  }

  // ----------------------------------------------------------
  // REFRESH (optional)
  // ----------------------------------------------------------
  Future<void> refresh() async {
    if (!state.hasValue) {
      state = const AsyncLoading();
    }
    await _load();
  }
}
