
import 'package:africa_beuty/feature/post/model/post_hashtags.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HashtagLocalRepository {
  static const String _recentKey = 'recent_hashtags_v1';

  // Save recent hashtag models as JSON list
  Future<void> saveRecentHashtags(List<PostHashtagsModel> tags) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonList = tags.map((t) => t.toJson()).toList();
    await prefs.setStringList(_recentKey, jsonList);
  }

  // Get cached recent hashtags (returns empty list if none)
  Future<List<PostHashtagsModel>> getRecentHashtags() async {
    final prefs = await SharedPreferences.getInstance();
    final list = prefs.getStringList(_recentKey) ?? [];
    return list.map((s) => PostHashtagsModel.fromJson(s)).toList();
  }

  // Add a single used hashtag to recent (keeps unique, most-recent-first, max cap)
  Future<void> addToRecent(String name, {int max = 50}) async {
    final current = await getRecentHashtags();
    final normalized = name.trim();
    if (normalized.isEmpty) return;

    // remove existing entry if present
    final filtered = current.where((t) => t.name.toLowerCase() != normalized.toLowerCase()).toList();

    // Add new at front
    final updated = [PostHashtagsModel(name: normalized, number: 1), ...filtered];

    // Trim
    final trimmed = updated.take(max).toList();
    await saveRecentHashtags(trimmed);
  }

  // Clear cache (for debug / logout)
  Future<void> clear() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_recentKey);
  }
}
