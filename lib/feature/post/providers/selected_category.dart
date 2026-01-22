
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:africa_beuty/core/model/services.dart';

part 'selected_category.g.dart';

@riverpod
class SelectedCategory extends _$SelectedCategory {
  @override
  PostMinorCategoriesModel? build() => null;

  void select(PostMinorCategoriesModel category) {
    state = category;
  }

  void clear() {
    state = null;
  }
}
