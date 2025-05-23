import 'package:flutter/material.dart';
import 'package:work_ui/controllers/controllers.dart';
import 'package:work_ui/pages/splash.dart';
import 'package:provider/provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => TransactionController()),
      ],
      child: MaterialApp(debugShowCheckedModeBanner: false, home: Splash()),
    );
  }
}
