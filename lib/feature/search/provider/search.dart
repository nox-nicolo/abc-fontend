import 'package:africa_beuty/feature/search/repository/search.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'search.g.dart';

@riverpod
SearchRepositoryImpl search(Ref ref) {
  return SearchRepositoryImpl();
}