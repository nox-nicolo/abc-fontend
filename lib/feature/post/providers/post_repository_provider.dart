
import 'package:africa_beuty/feature/post/repositories/post.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'post_repository_provider.g.dart';

@riverpod
PostRepositoryImpl postRemoteRepoProvider(Ref ref) {
  return PostRepositoryImpl();
}
