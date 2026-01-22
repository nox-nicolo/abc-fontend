import 'package:africa_beuty/feature/post/model/post_tag_people.dart';

class TagPeopleState {
  final List<PostTagPeopleModel> recommended;
  final List<PostTagPeopleModel> recent;
  final List<PostTagPeopleModel> search;
  final List<PostTagPeopleModel> selected;

  const TagPeopleState({
    this.recommended = const [],
    this.recent = const [],
    this.search = const [],
    this.selected = const [],
  });

  TagPeopleState copyWith({
    List<PostTagPeopleModel>? recommended,
    List<PostTagPeopleModel>? recent,
    List<PostTagPeopleModel>? search,
    List<PostTagPeopleModel>? selected,
  }) {
    return TagPeopleState(
      recommended: recommended ?? this.recommended,
      recent: recent ?? this.recent,
      search: search ?? this.search,
      selected: selected ?? this.selected,
    );
  }
}
