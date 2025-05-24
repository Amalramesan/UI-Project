import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:work_ui/pages/home.dart';

class LoginController with ChangeNotifier {
  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool hideText = true;

  void toggleHideText() {
    hideText = !hideText;
    notifyListeners();
  }

  Future<void> saveLogin() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('email', emailController.text.trim());
    await prefs.setString('password', passwordController.text.trim());
  }

  Future<void> handleLogin(BuildContext context) async {
    if (formKey.currentState!.validate()) {
      await saveLogin();
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => Homepage(email: emailController.text.trim()),
        ),
      );
    }
  }

  void disposeControllers() {
    emailController.dispose();
    passwordController.dispose();
  }
}
