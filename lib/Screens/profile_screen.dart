import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'edit_profile_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final User? currentUser = FirebaseAuth.instance.currentUser;
  String? empName;
  String? empId;
  String? empPos;
  String? _selectedGender;


  SharedPreferences? _prefs;

  Future<void> initSharedPreferences() async {
    _prefs = await SharedPreferences.getInstance();
  }

  @override
  void initState() {
    load();
    _loadGender();
    super.initState();
  }

  load() async {
    SharedPreferences perfs = await SharedPreferences.getInstance();
    String? emp_name = perfs.getString('emp_name');
    String? emp_id = perfs.getString('emp_id');
    String? emp_pos = perfs.getString('emp_pos');

    if (emp_name != null) {
      setState(() {
        empName = emp_name.toString();
      });
    }
    if (emp_id != null) {
      setState(() {
        empId = emp_id.toString();
      });
    }
    if (emp_pos != null) {
      setState(() {
        empPos = emp_pos.toString();
      });
    }
  }


  Future<void> _loadGender() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _selectedGender = prefs.getString('gender') ?? '';

    if (_selectedGender!.isEmpty) {
      // If gender is not saved, show dialog to select gender
      await _showGenderDialog();
    }
  }

  Future<void> _showGenderDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Select Your Gender'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: const Text('Male'),
                onTap: () {
                  _saveGender('male');
                  Navigator.of(context).pop();
                },
              ),
              ListTile(
                title: const Text('Female'),
                onTap: () {
                  _saveGender('female');
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _saveGender(String gender) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('gender', gender);

    setState(() {
      _selectedGender = gender;
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('P R O F I L E'),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => EditProfileScreen()),
              );
            },
            icon: const Icon(
              Icons.settings,
              color: Colors.green,
              size: 35,
            ),
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [

            Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.transparent,
                border: Border.all(width: 2, color: Colors.green),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF008506).withAlpha(99),
                    blurRadius: 9.0,
                    spreadRadius: 7.0,
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(100),
                child:
                _selectedGender == 'male'
                    ? Lottie.asset('animation/male.json', height: 200)
                    : _selectedGender == 'female'
                    ? Lottie.asset('animation/female.json', height: 200)
                    : Container(),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Text(
              empName.toString(),
              style: const TextStyle(fontSize: 24),
            ),
            const SizedBox(
              height: 15,
            ),
            Text(
              empPos.toString(),
              style: const TextStyle(fontSize: 24),
            ),
            const SizedBox(
              height: 15,
            ),
            Text(
              empId.toString(),
              style: const TextStyle(fontSize: 24),
            ),
          ],
        ),
      ),
    );
  }
}
