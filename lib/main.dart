import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:safarnama/models/user.dart' as userModel;
import 'package:safarnama/screens/landing_screen.dart';
import 'package:safarnama/screens/login_screen.dart';
import 'package:safarnama/screens/signup_screen.dart';
import 'package:safarnama/screens/splash_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'package:safarnama/screens/trek_screen.dart';
import 'dart:async';

import 'package:safarnama/services/authentication_service.dart';
import 'package:safarnama/services/database_service.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<AuthenticationService>(
          create: (_) => AuthenticationService(FirebaseAuth.instance),
        ),
        StreamProvider(
          initialData: null,
          create: (context) =>
              context.read<AuthenticationService>().authStateChanges,
        )
      ],
      child: MaterialApp(
        title: 'Safarnama',
        debugShowCheckedModeBanner: false,
        routes: {
          '/login': (context) => LoginScreen(),
          '/signup': (context) => SignUpScreen(),
          '/home': (context) => LandingScreen(),
          '/trek': (context) => TrekScreen(),
        },
        theme: ThemeData(
          colorScheme: ColorScheme(
              brightness: Brightness.light,
              primary: Color(0xFF06BEBE),
              onPrimary: Colors.black,
              secondary: Color(0xFF06BEBE),
              onSecondary: Colors.black,
              error: Colors.redAccent,
              onError: Colors.white,
              background: Color(0xFFEFEEEE),
              onBackground: Color(0xFF06BEBE),
              surface: Color(0xFFC1C1C1),
              onSurface: Color(0xFF06BEBE)),
          primaryColor: Color(0xFF06BEBE),
          highlightColor: Color(0xFF06BEBE),
          dialogBackgroundColor: Color(0xFFEFEEEE),
          disabledColor: Color(0xFFC1C1C1),
          textTheme: GoogleFonts.openSansTextTheme(Theme.of(context).textTheme),
        ),
        home: FutureBuilder(
          future: _initialization,
          builder: (context, snapshot) {
            // Check for errors
            if (snapshot.hasError) {
              return Scaffold(
                body: Text('Firebase Initialization Error'),
              );
            }

            // Otherwise, show something whilst waiting for initialization
            return SplashScreen();
          },
        ),
      ),
    );
  }
}

class AuthenticationWrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final firebaseUser = context.watch<User>();
    DatabaseService db = DatabaseService();

    if (firebaseUser != null) {
      return StreamProvider<userModel.User>.value(
          initialData: userModel.User(),
          value: db.userStream(),
          child: LandingScreen());
    }
    return LoginScreen();
  }
}
