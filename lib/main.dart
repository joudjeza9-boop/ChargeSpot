import 'package:flutter/material.dart';
import 'features/splash/splash_screen.dart'; 
import 'features/auth/auth_screen.dart';

void main() => runApp(const ChargifyApp());

class ChargifyApp extends StatelessWidget {
  const ChargifyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: appName,
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(useMaterial3: true),
      home: const SplashScreen(),
    );
  }
}
