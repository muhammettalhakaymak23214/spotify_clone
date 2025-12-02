import 'package:shared_preferences/shared_preferences.dart';

class TokenManager {
  static const _tokenKey = 'access_token';

  Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tokenKey, token);
  }

  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString(_tokenKey);
    if (token != null) {
      return token;
    }
    return null;
  }

  Future<void> invalidateToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tokenKey, "bos");
  }
}
