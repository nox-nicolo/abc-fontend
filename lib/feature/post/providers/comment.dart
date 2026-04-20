import 'package:africa_beuty/feature/post/repositories/comment.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'comment.g.dart';

@riverpod
CommentRepositoryImpl commentRepository(Ref ref) {
  return CommentRepositoryImpl();
}
