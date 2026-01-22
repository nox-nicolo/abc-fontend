
import 'package:africa_beuty/feature/booking/repository/salon_offer.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'salon_offer.g.dart';

@riverpod
SalonOfferRepository salonOfferRepository(Ref ref) {
  return SalonOfferRepository();
}
