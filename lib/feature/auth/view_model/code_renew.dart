

import 'package:africa_beuty/feature/auth/model/verification_model.dart';
import 'package:africa_beuty/feature/auth/providers/auth_repository_provider.dart';
import 'package:fpdart/fpdart.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'code_renew.g.dart';

@riverpod
class CodeRenewViewModel extends _$CodeRenewViewModel {
  @override 
  AsyncValue<VerificationCodeModel>? build() {
    return null;
  }

  Future<void> getNewCode({
    required String code,
  }) async {
    state = const AsyncValue.loading(); // set the state to loading

    final authRepo = ref.read(authRemoteRepositoryProvider);

    final res = await authRepo.newCode(
      code: code,
    );

    final val = switch(res) {
      Left(value: final l) => state = AsyncValue.error(l.message, StackTrace.current), 
      Right(value: final r) => state = AsyncValue.data(r)
    };
    val;
  
  }
}