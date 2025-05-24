import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:work_ui/controllers/login_controller.dart';
import 'package:work_ui/untils/validator.dart';
import 'package:work_ui/widgets/login_button.dart';
import 'package:work_ui/widgets/text_field.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.read<LoginController>();

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Form(
          key: provider.formKey,
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
                controller: provider.emailController,
                hintText: "Enter your Email",
                icon: Icons.email,
                validator: emailValidator,
              ),

              const SizedBox(height: 16),
              const Text(
                "Password",
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
              ),

              Consumer<LoginController>(
                builder: (context, loginProvider, _) {
                  return CustomTextField(
                    controller: loginProvider.passwordController,
                    hintText: "Enter your Password",
                    icon: Icons.password,
                    isObscure: loginProvider.hideText,
                    suffixIcon: IconButton(
                      icon: Icon(
                        loginProvider.hideText
                            ? Icons.visibility_off
                            : Icons.visibility,
                      ),
                      onPressed: loginProvider.toggleHideText,
                    ),
                    validator: passwordValidator,
                  );
                },
              ),

              const SizedBox(height: 24),
              LoginButton(onPressed: () => provider.handleLogin(context)),
            ],
          ),
        ),
      ),
    );
  }
}
