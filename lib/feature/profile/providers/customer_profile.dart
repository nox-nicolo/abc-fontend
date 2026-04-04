import 'package:africa_beuty/feature/profile/repositories/customer_profile.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'customer_profile.g.dart';

@riverpod
CustomerProfileRepository customerProfileRepository(Ref ref) {
  return CustomerProfileRepository();
}
