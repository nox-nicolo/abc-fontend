
import 'package:africa_beuty/feature/auth/model/userprofile_model.dart';
import 'package:africa_beuty/feature/auth/providers/auth_repository_provider.dart';
import 'package:fpdart/fpdart.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'setaccount_viewmodel.g.dart';

@riverpod 
class SetProfileViewModel extends _$SetProfileViewModel {
  @override 
  AsyncValue<SetAccountModel>? build() {
    return null; // Initial state is null
  }

  Future<void> getUserProfile( ) async {

    state = const AsyncValue.loading(); // loading the state 

    final authRepo = ref.read(authRemoteRepositoryProvider); 

    final res = await authRepo.setAccount();

    final val = switch(res) {
      Left(value: final l) => state = AsyncValue.error(l.message, StackTrace.current),
      Right(value: final r) => {
        state = AsyncValue.data(r), 
      },
    };
    
    print(val);
  }
}