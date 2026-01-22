
import 'package:africa_beuty/feature/home/model/post_like.dart';
import 'package:africa_beuty/feature/home/provider/home.dart';
import 'package:africa_beuty/feature/home/repository/home.dart';
import 'package:fpdart/fpdart.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'post_like.g.dart';

@riverpod
class PostLikeViewModel extends _$PostLikeViewModel {
  @override
  AsyncValue<PostLikeModel>? build() {
    return null;
  }

  Future<void> toggleLike({
    required String postId,
  }) async {
    state = const AsyncValue.loading();

    final HomeRepository repo = ref.read(homeRepositoryImplProvider);

    final res = await repo.toggleLike(
      postId: postId,
    );

    final val = switch (res) {
      Left(value: final l) =>
        state = AsyncValue.error(l.message, StackTrace.current),

      Right(value: final r) =>
        state = AsyncValue.data(r),
    };
    val;
  }
}
