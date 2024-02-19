import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:income_insight/wrapper.dart';
import 'package:lottie/lottie.dart';

import 'auth_screen.dart';


class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  String? version;

  StreamSubscription? subscription;
  bool isAlertset = false;
  var isDeviceConnected = false;

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
    return Wrapper(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Center(
            child: Container(
              child: Lottie.asset('animation/splashAnimation.json'),
            ),
          ),
      ),
    );
  }

}