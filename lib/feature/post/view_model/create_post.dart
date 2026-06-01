import 'package:africa_beuty/feature/auth/repositories/local_storage_service.dart';
import 'package:africa_beuty/feature/post/model/create_post.dart';
import 'package:africa_beuty/feature/post/providers/post_repository_provider.dart';
import 'package:africa_beuty/feature/post/repositories/post.dart';
import 'package:africa_beuty/feature/post/state/createpost.dart';
import 'package:fpdart/fpdart.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:africa_beuty/feature/post/state/post_media.dart';
import 'package:africa_beuty/feature/post/state/post_setting.dart';
import 'package:africa_beuty/feature/post/model/post_settings.dart';

part 'create_post.g.dart';

@riverpod
class CreatePostViewModel extends _$CreatePostViewModel {
  late final PostRepository _repository;

  @override
  CreatePostState build() {
    _repository = ref.read(postRemoteRepoProviderProvider);
    _loadCurrentUser();
    return const CreatePostState();
  }

  Future<void> _loadCurrentUser() async {
    final user = await LocalStorageService.getuserData();
    if (user != null) {
      state = state.copyWith(
        author: user.username,
        picture: user.profilePicture,
      );
    }
  }

  // ----------------------------------------------------------
  // SETTERS
  // ----------------------------------------------------------
  void setAuthor(String v) => state = state.copyWith(author: v);
  void setPicture(String v) => state = state.copyWith(picture: v);
  void setCategory(String v) => state = state.copyWith(categoryId: v);
  void setPostType(String v) => state = state.copyWith(postType: v);
  void setCaption(String v) => state = state.copyWith(caption: v);
  void setHashtags(List<String> v) => state = state.copyWith(hashtags: v);
  void setTaggedUsers(List<String> v) => state = state.copyWith(taggedUsers: v);
  void setMedia(List<PostMediaState> v) => state = state.copyWith(media: v);
  void setSettings(PostSettingsState v) => state = state.copyWith(settings: v);

  // ----------------------------------------------------------
  // SUBMIT POST
  // ----------------------------------------------------------
  Future<void> submit() async {
    if (state.isSubmitting) return;

    state = state.copyWith(
      isSubmitting: true,
      isSuccess: false,
      clearError: true,
      clearCreatedPostId: true,
    );

    final model = _toModel(state);

    final res = await _repository.createPost(model);

    state = switch (res) {
      Left(value: final failure) => state.copyWith(
        isSubmitting: false,
        isSuccess: false,
        error: failure.message,
      ),

      Right(value: final postId) => state.copyWith(
        isSubmitting: false,
        isSuccess: true,
        clearError: true,
        createdPostId: postId,
      ),
    };
  }

  // ----------------------------------------------------------
  // STATE → MODEL
  // ----------------------------------------------------------
  CreatePostModel _toModel(CreatePostState s) {
    return CreatePostModel(
      author: s.author,
      status: s.status ?? "published",
      postType: s.postType,
      category: s.categoryId,
      caption: s.caption,
      hashtags: s.hashtags,
      tagged: s.taggedUsers,
      media: s.media
          .map(
            (m) => PostMedia(
              path: m.path,
              aspectRatio: m.aspectRatio,
              type: m.type,
            ),
          )
          .toList(),
      settings: PostSettings(
        visibility: s.settings.visibility.toString(),
        showLikes: s.settings.showLikes,
        enableComments: s.settings.enableComments,
        allowSharing: s.settings.allowSharing,
        showLocation: s.settings.showLocation,
        pinned: s.settings.pinned,
        ageRestriction: s.settings.ageRestriction,
        disableReactions: s.settings.disableReactions,
      ),
    );
  }
}
