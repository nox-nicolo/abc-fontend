import 'package:africa_beuty/feature/profile/model/config_service_salon.dart';
import 'package:africa_beuty/feature/profile/providers/salon_configure_services.dart';
import 'package:africa_beuty/feature/profile/repositories/salon_configure_services.dart';
import 'package:fpdart/fpdart.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'config_service_salon.g.dart';

@riverpod
class SalonServiceConfigDetailViewModel
    extends _$SalonServiceConfigDetailViewModel {
  late final SalonServiceRepository _repository;

  @override
  AsyncValue<SalonServiceConfigModel> build({
    required String serviceId,
    required String subServiceId,
  }) {
    _repository = ref.read(salonServiceRepositoryProvider);

    _load(
      serviceId: serviceId,
      subServiceId: subServiceId,
    );

    return const AsyncLoading();
  }

  // ----------------------------------------------------------
  // LOAD CONFIG (CREATE / UPDATE)
  // ----------------------------------------------------------
  Future<void> _load({
    required String serviceId,
    required String subServiceId,
  }) async {
    final res = await _repository.getServiceConfig(
      serviceId: serviceId,
      subServiceId: subServiceId,
    );

    state = switch (res) {
      Left(value: final failure) =>
          AsyncError(failure.message, StackTrace.current),

      Right(value: final config) =>
          AsyncData(config),
    };
  }

  // ----------------------------------------------------------
  // REFRESH
  // ----------------------------------------------------------
  Future<void> refresh({
    required String serviceId,
    required String subServiceId,
  }) async {
    state = const AsyncLoading();
    await _load(
      serviceId: serviceId,
      subServiceId: subServiceId,
    );
  }
}
