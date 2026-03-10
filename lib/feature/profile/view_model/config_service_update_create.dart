
import 'package:africa_beuty/feature/profile/model/config_service_update_create.dart';
import 'package:africa_beuty/feature/profile/providers/salon_configure_services.dart';
import 'package:africa_beuty/feature/profile/repositories/salon_configure_services.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'config_service_update_create.g.dart';

@riverpod
class ConfigServiceUpdateCreateViewModel extends _$ConfigServiceUpdateCreateViewModel {
  late final SalonServiceRepository _repository;

  @override
  AsyncValue<void> build() {
    _repository = ref.read(salonServiceRepositoryProvider);
    return const AsyncData(null);
  }

  // ----------------------------------------------------------
  // CREATE or UPDATE service configuration
  // ----------------------------------------------------------
  Future<void> save({
    required bool isConfigured,
    required String? salonServicePriceId, // required for update
    required SalonServiceConfigRequestModel payload,
  }) async {
    state = const AsyncLoading();

    final result = isConfigured
        ? await _repository.updateServiceConfig(
            salonServicePriceId: salonServicePriceId!,
            payload: payload,
          )
        : await _repository.createServiceConfig(
            payload: payload,
          );

    state = result.fold(
      (failure) =>
          AsyncError(failure.message, StackTrace.current),
      (_) => const AsyncData(null),
    );
  }
}
