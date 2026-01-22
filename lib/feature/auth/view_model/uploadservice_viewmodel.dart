import 'package:africa_beuty/feature/auth/model/userprofile_model.dart';
import 'package:africa_beuty/feature/auth/providers/auth_repository_provider.dart';
import 'package:fpdart/fpdart.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'uploadservice_viewmodel.g.dart';

@riverpod 
class UploadServiceViewModel extends _$UploadServiceViewModel {

  @override 
  AsyncValue<UploadServiceModel>? build() {
    return null;
  }

  Future<void> uploadService({
    required List<String> selectedServices,
  }) async {
    state = const AsyncValue.loading();

    final authRepo = ref.read(authRemoteRepositoryProvider);

    final res = await authRepo.uploadService(selected: selectedServices);

    switch (res) {
      case Left(value: final l):
        state = AsyncValue.error(l.message, StackTrace.current);
        break;
      case Right(value: final r):
        state = AsyncValue.data(r);
        break;
    }
  }  
}  
