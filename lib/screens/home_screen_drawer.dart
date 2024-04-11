// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:gpay_clone/screens/scanner_screen.dart';

import '../main.dart';
import '../services/firebase_auth_mehtods.dart';
import 'custom_payment_fields_page.dart';

class HomeScreenDrawer extends StatelessWidget {
  const HomeScreenDrawer({super.key});

  Future<void> logOut(BuildContext context) async {
    await FirebaseAuthMehthods().logOut();
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const MainApp()),
        (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.blue,
            ),
            child: Text(
              'Drawer Header',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
              ),
            ),
          ),
          ListTile(
            title: const Text('Register New User'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ScanPage(
                            readQr: true,
                          )));
            },
          ),
          ListTile(
            title: const Text('Edit User'),
            onTap: () {
              // Handle item tap
              Navigator.pop(context); // Close the drawer
            },
          ),
          ListTile(
            title: const Row(
              children: [
                Text('Sign Out'),
                Icon(Icons.exit_to_app),
              ],
            ),
            onTap: () async => await logOut(context),
          ),
          ListTile(
              title: const Text('Custom'),
              onTap: () {
                // Navigator.pop(context);
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => CustomPaymentFieldsPage()));
              }),
        ],
      ),
    );
  }
}
