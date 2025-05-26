import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:work_ui/controllers/controllers.dart';
import 'package:work_ui/models/auth_model.dart';
import 'package:work_ui/pages/home.dart';
import 'package:work_ui/untils/shared_prefs.dart';

class LoginController with ChangeNotifier {
  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool hideText = true;
  void clearFields() {
    emailController.clear();
    passwordController.clear();
  }

  void toggleHideText() {
    hideText = !hideText;
    notifyListeners();
  }

  Future<void> handleLogin(BuildContext context) async {
    if (formKey.currentState!.validate()) {
      final transactionctrl = Provider.of<TransactionController>(
        context,
        listen: false,
      );
      transactionctrl.loadTransactions();
      final auth = AuthModel(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );
      await SharedPrefs.savelogin(auth.email, auth.password);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => Homepage(email: emailController.text.trim()),
        ),
      ).then((_) => clearFields());

      Future.delayed(Durations.medium1).then((_) => clearFields());
    }
  }
}
