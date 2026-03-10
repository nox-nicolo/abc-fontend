
import 'package:africa_beuty/feature/profile/repositories/salon_configure_services.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'salon_configure_services.g.dart';

@riverpod
SalonServiceRepository salonServiceRepository(Ref ref) {
  return SalonServiceRepository();
}
