import 'package:africa_beuty/feature/profile/model/three_dots/stylists/create_stylist.dart';
import 'package:africa_beuty/feature/profile/providers/stylist/stylists.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'create_stylists.g.dart';

@Riverpod(keepAlive: true)
class CreateStylistViewModel extends _$CreateStylistViewModel {
  @override
  AsyncValue<CreateSalonStylistResponse?> build() {
    return const AsyncValue.data(null);
  }

  Future<CreateSalonStylistResponse> createStylist({
    required CreateSalonStylistRequest request,
  }) async {
    state = const AsyncValue.loading();

    final repository = ref.read(salonStylistRepositoryProvider);
    final result = await repository.createStylist(request: request);

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

  void reset() {
    state = const AsyncValue.data(null);
  }
}