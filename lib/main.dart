import 'package:arcyon_healthbot/Screens/signup_screen.dart';
import 'package:arcyon_healthbot/Screens/splash_screen.dart';
import 'package:flutter/material.dart';

void main() => runApp(Arcyon());

class Arcyon extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: SplashScreen.id,
      routes: {
        SplashScreen.id: (context) => SplashScreen(),
        'signup_screen': (context) => SignUpPage(),
      },
    );
  }
}
