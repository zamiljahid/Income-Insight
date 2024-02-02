import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
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
    getConnectivity();
    startTimer();
  }

  getConnectivity() =>
  subscription = Connectivity().onConnectivityChanged.listen((ConnectivityResult result) async {
    isDeviceConnected = await InternetConnectionChecker().hasConnection;
    if(!isDeviceConnected && isAlertset == false){
      showDialogBox();
      setState(() => isAlertset = true);
    }
  });

  @override
  void dispose(){
    subscription?.cancel();
    super.dispose();
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

  showDialogBox() => showCupertinoDialog<String>(
      context: context,
      builder: (BuildContext context) => CupertinoAlertDialog(
        title: Text("No Connection"),
        content: Text("Please check your internet connectivity"),
        actions: [
          TextButton(onPressed: ()async{
            Navigator.pop(context, 'Cancel');
            setState(() => isAlertset = false);
            isDeviceConnected = await InternetConnectionChecker().hasConnection;
            if(!isDeviceConnected){
              showDialogBox();
              setState(() => isAlertset = true);
            }
          }, child: Text('OK')),
        ],
      )
  );
}