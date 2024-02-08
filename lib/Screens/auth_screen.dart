import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:income_insight/Screens/dashboard.dart';
import 'package:income_insight/Screens/login_screen.dart';


class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot){
          if(snapshot.hasData){
            return  const DashboardScreen();
          }
          else{
            return const LoginScreen();
          }
        },
      ),
    );
  }
}