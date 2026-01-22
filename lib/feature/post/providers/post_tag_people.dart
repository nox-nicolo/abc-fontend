
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:africa_beuty/feature/post/repositories/post_tag_people.dart';

part 'post_tag_people.g.dart';

@riverpod 
TagPeopleRepositoryImpl tagPeopleRemoteRepoProvider(Ref ref) {
  return TagPeopleRepositoryImpl();
}