import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:income_insight/wrapper.dart';

import 'login_screen.dart';


class EditProfileScreen extends StatelessWidget {
  EditProfileScreen({Key? key});

  TextEditingController newPasswordKeyController = TextEditingController();
  TextEditingController currentPasswordKeyController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Wrapper(
      child: Scaffold(
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
                    MaterialPageRoute(builder: (context) => const LoginScreen()),
                  );
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
            const Text(
              "Change Password",
              style: TextStyle(
                fontSize: 24,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10, left: 30, right: 30),
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
                decoration:  InputDecoration(
                  focusedBorder: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(10.0),
                    ),
                    borderSide: BorderSide(
                      color: Colors.yellow,
                    ),
                  ),
                  border: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10.0))),
                  filled: true,
                  fillColor: Colors.green[200],
                  icon: const Icon(
                    Icons.lock,
                    size: 35,
                  ),
                  labelText: 'Current Password',
                  labelStyle: const TextStyle(color: Colors.black87),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10, left: 30, right: 30),
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
                decoration:  InputDecoration(
                  focusedBorder: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(10.0),
                    ),
                    borderSide: BorderSide(
                      color: Colors.yellow,
                    ),
                  ),
                  border: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10.0))),
                  filled: true,
                  fillColor: Colors.green[200],
                  icon: const Icon(
                    Icons.lock,
                    size: 35,
                  ),
                  labelText: 'New Password',
                  labelStyle: const TextStyle(color: Colors.black87),
                ),
              ),
            ),
            const SizedBox(
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
                      MaterialPageRoute(builder: (context) => const LoginScreen()),
                    );
                  } catch (e) {
                    if (kDebugMode) {
                      print("Error updating password: $e");
                    }
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
      ),
    );
  }
  Future<bool?> showLogoutConfirmationDialog(BuildContext context) async {
    return await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.green,
          title: const Text('Confirm Logout', style: TextStyle(color: Colors.white),),
          content: const Text('Are you sure you want to log out?', style: TextStyle(color: Colors.white)),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false); // Cancel logout
              },
              child: const Text('Cancel', style: TextStyle(color: Colors.white)),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(true); // Confirm logout
              },
              child: const Text('Logout', style: TextStyle(color: Colors.white)),
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
          title: const Text('Password Updated'),
          content: const Text('Your password has been updated successfully.'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }
}
