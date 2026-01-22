
import 'package:africa_beuty/feature/post/providers/post_tag_people.dart';
import 'package:africa_beuty/feature/post/providers/post_tag_people_local.dart';
import 'package:africa_beuty/feature/post/repositories/post_tag_people.dart';
import 'package:africa_beuty/feature/post/repositories/post_tag_people_local.dart';
import 'package:africa_beuty/feature/post/state/tag_people.dart';
import 'package:fpdart/fpdart.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:africa_beuty/feature/post/model/post_tag_people.dart';

part 'post_tag_people.g.dart';

@riverpod
class TagPeopleViewModel extends _$TagPeopleViewModel {

  @override
  AsyncValue<TagPeopleState> build() {
    return const AsyncValue.data(TagPeopleState());
  }

  TagPeopleRepositoryImpl get _remote => ref.read(tagPeopleRemoteRepoProviderProvider);
  TagPeopleLocalRepository get _local => ref.read(tagPeopleLocalRepositoryProviderProvider);

  // ---------------------------
  // Load Recommended
  // ---------------------------
  Future<void> loadRecommended() async {
    // state = const AsyncValue.loading();

    // final cached = await _local.getRecommendedUsers();

    // if (cached.isNotEmpty) {
    //   state = AsyncValue.data(
    //     state.value!.copyWith(recommended: cached),
    //   );
    // }

    // final result = await _remote.getRecommendedUsers();

    // state = switch (result) {
    //   Left(value: final l) => AsyncValue.error(l.message, StackTrace.current),
    //   Right(value: final r) => AsyncValue.data(
    //     (state.value ?? TagPeopleState()).copyWith(recommended: r),
    //   ),
    // };
  }

  // ---------------------------
  // Load Recent
  // ---------------------------
  Future<void> loadRecent() async {
    final result = await _remote.getRecentUsers();

    state = switch (result) {
      Left(value: final l) => AsyncValue.error(l.message, StackTrace.current),
      Right(value: final r) => AsyncValue.data(
        (state.value ?? TagPeopleState()).copyWith(recent: r),
      ),
    };
  }

  // ---------------------------
  // Search
  // ---------------------------
  Future<void> search(String query) async {
    if (query.isEmpty) {
      state = AsyncValue.data(
        state.value!.copyWith(search: []),
      );
      return;
    }

    final result = await _remote.searchUsers(query);

    state = switch (result) {
      Left(value: final l) => AsyncValue.error(l.message, StackTrace.current),
      Right(value: final r) => AsyncValue.data(
        (state.value ?? TagPeopleState()).copyWith(search: r),
      ),
    };
  }

  // ---------------------------
  // Restore Selected 
  // ---------------------------
  void restoreSelected(List<PostTagPeopleModel> existing) {
    state = AsyncValue.data(
      (state.value ?? TagPeopleState()).copyWith(selected: existing),
    );
  }

  // ---------------------------
  // Select / Unselect User
  // ---------------------------
  void toggleSelect(PostTagPeopleModel user) {
    final cur = state.value!;
    final exists = cur.selected.any((u) => u.id == user.id);

    final updated = exists
        ? cur.selected.where((u) => u.id != user.id).toList()
        : [...cur.selected, user];

    state = AsyncValue.data(
      cur.copyWith(selected: updated),
    );
  }
}
