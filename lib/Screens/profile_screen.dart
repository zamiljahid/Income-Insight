import 'package:flutter/material.dart';


import 'edit_profile_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  void settings() {
    // FirebaseAuth.instance.signOut();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        actions:[
          IconButton(
            onPressed: (){
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => EditProfileScreen()),
              );
            },
            icon: const Icon(Icons.settings,color: Colors.green,size: 35,),
          ),
        ],
      ),
      body: Center(
        child: Container(
          width: 200,
          height: 200,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.transparent,
            border: Border.all(
                width: 2,
                color: Colors.green),
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
            child: const CircleAvatar(
              // radius: 35,
                backgroundImage: AssetImage('assets/images/zamil.jpg')),
          ),
        ),
      ),
    );
  }

}
