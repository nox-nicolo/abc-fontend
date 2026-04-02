
import 'package:africa_beuty/feature/profile/repositories/three_dots/services/service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'services.g.dart';

@riverpod
SalonServiceRepository salonServiceRepository(Ref ref) {
  return SalonServiceRepository();
}
