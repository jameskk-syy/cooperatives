
import 'package:shared_preferences/shared_preferences.dart';

class HeaderInterceptor {
  static Future<Map<String, String>> getHeaders() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token') ?? '';
    final username = prefs.getString('username') ?? '';
    final entityId = prefs.getString('entityId') ?? '';

    return {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
      'username': username,
      'entityId': entityId,
    };
  }
}
