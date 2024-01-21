import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:income_insight/Screens/add_transaction_screen.dart';
import 'package:income_insight/Screens/graph_screen.dart';
import 'package:income_insight/Screens/home_screen.dart';
import 'package:income_insight/Screens/profile_screen.dart';
import 'package:income_insight/Screens/search_screen.dart';


class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

final screen = [
  const SearchScreen(),
  const AddTransactionScreen(),
  const HomeScreen(),
  const GraphScreen(),
  const ProfileScreen(),
];


final items = <Widget>[
  const Icon(Icons.search, size: 30, color: Colors.white),
  const Icon(Icons.add, size: 30, color: Colors.white),
  const Icon(Icons.home, size: 30, color: Colors.white,),
  const Icon(Icons.auto_graph, size: 30, color: Colors.white),
  const Icon(Icons.person, size: 30, color: Colors.white),
];

class _DashboardScreenState extends State<DashboardScreen> {
  int index = 2;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: screen[index],
      bottomNavigationBar:  Container(
        height: 75,
        decoration: BoxDecoration(
          color: Colors.lightGreen,
          borderRadius: BorderRadius.only(
              topRight: Radius.circular(30), topLeft: Radius.circular(30)),
        ),
        child:ClipRRect(
        borderRadius: BorderRadius.only(
    topLeft: Radius.circular(30.0),
    topRight: Radius.circular(30.0),
    ),
    child:CurvedNavigationBar(
      index: index ,
      height: 60,
      color: Colors.green.shade600,
      buttonBackgroundColor: Colors.green.shade900,
      backgroundColor: Colors.transparent,
      animationDuration: const Duration(milliseconds: 300),
      items: items,
      onTap: (index) =>setState(() => this.index = index),
    ),)

      ),
    );
  }
}
