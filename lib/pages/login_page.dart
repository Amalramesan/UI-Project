import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:work_ui/pages/home.dart';
import 'package:work_ui/untils/validator.dart';
import 'package:work_ui/widgets/login_button.dart';
import 'package:work_ui/widgets/text_field.dart';

class LoginPage extends StatelessWidget {
  LoginPage({super.key});

  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final ValueNotifier<bool> _hideText = ValueNotifier(true);

  Future<void> _saveLogin(String email, String password) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('email', email);
    await prefs.setString('password', password);
  }

  void _handleLogin(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      final email = _emailController.text.trim();
      final password = _passwordController.text.trim();

      await _saveLogin(email, password);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => Homepage(email: email)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Image.asset('assets/welcome.jpeg'),
              const SizedBox(height: 40),
              const Text(
                "Email",
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
              ),
              CustomTextField(
                controller: _emailController,
                hintText: "Enter your Email",
                icon: Icons.email,
                validator: emailValidator,
              ),
              const SizedBox(height: 16),
              const Text(
                "Password",
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
              ),
              ValueListenableBuilder<bool>(
                valueListenable: _hideText,
                builder: (context, hide, _) {
                  return CustomTextField(
                    controller: _passwordController,
                    hintText: "Enter your Password",
                    icon: Icons.password,
                    isObscure: hide,
                    suffixIcon: IconButton(
                      icon: Icon(
                        hide ? Icons.visibility_off : Icons.visibility,
                      ),
                      onPressed: () => _hideText.value = !hide,
                    ),
                    validator: passwordValidator,
                  );
                },
              ),
              const SizedBox(height: 24),
              LoginButton(onPressed: () => _handleLogin(context)),
            ],
          ),
        ),
      ),
    );
  }
}
