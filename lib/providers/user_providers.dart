import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gpay_clone/models/user_model.dart' as model;
import 'package:gpay_clone/services/firestore_methods.dart';

class UserProvider with ChangeNotifier {
  model.User _user = model.User.empty();
  final FireStoreMethods _fireStoreMethods = FireStoreMethods();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  model.User get getUser => _user;

  Future<void> refreshUser() async {
    model.User user =
        await _fireStoreMethods.getUserDetails(_auth.currentUser!.uid);
    _user = user;
    notifyListeners();
  }
}
