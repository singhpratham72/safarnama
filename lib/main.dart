import 'package:flutter/material.dart';
import 'package:safarnama/screens/splash_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        accentColor: Color(0xFF06BEBE),
      ),
      home: SplashScreen(),
    );
  }
}
