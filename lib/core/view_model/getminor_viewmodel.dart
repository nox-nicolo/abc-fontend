import 'package:africa_beuty/core/model/services.dart';
import 'package:africa_beuty/core/providers/remote_category_repository.dart';
import 'package:fpdart/fpdart.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'getminor_viewmodel.g.dart';

@riverpod
class GetMinorServiceViewModel extends _$GetMinorServiceViewModel {
  
  @override
  AsyncValue<List<PostMinorCategoriesModel>> build() {
    getMinorService(); 
    return const AsyncValue.loading();
  }

  Future<void> getMinorService() async {
    // Set state to loading before request
    state = const AsyncValue.loading();

    final cateRepo = ref.read(categoryRemoteRepositoryProvider);
    final res = await cateRepo.getMinor();

    // Handle the Either response
    final val = switch (res) {
      Left(value: final l) =>
        state = AsyncValue.error(l.message, StackTrace.current),
      Right(value: final r) =>
        state = AsyncValue.data(r),
    };
    val; // necessary to suppress warning
  }
}
