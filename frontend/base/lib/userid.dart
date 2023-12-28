import 'package:shared_preferences/shared_preferences.dart';

class UserPreferences {
  static const String keyUserId = 'userId';

  static Future<void> saveUserId(String userId) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(keyUserId, userId);
  }

  static Future<int?> getUserId() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? userIdString = prefs.getString(keyUserId);
    return userIdString != null ? int.tryParse(userIdString) : null;
  }
}