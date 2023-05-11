import 'package:flutter/material.dart';
import 'package:patromobilelapps/screens/home_screen.dart';
import 'package:patromobilelapps/screens/auth/login_screen.dart';
import 'package:splash_screen_view/SplashScreenView.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Widget example1 = SplashScreenView(
      navigateRoute: LoginScreen(),
      duration: 5000,
      imageSize: 130,
      imageSrc: 'assets/images/logo.png',
      // text: "Splash Screen",
      textStyle: TextStyle(
        fontSize: 40.0,
      ),
      colors: [
        Colors.purple,
        Colors.blue,
        Colors.yellow,
        Colors.red,
      ],
      backgroundColor: Colors.yellow,
    );

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Promosikan Aja',
      home: example1,
    );
  }
}
