import 'package:africa_beuty/feature/saved/model/saved_item.dart';
import 'package:africa_beuty/feature/saved/repository/saved_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final savedRepositoryProvider = Provider<SavedRepository>((ref) {
  return SavedRepository();
});

final savedCollectionProvider = FutureProvider<SavedCollection>((ref) async {
  final result = await ref.read(savedRepositoryProvider).getSaved();
  return result.fold((failure) => throw failure, (collection) => collection);
});
