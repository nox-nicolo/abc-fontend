import 'package:africa_beuty/feature/auth/model/me_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalStorageService {
  static const String _accessTokenKey = 'access_token';
  static const String _refreshTokenKey = 'refresh_token';
  static const String _tokenTypeKey = 'token_type';
  static const String _userIdKey = 'user_id';
  static const String _userDataKey = 'user_data';
  static const String _isFirstTimeKey = 'is_first_time';

  // ---------------------------
  // Onboarding / first launch
  // ---------------------------
  static Future<void> setFirstTime(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_isFirstTimeKey, value);
  }

  static Future<bool> getIsFirstTime() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_isFirstTimeKey) ?? true;
  }

  // ---------------------------
  // Auth data
  // ---------------------------
  static Future<void> saveAuthData({
    required String accessToken,
    required String refreshToken,
    required String tokenType,
    required String userId,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_accessTokenKey, accessToken);
    await prefs.setString(_refreshTokenKey, refreshToken);
    await prefs.setString(_tokenTypeKey, tokenType);
    await prefs.setString(_userIdKey, userId);
  }

  static Future<String?> getAccessToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_accessTokenKey);
  }

  static Future<String?> getRefreshToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_refreshTokenKey);
  }

  static Future<String?> getTokenType() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_tokenTypeKey);
  }

  static Future<String?> getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_userIdKey);
  }

  // ---------------------------
  // User profile data
  // ---------------------------
  static Future<void> saveUserData(MeModel user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_userDataKey, user.toJson());
  }

  static Future<MeModel?> getUserData() async {
    final prefs = await SharedPreferences.getInstance();
    final userData = prefs.getString(_userDataKey);

    if (userData == null || userData.isEmpty) {
      return null;
    }

    return MeModel.fromJson(userData);
  }

  // Keep this so your old code still works
  static Future<MeModel?> getuserData() async {
    return getUserData();
  }

  // ---------------------------
  // Session check
  // ---------------------------
  static Future<bool> isLoggedIn() async {
    final token = await getAccessToken();
    final user = await getUserData();

    return token != null && token.isNotEmpty && user != null;
  }

  // ---------------------------
  // Logout
  // ---------------------------
  static Future<void> clearAuthData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_accessTokenKey);
    await prefs.remove(_refreshTokenKey);
    await prefs.remove(_tokenTypeKey);
    await prefs.remove(_userIdKey);
    await prefs.remove(_userDataKey);

    // Do NOT remove _isFirstTimeKey here,
    // otherwise welcome page may come back after logout.
  }
}