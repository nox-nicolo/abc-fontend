import 'package:africa_beuty/feature/post/model/comment.dart';
import 'package:africa_beuty/feature/post/providers/comment.dart';
import 'package:africa_beuty/feature/auth/repositories/local_storage_service.dart';
import 'package:fpdart/fpdart.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'comment.g.dart';

class CommentsState {
  final List<CommentModel> items;
  final String? nextCursor;
  final bool isLoading;
  final bool isLoadingMore;
  final String? error;

  const CommentsState({
    this.items = const [],
    this.nextCursor,
    this.isLoading = false,
    this.isLoadingMore = false,
    this.error,
  });

  bool get hasMore => nextCursor != null;

  CommentsState copyWith({
    List<CommentModel>? items,
    String? nextCursor,
    bool? isLoading,
    bool? isLoadingMore,
    String? error,
    bool clearCursor = false,
    bool clearError = false,
  }) {
    return CommentsState(
      items: items ?? this.items,
      nextCursor: clearCursor ? null : (nextCursor ?? this.nextCursor),
      isLoading: isLoading ?? this.isLoading,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      error: clearError ? null : (error ?? this.error),
    );
  }
}

@riverpod
class CommentsViewModel extends _$CommentsViewModel {
  @override
  CommentsState build(String postId) {
    // fire initial load, return empty-loading state
    Future.microtask(load);
    return const CommentsState(isLoading: true);
  }

  Future<void> load() async {
    state = state.copyWith(
      isLoading: true,
      clearError: true,
      items: const [],
      clearCursor: true,
    );

    final res = await ref.read(commentRepositoryProvider).list(postId: postId);

    if (!ref.mounted) return;

    state = switch (res) {
      Left(value: final f) => state.copyWith(
        isLoading: false,
        error: f.message,
      ),
      Right(value: final page) => state.copyWith(
        isLoading: false,
        items: page.items,
        nextCursor: page.nextCursor,
      ),
    };
  }

  Future<void> loadMore() async {
    if (state.isLoadingMore || !state.hasMore) return;
    state = state.copyWith(isLoadingMore: true);

    final res = await ref
        .read(commentRepositoryProvider)
        .list(postId: postId, cursor: state.nextCursor);

    if (!ref.mounted) return;

    state = switch (res) {
      Left(value: final f) => state.copyWith(
        isLoadingMore: false,
        error: f.message,
      ),
      Right(value: final page) => state.copyWith(
        isLoadingMore: false,
        items: [...state.items, ...page.items],
        nextCursor: page.nextCursor,
      ),
    };
  }

  Future<bool> add({required String content, String? parentCommentId}) async {
    final tempId = 'pending-${DateTime.now().microsecondsSinceEpoch}';
    final user = await LocalStorageService.getUserData();
    final optimisticComment = CommentModel(
      id: tempId,
      postId: postId,
      content: content,
      author: CommentAuthorModel(
        id: user?.id ?? '',
        username: user?.username ?? 'You',
        profilePicture: user?.profilePicture,
      ),
      parentCommentId: parentCommentId,
      replyCount: 0,
      createdAt: DateTime.now().toUtc(),
      isMine: true,
      isPending: true,
    );

    state = state.copyWith(
      items: [optimisticComment, ...state.items],
      clearError: true,
    );

    final res = await ref
        .read(commentRepositoryProvider)
        .create(
          postId: postId,
          content: content,
          parentCommentId: parentCommentId,
        );

    if (!ref.mounted) return false;

    return res.fold(
      (f) {
        state = state.copyWith(
          items: state.items.where((c) => c.id != tempId).toList(),
          error: f.message,
        );
        return false;
      },
      (c) {
        state = state.copyWith(
          items: state.items
              .map((item) => item.id == tempId ? c : item)
              .toList(),
        );
        return true;
      },
    );
  }

  Future<bool> remove(String commentId) async {
    final snapshot = state.items;
    state = state.copyWith(
      items: snapshot.where((c) => c.id != commentId).toList(),
    );

    final res = await ref
        .read(commentRepositoryProvider)
        .delete(postId: postId, commentId: commentId);

    if (!ref.mounted) return false;

    return res.fold((f) {
      state = state.copyWith(items: snapshot, error: f.message);
      return false;
    }, (_) => true);
  }
}
