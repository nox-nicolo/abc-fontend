// feature/post/state/hashtag_state.dart

import 'package:africa_beuty/feature/post/model/post_hashtags.dart';

class HashtagState {
  final List<PostHashtagsModel> recent;    // recent local tags
  final List<PostHashtagsModel> results;   // server search results / suggestions
  final List<String> selected;             // selected hashtag names (strings)
  final bool loading;

  const HashtagState({
    this.recent = const [],
    this.results = const [],
    this.selected = const [],
    this.loading = false,
  });

  HashtagState copyWith({
    List<PostHashtagsModel>? recent,
    List<PostHashtagsModel>? results,
    List<String>? selected,
    bool? loading,
  }) {
    return HashtagState(
      recent: recent ?? this.recent,
      results: results ?? this.results,
      selected: selected ?? this.selected,
      loading: loading ?? this.loading,
    );
  }
}
