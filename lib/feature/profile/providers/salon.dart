
import 'package:africa_beuty/feature/profile/repositories/salon.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'salon.g.dart';

@riverpod
SalonProfileRepository salonProfile(Ref ref) {
  return SalonProfileRepository();
}