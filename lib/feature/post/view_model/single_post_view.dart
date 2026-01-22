import 'package:africa_beuty/feature/post/model/single_post_view.dart';
import 'package:africa_beuty/feature/post/providers/post_repository_provider.dart';
import 'package:africa_beuty/feature/post/repositories/post.dart';
import 'package:fpdart/fpdart.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'single_post_view.g.dart';

@riverpod
class SinglePostViewModelNotifier
    extends _$SinglePostViewModelNotifier {
  late final PostRepository _repository;

  @override
  AsyncValue<SinglePostViewModel> build(String postId) {
    _repository = ref.read(postRemoteRepoProviderProvider);

    // safe async trigger
    Future.microtask(() => _load(postId));

    return const AsyncLoading();
  }

  // ----------------------------------------------------------
  // LOAD SINGLE POST VIEW
  // ----------------------------------------------------------
  Future<void> _load(String postId) async {
    final res = await _repository.getSinglePostView(postId);

    if (!ref.mounted) return;

    state = switch (res) {
      Left(value: final failure) =>
          AsyncError(failure.message, StackTrace.current),
      Right(value: final data) =>
          AsyncData(data),
    };
  }

  // ----------------------------------------------------------
  // LOAD MORE OTHER POSTS (CURSOR)
  // ----------------------------------------------------------
  Future<void> loadMoreOtherPosts() async {
    final current = state.value;
    if (current == null) return;

    final cursor = current.otherPosts.nextCursor;
    if (cursor == null) return;

    // prevent double call
    if (state is AsyncLoading) return;

    final res = await _repository.getMoreOtherPosts(
      postId: current.post.id,
      cursor: cursor,
    );

    if (!ref.mounted) return;

    state = switch (res) {
      Left(value: final failure) =>
          AsyncError(failure.message, StackTrace.current),
      Right(value: final next) =>
          AsyncData(
            current.copyWith(
              otherPosts: current.otherPosts.copyWith(
                items: [
                  ...current.otherPosts.items,
                  ...next.items,
                ],
                nextCursor: next.nextCursor,
              ),
            ),
          ),
    };
  }

  // ----------------------------------------------------------
  // REFRESH
  // ----------------------------------------------------------
  Future<void> refresh() async {
    final postId = state.value?.post.id;
    if (postId == null) return;

    state = const AsyncLoading();
    await _load(postId);
  }
}
