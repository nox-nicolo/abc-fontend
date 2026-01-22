// lib/feature/profile/view_model/post/post_settings.dart

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:africa_beuty/feature/post/model/post_settings.dart';
import 'package:africa_beuty/feature/post/repositories/post_settings.dart';

part 'post_settings.g.dart';

@riverpod
class PostSettingsViewModel extends _$PostSettingsViewModel {
  late final PostSettingsRepository _repository;

  @override
  Future<PostSettings> build() async {
    _repository = PostSettingsRepository();
    return _repository.loadSettings();
  }

  /// Safe accessor for current settings
  PostSettings? get _current {
    final s = state;
    return s is AsyncData<PostSettings> ? s.value : null;
  }

  Future<void> updateSetting(PostSettings newSettings) async {
    // Optimistic update
    state = AsyncValue.data(newSettings);

    try {
      await _repository.saveSettings(newSettings);
    } catch (e, st) {
      // Rollback on failure
      state = AsyncValue.error(e, st);
    }
  }

  // --------------------------------------------------
  // Generic helpers
  // --------------------------------------------------

  void _toggle(PostSettings Function(PostSettings) updateFn) {
    final current = _current;
    if (current == null) return;
    updateSetting(updateFn(current));
  }

  // --------------------------------------------------
  // Explicit setters
  // --------------------------------------------------

  void setVisibility(String value) {
    final current = _current;
    if (current == null) return;

    updateSetting(
      current.copyWith(visibility: value),
    );
  }

  void setAgeRestriction(String value) {
    final current = _current;
    if (current == null) return;

    updateSetting(
      current.copyWith(ageRestriction: value),
    );
  }

  // --------------------------------------------------
  // Boolean toggles
  // --------------------------------------------------

  void toggleLikes(bool value) =>
      _toggle((s) => s.copyWith(showLikes: value));

  void toggleComments(bool value) =>
      _toggle((s) => s.copyWith(enableComments: value));

  void toggleSharing(bool value) =>
      _toggle((s) => s.copyWith(allowSharing: value));

  void toggleLocation(bool value) =>
      _toggle((s) => s.copyWith(showLocation: value));

  void togglePinned(bool value) =>
      _toggle((s) => s.copyWith(pinned: value));

  void toggleReactions(bool value) =>
      _toggle((s) => s.copyWith(disableReactions: value));
}
