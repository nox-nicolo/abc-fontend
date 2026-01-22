import 'dart:convert';
import 'package:africa_beuty/feature/post/model/post_tag_people.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TagPeopleLocalRepository {

   static final String _recentUsersKey = 'tag_recent_users';

   static final String _recommendedUsersKey = 'tag_recommended_users';

  /// Save recently tagged users (limit to last 20)
  static Future<void> saveRecentUsers(List<PostTagPeopleModel> users) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonList = users.map((u) => u.toMap()).toList();

    await prefs.setString(_recentUsersKey, jsonEncode(jsonList));
  }

  /// Add one user to "recently tagged" list
  static Future<void> addRecentUser(PostTagPeopleModel user) async {
    final currentList = await getRecentUsers();

    // Remove duplicates
    currentList.removeWhere((u) => u.id == user.id);

    // Add at top
    currentList.insert(0, user);

    // Keep last 20
    if (currentList.length > 20) {
      currentList.removeLast();
    }

    await saveRecentUsers(currentList);
  }

  /// Load recently tagged users
  static Future<List<PostTagPeopleModel>> getRecentUsers() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_recentUsersKey);

    if (jsonString == null) return [];

    final List list = jsonDecode(jsonString);
    return list.map((e) => PostTagPeopleModel.fromMap(e)).toList();
  }

  /// Save recommended users cache
  static Future<void> saveRecommendedUsers(List<PostTagPeopleModel> users) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonList = users.map((u) => u.toMap()).toList();

    await prefs.setString(_recommendedUsersKey, jsonEncode(jsonList));
  }

  /// Read recommended users cache
  static Future<List<PostTagPeopleModel>> getRecommendedUsers() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_recommendedUsersKey);

    if (jsonString == null) return [];

    final List list = jsonDecode(jsonString);
    return list.map((e) => PostTagPeopleModel.fromMap(e)).toList();
  }

  /// Clear all local tag people cache
  static Future<void> clearAll() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_recentUsersKey);
    await prefs.remove(_recommendedUsersKey);
  }
}
