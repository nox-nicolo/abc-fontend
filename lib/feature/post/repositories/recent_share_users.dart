import 'dart:convert';

import 'package:africa_beuty/feature/search/model/search.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RecentShareUsersRepository {
  static const _key = 'recent_share_users_v1';

  Future<List<SearchUserResult>> load() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getStringList(_key) ?? const [];

    return raw
        .map((item) {
          try {
            final map = jsonDecode(item) as Map<String, dynamic>;
            return SearchUserResult.fromMap(map);
          } catch (_) {
            return null;
          }
        })
        .whereType<SearchUserResult>()
        .toList();
  }

  Future<void> saveUsed(List<SearchUserResult> users) async {
    if (users.isEmpty) return;

    final existing = await load();
    final merged = <SearchUserResult>[
      ...users,
      ...existing.where((old) => !users.any((u) => u.id == old.id)),
    ].take(20).toList();

    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(
      _key,
      merged.map((user) => jsonEncode(user.toMap())).toList(),
    );
  }
}
