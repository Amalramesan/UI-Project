import 'package:flutter/material.dart';
import 'package:work_ui/pages/home.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Loginn extends StatefulWidget {
  const Loginn({super.key});

  @override
  State<Loginn> createState() => _LoginnState();
}

class _LoginnState extends State<Loginn> {
  Future<void>? savelogin(String email, String password) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('email', email);
    await prefs.setString('password', password);
  }

  bool _hidetext = true;
  final _formkey = GlobalKey<FormState>();
  TextEditingController emailcontroller = TextEditingController();
  TextEditingController passwordcontroller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: SafeArea(
          child: Center(
            child: Form(
              key: _formkey,
              child: Column(
                children: [
                  Image.asset('assets/welcome.jpeg'),
                  SizedBox(height: 50),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Email',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 17,
                        ),
                      ),
                    ),
                  ),
                  //email
                  Padding(
                    padding: const EdgeInsets.all(8),
                    child: TextFormField(
                      //validator
                      controller: emailcontroller,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'please enter email';
                        }

                        if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                          return 'please enter valid email';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(
                            color: Colors.black,
                            width: 1.5,
                          ),
                        ),
                        prefixIcon: Icon(Icons.email),
                        hintText: "Enter your Email",
                      ),
                    ),
                  ),
                  //password
                  SizedBox(height: 10),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Password',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 17,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8),
                    child: TextFormField(
                      validator: (values) {
                        if (values!.isEmpty) {
                          return "Enter a password";
                        }
                        if (values.length <= 6) {
                          return "enter atlest six charactors";
                        }
                        return null;
                      },
                      obscureText: _hidetext,
                      controller: passwordcontroller,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(
                            color: Colors.black,
                            width: 1.5,
                          ),
                        ),
                        prefixIcon: Icon(Icons.password),
                        hintText: "Enter your Password",
                        suffixIcon: IconButton(
                          onPressed: () {
                            setState(() {
                              _hidetext = !_hidetext;
                            });
                          },
                          icon: Icon(
                            _hidetext ? Icons.visibility_off : Icons.visibility,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () async {
                      if (_formkey.currentState!.validate()) {
                        final email = emailcontroller.text.trim();
                        final password = passwordcontroller.text
                            .trim(); // assuming you have this

                        final prefs = await SharedPreferences.getInstance();
                        await prefs.setString('email', email);
                        await prefs.setString('password', password);

                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Homepage(email: email),
                          ),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey,
                      foregroundColor: Colors.white,
                      elevation: 5,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: EdgeInsets.symmetric(
                        horizontal: 70,
                        vertical: 18,
                      ),
                      textStyle: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    child: Text('LOGIN'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
