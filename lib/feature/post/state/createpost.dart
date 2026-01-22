import 'package:africa_beuty/feature/post/state/post_media.dart';
import 'package:africa_beuty/feature/post/state/post_setting.dart';

class CreatePostState {
  final String author;
  final String picture;
  final String categoryId;
  final String caption;
  final List<String> hashtags;
  final List<String> taggedUsers;
  final List<PostMediaState> media;
  final PostSettingsState settings;
  final bool isSubmitting;
  final bool isSuccess;
  final String? error;
  final String? status;

  const CreatePostState({
    this.author = "",
    this.categoryId = "",
    this.caption = "",
    this.hashtags = const [],
    this.taggedUsers = const [],
    this.media = const [],
    this.settings = const PostSettingsState(),
    this.isSubmitting = false,
    this.isSuccess = false,
    this.picture = "",
    this.error,
    this.status,
  });

  CreatePostState copyWith({
    String? author,
    String? picture,
    String? categoryId,
    String? caption,
    List<String>? hashtags,
    List<String>? taggedUsers,
    List<PostMediaState>? media,
    PostSettingsState? settings,
    bool? isSubmitting,
    bool? isSuccess,
    String? error,
    String? status,
  }) {
    return CreatePostState(
      author: author ?? this.author,
      picture: picture ?? this.picture,
      categoryId: categoryId ?? this.categoryId,
      caption: caption ?? this.caption,
      hashtags: hashtags ?? this.hashtags,
      taggedUsers: taggedUsers ?? this.taggedUsers,
      media: media ?? this.media,
      settings: settings ?? this.settings,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      isSuccess: isSuccess ?? this.isSuccess,
      error: error ?? this.error,
      status: status ?? this.status,
    );
  }
}
