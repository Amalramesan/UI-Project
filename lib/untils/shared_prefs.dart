import 'package:shared_preferences/shared_preferences.dart';
import 'package:work_ui/models/auth_model.dart';

class SharedPrefs {
  static const _keyemail = 'email';
  static const _keypassword = 'password';

  static Future<AuthModel?> savelogin(String email, String password) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyemail, email.trim());
    await prefs.setString(_keypassword, password.trim());

    return AuthModel(email: email.trim(), password: password.trim());
  }

  static Future<AuthModel?> getLoginData() async {
    final prefs = await SharedPreferences.getInstance();
    final email = prefs.getString(_keyemail);
    final password = prefs.getString(_keypassword);
    if (email != null && password != null) {
      return AuthModel(email: email, password: password);
    }
    return null;
  }

  static Future<void> clearlogin() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyemail);
    await prefs.remove(_keypassword);
  }
}
