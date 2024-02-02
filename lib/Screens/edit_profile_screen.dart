import 'dart:convert';
import 'dart:io';
import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart' as cloud_firestore;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'login_screen.dart';


class EditProfileScreen extends StatelessWidget {
  EditProfileScreen({Key? key});

  TextEditingController newPasswordKeyController = TextEditingController();
  TextEditingController currentPasswordKeyController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.arrow_back_ios_rounded,
            color: Colors.green,
            size: 30,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () async {
              bool confirmLogout =
                  await showLogoutConfirmationDialog(context) ?? false;
              if (confirmLogout) {
                await FirebaseAuth.instance.signOut();
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => LoginScreen()),
                );
                print(FirebaseAuth.instance.currentUser.toString());
              }
            },
            icon: const Icon(
              Icons.exit_to_app_outlined,
              color: Colors.green,
              size: 30,
            ),
          ),
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "Change Password",
            style: TextStyle(
              fontSize: 24,
            ),
          ),
          SizedBox(
            height: 30,
          ),
          Padding(
            padding: const EdgeInsets.all(10),
            child: TextFormField(
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: (value) => value!.length < 3
                  ? 'Please enter the current password'
                  : null,
              textInputAction: TextInputAction.next,
              style: const TextStyle(color: Colors.black),
              controller: currentPasswordKeyController,
              cursorColor: Theme.of(context).canvasColor,
              obscureText: true,
              decoration: const InputDecoration(
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10.0))),
                filled: true,
                fillColor: Colors.lightGreenAccent,
                icon: Icon(
                  Icons.lock,
                  size: 35,
                ),
                labelText: 'Current Password',
                labelStyle: TextStyle(color: Colors.black87),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10),
            child: TextFormField(
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: (value) => value!.length < 6
                  ? 'Please enter at least 6 characters'
                  : null,
              textInputAction: TextInputAction.next,
              style: const TextStyle(color: Colors.black),
              controller: newPasswordKeyController,
              cursorColor: Theme.of(context).canvasColor,
              obscureText: true,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10.0))),
                filled: true,
                fillColor: Colors.lightGreenAccent,
                icon: const Icon(
                  Icons.lock,
                  size: 35,
                ),
                labelText: 'New Password',
                labelStyle: TextStyle(color: Colors.black87),
              ),
            ),
          ),
          SizedBox(
            height: 30,
          ),
          SizedBox(
            width: 200,
            height: 40,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
              onPressed: () async {
                try {
                  AuthCredential credential = EmailAuthProvider.credential(
                    email: FirebaseAuth.instance.currentUser!.email!,
                    password: currentPasswordKeyController.text,
                  );
                  await FirebaseAuth.instance.currentUser!
                      .reauthenticateWithCredential(credential);

                  await FirebaseAuth.instance.currentUser!
                      .updatePassword(newPasswordKeyController.text);

                  await showSuccessDialog(context);

                  await FirebaseAuth.instance.signOut();
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => LoginScreen()),
                  );
                } catch (e) {
                  print("Error updating password: $e");
                }
              },
              child: const Text(
                'Update',
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
            ),
          ),
        ],
      ),
    );
  }
  Future<bool?> showLogoutConfirmationDialog(BuildContext context) async {
    return await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.green,
          title: Text('Confirm Logout', style: TextStyle(color: Colors.white),),
          content: Text('Are you sure you want to log out?', style: TextStyle(color: Colors.white)),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false); // Cancel logout
              },
              child: Text('Cancel', style: TextStyle(color: Colors.white)),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(true); // Confirm logout
              },
              child: Text('Logout', style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }
  Future<void> showSuccessDialog(BuildContext context) async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Password Updated'),
          content: Text('Your password has been updated successfully.'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }
}
