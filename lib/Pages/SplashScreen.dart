import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../Auth/WelcomeScreen.dart';
import 'MainScreen.dart';

class SplashScreen extends StatefulWidget {
  static const String id = 'splash-screen';
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    Timer(Duration(seconds: 3), () {
      FirebaseAuth.instance.authStateChanges().listen((User user) {
            if (user == null) {
              Navigator.pushReplacementNamed(context, WelcomeScreen.id);
            } else {
              // Navigator.pushReplacementNamed(context, HomeScreen.id);
              Navigator.pushReplacementNamed(context, MainScreen.id);
            }
          } as void Function(User? event)?);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).primaryColor,
        body: Center(
          child: Hero(
            tag: 'Ahia logo',
            child: Padding(
              padding: const EdgeInsets.all(100),
              child: Column(
                children: [
                  Text(
                    "Ahia",
                    style: TextStyle(
                        fontFamily: 'Signatra',
                        fontSize: 65,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                  Text(
                    '...everything',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.black,
                    ),
                  )
                ],
              ),
            ),
          ),
        ));
  }
}
