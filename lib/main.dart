import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gpay_clone/providers/user_providers.dart';
import 'package:gpay_clone/screens/home_screen.dart';
import 'package:gpay_clone/screens/sign_in_screen.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    statusBarColor: Colors.transparent, // transparent status bar
  ));
  runApp(const MainApp());
}

// ignore_for_file: prefer_const_constructors
class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [ChangeNotifierProvider(create: (_) => UserProvider())],
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            textTheme: TextTheme(
              bodyLarge: TextStyle(fontFamily: 'OpenSans'),
              bodyMedium: TextStyle(fontFamily: 'OpenSans'),
              bodySmall: TextStyle(fontFamily: 'OpenSans'),
              // Add more text styles as needed
            ),
          ),
          // home: SignInScreen(),
          home: (FirebaseAuth.instance.currentUser == null)
              ? SignInScreen()
              : HomeScreen(),
        ));
  }
}
