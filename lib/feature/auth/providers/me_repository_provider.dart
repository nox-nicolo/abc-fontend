import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:africa_beuty/feature/auth/repositories/me_remote_repository.dart';

part 'me_repository_provider.g.dart';

@riverpod
MeRemoteRepository getMeDataRepository(Ref ref) {
  return MeRemoteRepository();
}