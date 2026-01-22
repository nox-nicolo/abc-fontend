

import 'package:fpdart/fpdart.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:africa_beuty/core/model/services.dart';
import 'package:africa_beuty/feature/auth/providers/auth_repository_provider.dart';

part 'getmajor_viewmodel.g.dart';

@riverpod
class GetMajorServiceViewModel extends _$GetMajorServiceViewModel {

  @override 
  AsyncValue<List<MajorServiceModel>>? build() {
    return null;
  }

  Future<void> getMajorService () async {
    
    state = const AsyncValue.loading(); // load initial state

    final authRepo = ref.read(authRemoteRepositoryProvider);

    final res = await authRepo.getMajor();

    final val = switch(res) {
      Left(value: final l) => state = AsyncValue.error(l.message, StackTrace.current),
      Right(value: final r) => {
        state = AsyncValue.data(r), 
      },
    };
    val;
  }
}