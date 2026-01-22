


import 'package:africa_beuty/feature/post/repositories/post_hashtags.dart';
import 'package:africa_beuty/feature/post/repositories/post_hashtags_local.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'post_hashtags.g.dart';

@riverpod
HashtagRepositoryImpl hashtagRemoteRepoProvider(Ref ref) {
  return HashtagRepositoryImpl();
}

@riverpod
HashtagLocalRepository hashtagLocalRepoProvider(Ref ref) {
  return HashtagLocalRepository();
}
