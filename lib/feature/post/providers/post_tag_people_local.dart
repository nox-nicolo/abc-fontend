
import 'package:africa_beuty/feature/post/repositories/post_tag_people_local.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'post_tag_people_local.g.dart';

@riverpod 
TagPeopleLocalRepository tagPeopleLocalRepositoryProvider(Ref ref) {
  return TagPeopleLocalRepository();
}