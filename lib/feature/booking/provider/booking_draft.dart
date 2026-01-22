// booking_draft_notifier.dart
import 'package:africa_beuty/core/model/services.dart';
import 'package:africa_beuty/feature/booking/model/booking_draft.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'booking_draft.g.dart';

@Riverpod(keepAlive: true)
class BookingDraftNotifier extends _$BookingDraftNotifier {
  @override
  BookingDraft build() => const BookingDraft();

  // STYLE
  void selectStyle(PostMinorCategoriesModel style) {
    state = state.copyWith(style: style);
  }

  // SALON OFFER (✅ THIS WAS MISSING)
  void selectSalonOffer({
    required String salonServicePriceId,
    required String salonName,
    required double price,
    required String currency,
    required int durationMinutes,
  }) {
    state = state.copyWith(
      salonServicePriceId: salonServicePriceId,
      salonName: salonName,
      price: price,
      currency: currency,
      durationMinutes: durationMinutes,
    );
  }

  // DATE & TIME
  void setStartAt(DateTime dateTime) {
    state = state.copyWith(startAt: dateTime);
  }

  // NOTE
  void setNote(String note) {
    state = state.copyWith(note: note);
  }

  void reset() {
    state = const BookingDraft();
  }
}
