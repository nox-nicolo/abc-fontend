import 'package:africa_beuty/feature/profile/model/three_dots/services/create.dart';
import 'package:africa_beuty/feature/profile/providers/service/services.dart';
import 'package:africa_beuty/feature/profile/repositories/three_dots/services/service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'create.g.dart';

@riverpod
class CreateService extends _$CreateService {
  late final SalonServiceRepository _repository;

  @override
  AsyncValue<String?> build() {
    _repository = ref.read(salonServiceRepositoryProvider);
    return const AsyncData(null);
  }

  Future<void> save({
    required bool isConfigured,
    required SalonServiceConfigRequestModel payload,
    String? salonServicePriceId,
  }) async {
    state = const AsyncLoading();

    if (isConfigured &&
        (salonServicePriceId == null || salonServicePriceId.isEmpty)) {
      state = AsyncError(
        'Missing salon service price id for update',
        StackTrace.current,
      );
      return;
    }

    final result = isConfigured
        ? await _repository.updateServiceConfig(
            salonServicePriceId: salonServicePriceId!,
            payload: payload,
          )
        : await _repository.createServiceConfig(
            payload: payload,
          );

    state = result.fold(
      (failure) => AsyncError(failure.message, StackTrace.current),
      (success) => AsyncData(success.message),
    );
  }

  void reset() {
    state = const AsyncData(null);
  }
}