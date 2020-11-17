import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Theme.of(context).accentColor,
        child: Center(
            child: Image(
          image: AssetImage('assets/images/Safarnama_Logo.png'),
        )),
      ),
    );
  }
}
