
import 'package:africa_beuty/feature/profile/model/three_dots/stylists/edit_stylist.dart';
import 'package:africa_beuty/feature/profile/model/three_dots/stylists/view_single_stylists.dart';
import 'package:africa_beuty/feature/profile/providers/stylist/stylists.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'edit_stylist.g.dart';

@Riverpod(keepAlive: true)
class EditStylistViewModel extends _$EditStylistViewModel {
  @override
  AsyncValue<SalonStylistDetail?> build() {
    return const AsyncValue.data(null);
  }

  Future<SalonStylistDetail> editStylist({
    required String stylistId,
    required EditSalonStylistRequest request,
  }) async {
    state = const AsyncValue.loading();

    final repository = ref.read(salonStylistRepositoryProvider);
    final result = await repository.editStylist(
      stylistId: stylistId,
      request: request,
    );

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