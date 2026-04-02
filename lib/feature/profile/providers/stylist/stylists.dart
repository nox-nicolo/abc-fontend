import 'package:africa_beuty/feature/profile/repositories/three_dots/stylists/stylists.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'stylists.g.dart';

@riverpod
SalonStylistRepository salonStylistRepository(Ref ref) {
  return SalonStylistRepository();
}
