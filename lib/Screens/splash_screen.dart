import 'dart:async';

import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import 'auth_screen.dart';


class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  String? version;

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  startTimer(){
    var duration = const Duration(seconds: 5);
    return Timer(duration, route);
  }

  route(){
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
          builder: (context) => const AuthScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
          child: Container(
            child: Lottie.asset('animation/splashAnimation.json'),
          ),
        ),
    );
  }
}