
import 'package:africa_beuty/feature/profile/model/three_dots/services/stylist.dart';
import 'package:africa_beuty/feature/profile/providers/service/services.dart';
import 'package:africa_beuty/feature/profile/repositories/three_dots/services/service.dart';
import 'package:fpdart/fpdart.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'stylist.g.dart';

@riverpod
class SalonStylists extends _$SalonStylists {
  SalonServiceRepository get _repository =>
      ref.read(salonServiceRepositoryProvider);

  @override
  Future<List<SalonStylistModel>> build() async {
    final res = await _repository.getSalonStylists();

    return switch (res) {
      Left(value: final failure) => throw Exception(failure.message),
      Right(value: final items) => items,
    };
  }

  Future<void> refresh() async {
    state = const AsyncLoading();

    state = await AsyncValue.guard(() async {
      final res = await _repository.getSalonStylists();

      return switch (res) {
        Left(value: final failure) => throw Exception(failure.message),
        Right(value: final items) => items,
      };
    });
  }
}