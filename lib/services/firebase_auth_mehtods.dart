import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:gpay_clone/resources/utils.dart';

class FirebaseAuthMehthods {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  Future<bool> loginUser(String email, String password) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
    } on Exception catch (e) {
      return false;
    }
    return true;
  }

  Future<void> signUpUser(String email, String password, String bankingName,
      String upiID, String createdBy, String payingName,
      {String scanID = ""}) async {
    UserCredential credentials = await _firebaseAuth
        .createUserWithEmailAndPassword(email: email, password: password);
    String uid = credentials.user!.uid;
    await _firebaseFirestore.collection("firebase_link_user").doc(uid).set({
      "upiID": upiID,
      "email": email,
      "password": password,
      "created_by": createdBy
    });
    if (scanID != "") {
      await _firebaseFirestore.collection("scan_id_link").doc(scanID).set({
        "upiID": upiID,
        "email": email,
        "password": password,
        "created_by": createdBy,
      });
    }
    DocumentReference usersDoc =
        _firebaseFirestore.collection("users").doc(upiID);
    await usersDoc.set({
      "uid": uid,
      "email": email,
      "password": password,
      "name": bankingName,
      "paying_name": payingName,
      "upiID": upiID,
      "hexColor": randomHex(),
      "created_by": createdBy
    });
    await usersDoc
        .collection("recent_people_list")
        .doc("ignore_this_collection")
        .set({"last_transaction_time": "2023-12-21 00:29:02.190635"});
    await usersDoc
        .collection("transaction_history")
        .doc("ignore_this_collection")
        .set({"last_transaction_time": "2023-12-21 00:29:02.190635"});
  }

  logOut() async {
    await _firebaseAuth.signOut();
  }
}
