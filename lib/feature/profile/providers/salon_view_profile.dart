
import 'package:africa_beuty/feature/profile/repositories/salon_view_profile.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'salon_view_profile.g.dart';

@riverpod
SalonRepository salonRepository(Ref ref) {
  return SalonRepository();
}
