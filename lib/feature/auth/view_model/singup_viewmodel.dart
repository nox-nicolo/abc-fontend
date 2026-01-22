
import 'package:africa_beuty/feature/auth/model/signup_model.dart';
import 'package:africa_beuty/feature/auth/providers/auth_repository_provider.dart';
import 'package:fpdart/fpdart.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';


part 'singup_viewmodel.g.dart';

@riverpod
class SignupViewModel extends _$SignupViewModel {

  @override
  AsyncValue<SignupModel>? build() {
    return null;
  }

  Future<void> signUpUser({
    required String name, 
    required String email, 
    required String phone,
    required String password,
    required String role
  }) async {
    state = const AsyncValue.loading(); // set state to loading

    final authRepo = ref.read(authRemoteRepositoryProvider);

    final res = await authRepo.signup(
      name: name, 
      email: email, 
      phone: phone, 
      password: password,
      role: role
    );
    final val = switch (res) {
      Left(value: final l) => state = AsyncValue.error(l.message, StackTrace.current), 
      Right(value: final r) => state = AsyncValue.data(r),
    };
    val;
  }
}
