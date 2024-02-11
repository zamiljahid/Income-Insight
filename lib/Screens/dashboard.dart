import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:income_insight/Screens/add_transaction_screen.dart';
import 'package:income_insight/Screens/graph_screen.dart';
import 'package:income_insight/Screens/home_screen.dart';
import 'package:income_insight/Screens/profile_screen.dart';
import 'package:income_insight/Screens/search_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

final User? currentUser = FirebaseAuth.instance.currentUser;

SharedPreferences? _prefs;

Future<void> initSharedPreferences() async {
  _prefs = await SharedPreferences.getInstance();
}

Future<DocumentSnapshot<Map<String, dynamic>>> getUserDetails() async {
  return await FirebaseFirestore.instance
      .collection("User")
      .doc(currentUser!.email)
      .get();
}

final screen = [
  const SearchScreen(),
  const AddTransactionScreen(),
  const HomeScreen(),
  const GraphScreen(),
  ProfileScreen(),
];

final items = <Widget>[
  const Icon(Icons.search, size: 30, color: Colors.white),
  const Icon(Icons.add, size: 30, color: Colors.white),
  const Icon(
    Icons.home,
    size: 30,
    color: Colors.white,
  ),
  const Icon(Icons.auto_graph, size: 30, color: Colors.white),
  const Icon(Icons.person, size: 30, color: Colors.white),
];

class _DashboardScreenState extends State<DashboardScreen> {
  int index = 2;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false
      ,
        backgroundColor: Colors.white,
        // extendBody: true,
        body: FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
          future: getUserDetails(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(
                  strokeWidth: 6,
                  color: Colors.lightGreenAccent,
                  backgroundColor: Colors.green,
                ),
              );
            } else if (snapshot.hasError) {
              return Text("Error: ${snapshot.hasError}");
            } else if (snapshot.hasData) {
              Map<String, dynamic>? user = snapshot.data!.data();
              initSharedPreferences(); // Initialize SharedPreferences
              _prefs?.setString('emp_name', user!['displayName']);
              _prefs?.setString('emp_pos', user!['position']);
              _prefs?.setString('emp_id', user!['id']);
              return screen[index];
            } else {
              return Text("No Data to Display");
            }
          },
        ),
        bottomNavigationBar: Container(
            height: 75,
            decoration: const BoxDecoration(
              color: Colors.lightGreen,
              borderRadius: BorderRadius.only(
                  topRight: Radius.circular(30), topLeft: Radius.circular(30)),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30.0),
                topRight: Radius.circular(30.0),
              ),
              child: CurvedNavigationBar(
                index: index,
                height: 60,
                color: Colors.green.shade600,
                buttonBackgroundColor: Colors.green.shade900,
                backgroundColor: Colors.transparent,
                animationDuration: const Duration(milliseconds: 300),
                items: items,
                onTap: (index) => setState(() => this.index = index),
              ),
            )),
      ),
    );
  }
}
