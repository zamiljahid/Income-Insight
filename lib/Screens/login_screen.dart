import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:income_insight/Screens/dashboard.dart';
import 'package:income_insight/Screens/reset_password_screen.dart';
import 'package:lottie/lottie.dart';
import 'package:package_info_plus/package_info_plus.dart';

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
  String? version;


  bool isLoading = false;
  final User? currentUser = FirebaseAuth.instance.currentUser;


  final _formKey = GlobalKey<FormState>();

  String? _emailErrorText;

  String? _validateEmail(String? value) {
    RegExp emailRegex = RegExp(r'^[\w-.]+@[a-zA-Z]+\.[a-zA-Z]{2,}$');
    final isEmailValid = emailRegex.hasMatch(value ?? '');
    if (!isEmailValid) {
      return 'Please enter a valid Login ID';
    }
    return null;
  }

  @override
  void initState() {
    super.initState();
    checkVersion();
    passwordVisible = false;
  }

  checkVersion() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();

    String appName = packageInfo.appName;
    String packageName = packageInfo.packageName;
    String buildNumber = packageInfo.buildNumber;

    setState(() {
      version = packageInfo.version;
    });
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
      }, onError: (error) {
        setState(() {
          isLoading = false;
        });
        displayMessageToUser(error.toString(), context);
        if (kDebugMode) {
          print(error.toString());
        }
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
            Align(
              alignment: Alignment.center,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    const SizedBox(
                      height: 10,
                    ),
                    const Padding(
                      padding: EdgeInsets.only(top: 18.0),
                      child: Text(
                        "Income Insight",
                        style: TextStyle(fontSize: 32, color: Colors.green),
                      ),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    Lottie.asset('animation/loginAnimation.json', height: 200),
                    const SizedBox(
                      height: 5,
                    ),
                    const Text(
                      "Login",
                      style: TextStyle(fontSize: 28, color: Colors.green),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10, left: 30,right: 30),
                      child: TextFormField(
                        keyboardType: TextInputType.emailAddress,
                        validator: _validateEmail,
                        textInputAction: TextInputAction.next,
                        style: const TextStyle(color: Colors.black),
                        controller: loginIdKeyController,
                        cursorColor: Theme.of(context).canvasColor,
                        decoration: InputDecoration(
                          errorText: _emailErrorText,
                          focusedBorder: const OutlineInputBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(10.0),
                            ),
                            borderSide: BorderSide(
                              color: Colors.yellow,
                            ),
                          ),
                          border: const OutlineInputBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(10.0),
                            ),
                          ),
                          filled: true,
                          fillColor: Colors.green.shade200,
                          icon: const Icon(
                            Icons.person,
                            size: 35,
                          ),
                          labelText: 'Login ID',
                          labelStyle: const TextStyle(color: Colors.black87),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 30,left: 30, right: 30, bottom: 15),
                      child: TextFormField(
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        validator: (value) => value!.length < 3
                            ? 'please enter the Password'
                            : null,
                        textInputAction: TextInputAction.next,
                        style: const TextStyle(color: Colors.black),
                        obscureText: !passwordVisible,
                        controller: passwordKeyController,
                        cursorColor: Theme.of(context).canvasColor,
                        decoration: InputDecoration(
                          focusedBorder: const OutlineInputBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(10.0),
                            ),
                            borderSide: BorderSide(
                              color: Colors.yellow,
                            ),
                          ),
                          border: const OutlineInputBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(10.0),
                            ),
                          ),
                          filled: true,
                          fillColor: Colors.green.shade200,
                          icon: const Icon(
                            Icons.key,
                            size: 35,
                          ),
                          labelText: 'Password',
                          labelStyle: const TextStyle(color: Colors.black87),
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
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ResetPasswordScreen()),
                        );
                      },
                      child: const Text("Forgot password?"),
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
                        child: const Text(
                          'LOGIN',
                          style: TextStyle(color: Colors.white, fontSize: 18),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 50,
                    ),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            'assets/images/CompanyLogo.png',
                            height: 30,
                            width: 30,
                          ),
                          const Text(
                            'Orine',
                            style: TextStyle(color: Colors.black, fontSize: 16),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                     Align(
                      alignment: Alignment.bottomCenter,
                      child: version != null ? Text(
                        "Version ${version}",
                        style: const TextStyle(color: Colors.black, fontSize: 10),
                      ) : Text(
                        " ",),
                    )
                  ],
                ),
              ),
            ),
            Visibility(
              visible: isLoading,
              child: const Center(
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
