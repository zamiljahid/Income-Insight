import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'login_screen.dart';

class EditProfileScreen extends StatelessWidget {
  const EditProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading:IconButton(
          onPressed: (){
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back_ios_rounded,color: Colors.green,size: 30,),
        ),
        actions: [
          IconButton(
            onPressed: (){
              FirebaseAuth.instance.signOut();
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => LoginScreen()),
              );
              print(FirebaseAuth.instance.currentUser.toString());
            },
            icon: const Icon(Icons.exit_to_app_outlined,color: Colors.green,size: 30,),
          ),
        ],
      ),
      body: const Center(
        child: Text("Edit profile"),
      ),
    );
  }
}
