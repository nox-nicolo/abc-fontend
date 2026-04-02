import 'package:africa_beuty/feature/profile/model/three_dots/stylists/search_stylists.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../providers/stylist/stylists.dart';

part 'search_stylists.g.dart';

@Riverpod(keepAlive: true)
class StylistSearchViewModel extends _$StylistSearchViewModel {
  @override
  AsyncValue<StylistSearchResponse> build() {
    return const AsyncValue.data(
      StylistSearchResponse(
        items: [],
        query: '',
        count: 0,
      ),
    );
  }

  Future<StylistSearchResponse> searchStylists(String query) async {
    final trimmed = query.trim();

    if (trimmed.isEmpty) {
      const empty = StylistSearchResponse(
        items: [],
        query: '',
        count: 0,
      );
      state = const AsyncValue.data(empty);
      return empty;
    }

    final repository = ref.read(salonStylistRepositoryProvider);
    final result = await repository.searchStylists(query: trimmed);

    return result.fold(
      (failure) {
        if (ref.mounted) {
          state = AsyncValue.error(failure.message, StackTrace.current);
        }
        throw failure.message;
      },
      (response) {
        if (ref.mounted) {
          state = AsyncValue.data(response);
        }
        return response;
      },
    );
  }

  void clearSearch() {
    state = const AsyncValue.data(
      StylistSearchResponse(
        items: [],
        query: '',
        count: 0,
      ),
    );
  }
}