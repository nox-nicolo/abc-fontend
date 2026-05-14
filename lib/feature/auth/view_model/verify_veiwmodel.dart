import 'package:africa_beuty/core/push/push_notification_service.dart';
import 'package:africa_beuty/core/providers/user_provider.dart';
import 'package:africa_beuty/feature/auth/model/verification_model.dart';
import 'package:africa_beuty/feature/auth/providers/auth_repository_provider.dart';
import 'package:africa_beuty/feature/auth/repositories/local_storage_service.dart';
import 'package:africa_beuty/feature/auth/view_model/me_viewmodel.dart';
import 'package:fpdart/fpdart.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'verify_veiwmodel.g.dart';

@riverpod
class VerifyVeiwModel extends _$VerifyVeiwModel {
  @override
  AsyncValue<VerificationModel>? build() {
    return null;
  }

  // AuthRemoteRepository get _authRepo => ref.read(authRemoteRepositoryProvider);

  Future<void> verifyUser({required String code}) async {
    state = const AsyncValue.loading(); // set the state to loading

    final authRepo = ref.read(authRemoteRepositoryProvider);

    final res = await authRepo.verify(code: code);

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

        // Get user data and update the global state.
        final meData = ref.read(meViewModelProvider.notifier);
        await meData.getMeeData();

        // get user data and update the global state
        final userData = await LocalStorageService.getuserData();

        if (userData != null) {
          ref.read(currentUserProvider.notifier).setUser(userData);
        }

        await PushNotificationService.instance.syncTokenIfPossible();

        state = AsyncValue.data(r);
    }
  }
}

// Get user data and update the global state
//
