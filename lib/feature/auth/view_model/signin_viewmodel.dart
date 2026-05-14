import 'package:africa_beuty/core/push/push_notification_service.dart';
import 'package:africa_beuty/core/providers/user_provider.dart';
import 'package:africa_beuty/feature/auth/model/signin_model.dart';
import 'package:africa_beuty/feature/auth/providers/auth_repository_provider.dart';
import 'package:africa_beuty/feature/auth/repositories/local_storage_service.dart';
import 'package:africa_beuty/feature/auth/view_model/me_viewmodel.dart';
import 'package:fpdart/fpdart.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'signin_viewmodel.g.dart';

@riverpod
class SigninViewModel extends _$SigninViewModel {
  @override
  AsyncValue<SigninModel>? build() {
    return null;
  }

  Future<void> signInUser({
    required String email,
    required String password,
  }) async {
    state = const AsyncValue.loading(); // set state to loading

    final authRepo = ref.read(authRemoteRepositoryProvider);

    // call login api
    final res = await authRepo.login(email: email, password: password);

    // Save auth data
    switch (res) {
      case Left(value: final l):
        state = AsyncValue.error(l.message, StackTrace.current);
      case Right(value: final r):
        await LocalStorageService.saveAuthData(
          accessToken: r.accessToken,
          refreshToken: r.refreshToken,
          tokenType: r.tokenType,
          userId: r.userId,
        );

        // Get the user data and update the global state
        final meData = ref.read(meViewModelProvider.notifier);
        await meData.getMeeData();

        // Get user data and update the global state
        final userData = await LocalStorageService.getuserData();

        if (userData != null) {
          ref.read(currentUserProvider.notifier).setUser(userData);
        }

        await PushNotificationService.instance.syncTokenIfPossible();

        // After successful login and fetching user data
        state = AsyncValue.data(r);
    }
  }

  Future<void> signOutUser() async {
    //  Future implementations..
  }
}

// after a succss full login save auth data in localStorageService
// Get user data and update the global state
//
