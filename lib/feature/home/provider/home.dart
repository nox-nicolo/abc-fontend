
import 'package:africa_beuty/feature/home/repository/home.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'home.g.dart';

@riverpod
HomeRepositoryImpl homeRepositoryImpl (Ref ref) {
  return HomeRepositoryImpl();
}