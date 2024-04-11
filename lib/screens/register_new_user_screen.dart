import 'dart:math';

import 'package:flutter/material.dart';
import 'package:gpay_clone/screens/scanner_screen.dart';
import 'package:gpay_clone/screens/sign_in_screen.dart';

import '../resources/utils.dart';
import '../services/firebase_auth_mehtods.dart';

class RegisterNewUserScreen extends StatelessWidget {
  final String scanID;
  RegisterNewUserScreen({super.key, required this.scanID});
  final TextEditingController _bankingNameController = TextEditingController();
  final TextEditingController _payingNameController = TextEditingController();
  final TextEditingController _upiIDController = TextEditingController();

  Future<void> signUpUser(String name, String upiID, String scanID,
      String payingName, BuildContext context) async {
    Random random = Random();
    int randomInt = random.nextInt(999);

    String email = generateRandomEmail();
    String password = "test123";
    await FirebaseAuthMehthods().signUpUser(
        email, password, name, upiID, "Register Screen", payingName,
        scanID: scanID);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text("REGSITER USER SCREEN"),
            Padding(
              padding: EdgeInsets.all(8.0),
              child: TextField(
                controller: _bankingNameController,
                decoration: const InputDecoration(
                    hintText: "Banking Name", border: OutlineInputBorder()),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(8.0),
              child: TextField(
                controller: _payingNameController,
                decoration: const InputDecoration(
                    hintText: "Paying Name", border: OutlineInputBorder()),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(8.0),
              child: TextField(
                controller: _upiIDController,
                decoration: const InputDecoration(
                    hintText: "UPI ID", border: OutlineInputBorder()),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(8.0),
              child: TextField(
                readOnly: true,
                controller: TextEditingController(text: scanID),
                decoration: const InputDecoration(
                    hintText: "ScanID", border: OutlineInputBorder()),
              ),
            ),
            ElevatedButton(
                onPressed: () async {
                  await signUpUser(
                      _bankingNameController.text,
                      _upiIDController.text,
                      scanID,
                      _payingNameController.text,
                      context);
                  await FirebaseAuthMehthods().logOut();
                  // ignore: use_build_context_synchronously
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (context) => SignInScreen()),
                      (route) => false);
                },
                child: const Text('Register'))
          ],
        ),
      ),
    );
  }
}
