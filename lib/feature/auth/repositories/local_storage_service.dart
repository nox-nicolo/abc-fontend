
import 'package:africa_beuty/feature/auth/model/me_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalStorageService {
  static const _accessTokenKey = 'access_token';
  static const _refreshTokenkey = 'refresh_token';
  static const _tokenTypeKey = 'token_type';
  static const _userIdKey = 'user_id';
  static const _userDataKey = 'user_data';

  static Future<void> saveAuthData({
    required String accessToken, 
    required String refreshToken,  
    required String tokenType, 
    required String userId, 
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_accessTokenKey, accessToken);
    await prefs.setString(_refreshTokenkey, refreshToken);
    await prefs.setString(_tokenTypeKey, tokenType);
    await prefs.setString(_userIdKey, userId);
  }


  // Get access token
  static Future<String?> getAccessToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_accessTokenKey);
  }

  // Get Refresh token
  static Future<String?> getRefreshToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_refreshTokenkey);
  }

  // Get token type 
  static Future<String?> getTokenType() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_tokenTypeKey);
  }

  // Get userId 
  static Future<String?> getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_userIdKey);
  }

  // Add User data storage to LocalStorageService
  static Future<void> saveUserData(MeModel user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_userDataKey, user.toJson());
  }

  // function to get User data from local storage
  static Future<MeModel?> getuserData() async {
    final prefs = await SharedPreferences.getInstance();
    
    final userData = prefs.getString('user_data');
    if (userData != null) {
      return MeModel.fromJson(userData);
    }
    return null; // return null if no user data!
  }

  // Clear all auth data ( during logout)
  static Future<void> clearAuthData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_accessTokenKey);
    await prefs.remove(_refreshTokenkey);
    await prefs.remove(_tokenTypeKey);
    await prefs.remove(_userIdKey);
    await prefs.remove(_userDataKey);
  }
  
}