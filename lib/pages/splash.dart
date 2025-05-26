import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:work_ui/controllers/controllers.dart';
import 'package:work_ui/pages/home.dart';
import 'package:work_ui/pages/login_page.dart';
import 'package:work_ui/untils/shared_prefs.dart';

class Splash extends StatefulWidget {
  const Splash({super.key});

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _navigate();
  }

  Future<void> _navigate() async {
    await Future.delayed(Duration(seconds: 2));
    final authmodel = await SharedPrefs.getLoginData();
    final transationctrl = Provider.of<TransactionController>(
      context,
      listen: false,
    );
    await transationctrl.loadTransactions();

    if (authmodel != null && authmodel != null) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => Homepage(email: authmodel.email),
        ),
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginPage()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          width: 400,
          height: 400,

          child: Image.asset('assets/welcome.jpeg', fit: BoxFit.contain),
        ),
      ),
    );
  }
}
