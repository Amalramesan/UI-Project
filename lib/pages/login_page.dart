import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:work_ui/pages/home.dart';
import 'package:work_ui/untils/validator.dart';
import 'package:work_ui/widgets/login_button.dart';
import 'package:work_ui/widgets/text_field.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _hideText = true;

  Future<void> _saveLogin(String email, String password) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('email', email);
    await prefs.setString('password', password);
  }

  void _togglePassword() {
    setState(() => _hideText = !_hideText);
  }

  void _handleLogin() async {
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
              CustomTextField(
                controller: _passwordController,
                hintText: "Enter your Password",
                icon: Icons.password,
                isObscure: _hideText,
                suffixIcon: IconButton(
                  icon: Icon(
                    _hideText ? Icons.visibility_off : Icons.visibility,
                  ),
                  onPressed: _togglePassword,
                ),
                validator: passwordValidator,
              ),
              const SizedBox(height: 24),
              LoginButton(onPressed: _handleLogin),
            ],
          ),
        ),
      ),
    );
  }
}
