import 'package:africa_beuty/core/repository/categories.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'remote_category_repository.g.dart';

@riverpod
RemotePostCategories categoryRemoteRepository(Ref ref) {
  return RemotePostCategories();
}
