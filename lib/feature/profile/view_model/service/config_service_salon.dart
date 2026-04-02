import 'package:africa_beuty/feature/profile/model/three_dots/services/create.dart';
import 'package:africa_beuty/feature/profile/providers/service/services.dart';
import 'package:africa_beuty/feature/profile/repositories/three_dots/services/service.dart';
import 'package:fpdart/fpdart.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'config_service_salon.g.dart';

@riverpod
class SalonServiceConfigDetailViewModel
    extends _$SalonServiceConfigDetailViewModel {
  SalonServiceRepository get _repository =>
      ref.read(salonServiceRepositoryProvider);

  @override
  Future<SalonServiceConfigDetailResponseModel> build({
    required String serviceId,
    required String subServiceId,
  }) async {
    final res = await _repository.getServiceConfig(
      serviceId: serviceId,
      subServiceId: subServiceId,
    );

    return switch (res) {
      Left(value: final failure) => throw Exception(failure.message),
      Right(value: final config) => config,
    };
  }

  Future<void> refresh({
    required String serviceId,
    required String subServiceId,
  }) async {
    state = const AsyncLoading();

    state = await AsyncValue.guard(() async {
      final res = await _repository.getServiceConfig(
        serviceId: serviceId,
        subServiceId: subServiceId,
      );

      return switch (res) {
        Left(value: final failure) => throw Exception(failure.message),
        Right(value: final config) => config,
      };
    });
  }
}