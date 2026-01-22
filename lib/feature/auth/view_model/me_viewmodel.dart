import 'package:africa_beuty/feature/auth/model/me_model.dart';
import 'package:africa_beuty/feature/auth/providers/auth_repository_provider.dart';
import 'package:africa_beuty/feature/auth/repositories/local_storage_service.dart';
import 'package:fpdart/fpdart.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'me_viewmodel.g.dart';

@Riverpod(keepAlive: true)
class MeViewModel extends _$MeViewModel {
  
  @override 
  AsyncValue<MeModel>? build() {
    return null;
  }

  Future<void> getMeeData() async {
    
    state = const AsyncValue.loading();

    final authRepo = ref.read(authRemoteRepositoryProvider);

    final res = await authRepo.me();

    if (!ref.mounted) return;

    final val = switch(res) {
      Left(value: final l) => state = AsyncValue.error(l.message, StackTrace.current),
      Right(value: final r) => {
        state = AsyncValue.data(r), 
        // Save user data to local storage
        LocalStorageService.saveUserData(r),
      },
    };
    val;
  }
}