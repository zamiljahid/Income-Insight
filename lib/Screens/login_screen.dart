import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:form_validator/form_validator.dart';
import 'package:income_insight/Screens/dashboard.dart';
import 'package:income_insight/Screens/reset_password_screen.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String? loginID;

  String? password;

  TextEditingController loginIdKeyController = TextEditingController();
  TextEditingController passwordKeyController = TextEditingController();
  bool passwordVisible = false;

  bool isLoading = false;
  final User? currentUser = FirebaseAuth.instance.currentUser;

  SharedPreferences? _prefs;

  final _formKey = GlobalKey<FormState>();

  String? _emailErrorText;

  String? _validateEmail(String? value) {
    RegExp emailRegex = RegExp(r'^[\w-\.]+@[a-zA-Z]+\.[a-zA-Z]{2,}$');
    final isEmailValid = emailRegex.hasMatch(value ?? '');
    if (!isEmailValid) {
      return 'Please enter a valid Login ID';
    }
    return null;
  }

  @override
  void initState() {
    super.initState();
    passwordVisible = false;
  }

  void displayMessageToUser(String message, BuildContext context) {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: Text(message),
            ));
  }

  void login() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        isLoading = true;
      });

      await FirebaseAuth.instance
          .signInWithEmailAndPassword(
              email: loginIdKeyController.text,
              password: passwordKeyController.text)
          .then((value) {
        setState(() {
          isLoading = false;
        });

        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const DashboardScreen()),
        );
        if (context.mounted) Navigator.pop(context);
      }, onError: (error) {
        setState(() {
          isLoading = false;
        });
        displayMessageToUser(error.toString(), context);
        print(error.toString());
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Form(
        key: _formKey,
        child: Stack(
          alignment: Alignment.center,
          children: [
            SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 18.0),
                    child: Text(
                      "Income Insight",
                      style: TextStyle(fontSize: 32, color: Colors.green),
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Lottie.asset('animation/loginAnimation.json', height: 300),
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    "Login",
                    style: TextStyle(fontSize: 28, color: Colors.green),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: TextFormField(
                      keyboardType: TextInputType.emailAddress,
                      validator: _validateEmail,
                      textInputAction: TextInputAction.next,
                      style: TextStyle(color: Colors.black),
                      controller: loginIdKeyController,
                      cursorColor: Theme.of(context).canvasColor,
                      decoration: InputDecoration(
                        errorText: _emailErrorText,
                        border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(10.0))),
                        filled: true,
                        fillColor: Colors.lightGreenAccent,
                        icon: Icon(
                          Icons.person,
                          size: 35,
                        ),
                        labelText: 'Login ID',
                        labelStyle: TextStyle(color: Colors.black87),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: TextFormField(
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: (value) => value!.length < 3
                          ? 'please enter the Password'
                          : null,
                      textInputAction: TextInputAction.next,
                      style: TextStyle(color: Colors.black),
                      obscureText: !passwordVisible,
                      controller: passwordKeyController,
                      cursorColor: Theme.of(context).canvasColor,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(10.0))),
                        filled: true,
                        fillColor: Colors.lightGreenAccent,
                        icon: const Icon(
                          Icons.key,
                          size: 35,
                        ),
                        labelText: 'Password',
                        labelStyle: TextStyle(color: Colors.black87),
                        suffixIcon: IconButton(
                          icon: Icon(
                            passwordVisible
                                ? Icons.visibility
                                : Icons.visibility_off,
                            color: Colors.black87,
                          ),
                          onPressed: () {
                            setState(() {
                              passwordVisible = !passwordVisible;
                            });
                          },
                        ),
                      ),
                    ),
                  ),
                  GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: (){
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => ResetPasswordScreen()),
                      );
                    },
                    child: Text("Forgot password?"),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  SizedBox(
                    width: 200,
                    height: 40,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green),
                      onPressed: () {
                        login();
                      },
                      child: Text(
                        'LOGIN',
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      ),
                    ),
                  ),
                  SizedBox(height: 60,),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset('assets/images/CompanyLogo.png', height: 20, width: 20,),
                        Text(
                          'Orine Technology ',
                          style: TextStyle(color: Colors.black, fontSize: 12),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
            Visibility(
              visible: isLoading,
              child: Center(
                child: CircularProgressIndicator(
                  strokeWidth: 6,
                  color: Colors.lightGreenAccent,
                  backgroundColor: Colors.green,
                ),
              ),
            ),

          ],
        ),
      ),
    );
  }
}
