import 'dart:io';

import 'package:africa_beuty/feature/auth/model/userprofile_model.dart';
import 'package:africa_beuty/feature/auth/providers/auth_repository_provider.dart';
import 'package:africa_beuty/feature/auth/repositories/local_storage_service.dart';
import 'package:fpdart/fpdart.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'uploadaccount_viewmodel.g.dart';

@riverpod
class UploadAccountViewModel extends _$UploadAccountViewModel {
  @override
  AsyncValue<UploadAccountModel>? build() {
    return null; // Initial state is null
  }

  Future<void> uploadAccount({
    File? profileFile, // File can be  null if using network image
    required String username,
    String? networkImageUrl, // File can be null - API can handle null
    bool useNetworkImage =
        false, // Flag  to indicate if using existing network image
  }) async {
    state = const AsyncValue.loading(); // checking the loading state

    final authRepo = ref.read(
      authRemoteRepositoryProvider,
    ); // remote auth repository

    // If using network image, pass null for the file,
    // if using file upload, pass the actual file

    final File? imageToUpload = useNetworkImage ? null : profileFile;

    final res = await authRepo.uploadAccount(
      pictureUrl: imageToUpload,
      username: username,
    );

    switch (res) {
      case Left(value: final l):
        state = AsyncValue.error(l.message, StackTrace.current);
      case Right(value: final r):
        final meRes = await authRepo.me();
        if (meRes case Right(value: final me)) {
          await LocalStorageService.saveUserData(me);
        }
        state = AsyncValue.data(r);
    }
  }
}
