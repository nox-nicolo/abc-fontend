import 'package:africa_beuty/feature/profile/model/salon.dart';
import 'package:africa_beuty/feature/profile/providers/salon.dart';
import 'package:africa_beuty/feature/profile/repositories/local_salon.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'salon.g.dart';

@riverpod
class SalonProfileViewModel extends _$SalonProfileViewModel {
  @override
  AsyncValue<SalonProfileModel> build() {
    // We don't call getSalonProfileData() here because we want 
    // the UI to control when the refresh happens.
    return const AsyncValue.loading();
  }

  Future<void> getSalonProfileData() async {
    // 1. Load cached data instantly so the user isn't waiting
    final cached = await SalonProfileStorage.load();
    if (cached != null) {
      state = AsyncValue.data(cached);
    }

    // 2. Fetch latest data from API
    final salonRepository = ref.read(salonProfileProvider);
    final res = await salonRepository.salonProfile();

    res.fold(
      (l) {
        // If we already have cached data in the state, don't overwrite it with an error.
        // This prevents the screen from "blinking" to an error message if the internet is just slow.
        if (state.hasValue) {
          // Optional: Show a toast/snackbar saying "Offline: Showing cached data"
          return;
        }
        state = AsyncValue.error(l.message, StackTrace.current);
      },
      (r) {
        // 3. Update UI with fresh data
        state = AsyncValue.data(r);
        
        // 4. Persistence is handled inside the repository already, 
        // but it doesn't hurt to keep it here for double safety.
        SalonProfileStorage.save(r);
      },
    );
  }
}


// for Improvements:
// If API fails after cache exists, this line:

// Left(value: final l) =>
//   state = AsyncValue.error(l.message, StackTrace.current),


// will replace cached data with an error.

// This is acceptable behavior, but many apps choose to:

// keep cached data visible

// show a snackbar/toast instead