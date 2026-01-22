// lib/feature/profile/repositories/post/post_settings.dart
import 'package:shared_preferences/shared_preferences.dart';
import 'package:africa_beuty/feature/post/model/post_settings.dart';

class PostSettingsRepository {
  static const _key = 'post_settings';

  Future<PostSettings> loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    final json = prefs.getString(_key);
    if (json == null) return const PostSettings();
    return PostSettings.fromJson(json);
  }

  Future<void> saveSettings(PostSettings settings) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_key, settings.toJson());
  }
}
