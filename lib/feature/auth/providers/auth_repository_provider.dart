
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:africa_beuty/feature/auth/repositories/auth_remote_repository.dart';

part 'auth_repository_provider.g.dart';

@riverpod
AuthRemoteRepository authRemoteRepository(Ref ref) {
  return AuthRemoteRepository();
}

