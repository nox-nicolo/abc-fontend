
import 'package:africa_beuty/feature/profile/repositories/settings/update_profile.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'salon_update.g.dart';

@riverpod
UpdateSalonRepository salonUpdate(Ref ref) {
  return UpdateSalonRepository();
}