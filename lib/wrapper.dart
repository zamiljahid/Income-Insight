import 'package:flutter/material.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'Screens/no_internet_screen.dart';

class Wrapper extends StatefulWidget {
  const Wrapper({Key? key, required this.child}) : super(key: key);


  final Widget child;

  @override
  _WrapperState createState() => _WrapperState();
}

class _WrapperState extends State<Wrapper> {
  bool isConnected = true;

  @override
  void initState() {
    super.initState();

    InternetConnectionChecker().onStatusChange.listen((event) {
      final hasInternet = event == InternetConnectionStatus.connected;
      if (mounted) {
        setState(() {
          isConnected = hasInternet;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: isConnected ? widget.child : const NoInternetScreen());
  }
}
