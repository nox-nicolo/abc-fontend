
import 'package:africa_beuty/feature/profile/model/three_dots/services/service.dart';
import 'package:africa_beuty/feature/profile/providers/service/services.dart';
import 'package:africa_beuty/feature/profile/repositories/three_dots/services/service.dart';
import 'package:fpdart/fpdart.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'service.g.dart';

@riverpod
class SalonServicesViewModel extends _$SalonServicesViewModel {
  late final SalonServiceRepository _repository;

  String _query = "";

  @override
  AsyncValue<List<SalonServiceItemModel>> build() {
    _repository = ref.read(salonServiceRepositoryProvider);

    // initial load (empty search)
    _load();

    return const AsyncLoading();
  }

  // ----------------------------------------------------------
  // CORE LOAD (query-driven)
  // ----------------------------------------------------------
  Future<void> _load({
    int limit = 100,
    int offset = 0,
    bool includeArchived = false,
  }) async {
    final res = await _repository.listServicesForSelection(
      query: _query.isEmpty ? null : _query,
      limit: limit,
      offset: offset,
      includeArchived: includeArchived,
    );

    state = switch (res) {
      Left(value: final failure) =>
          AsyncError(failure.message, StackTrace.current),

      Right(value: final services) =>
          AsyncData(services),
    };
  }

  // ----------------------------------------------------------
  // SEARCH (NOT OPTIONAL)
  // ----------------------------------------------------------
  Future<void> search(String query) async {
    _query = query.trim();
    await _load();
  }

  // ----------------------------------------------------------
  // CLEAR SEARCH
  // ----------------------------------------------------------
  Future<void> clearSearch() async {
    _query = "";
    await _load();
  }

  // ----------------------------------------------------------
  // REFRESH (keeps current query)
  // ----------------------------------------------------------
  Future<void> refresh() async {
    state = const AsyncLoading();
    await _load();
  }
}
