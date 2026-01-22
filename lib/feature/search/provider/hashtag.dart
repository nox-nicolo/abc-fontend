
import 'package:africa_beuty/feature/search/repository/hashtag.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'hashtag.g.dart';

@riverpod
HashtagRepositoryImpl hashtagRepository(Ref ref) {
  return HashtagRepositoryImpl();
}