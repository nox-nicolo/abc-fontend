import 'package:africa_beuty/feature/auth/model/user_model.dart';
import 'package:africa_beuty/feature/auth/repositories/auth_remote_repository.dart';
import 'package:fpdart/fpdart.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'auth_viewmodel.g.dart';

@riverpod
class AuthViewModel extends _$AuthViewModel {
  final AuthRemoteRepository _authRemoteRepository = AuthRemoteRepository();
  @override 
  AsyncValue<UserModel>? build() {
    return null;
  }

  Future<void> signUpUser({
    required String name, 
    required String email, 
    required String phone, 
    required String password,
    required String role,
  }) async {
    state = const AsyncValue.loading();
    final res = await _authRemoteRepository.signup(
      name: name, 
      email: email, 
      phone: phone, 
      password: password,
      role: role
    );
    final val = switch (res) {
      Left(value: final l) => state = AsyncValue.error(l.message, StackTrace.current), 
      Right(value: final r) => state = AsyncValue.data(r as UserModel),
    };
    val;
  }

  Future<void> signInUser({
    required String email, 
    required String password
  }) async {

    state = const AsyncValue.loading();

    final res = await _authRemoteRepository.login(
      email: email, 
      password: password
    );

    final val = switch(res) {
      Left(value: final l) => state = AsyncValue.error(l.message, StackTrace.current), 
      Right(value: final r) => state = AsyncValue.data(r as UserModel),
    };
    val;

    
  }

  
  
}