// ignore_for_file: non_constant_identifier_names

import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  final String uid;
  final String name;
  final String hexColor;
  final String upiID;
  final List<RecentPeople> recentPeopleList;

  User({
    required this.uid,
    required this.upiID,
    required this.name,
    required this.recentPeopleList,
    required this.hexColor,
  });
  static Future<User> fromSnapshot(DocumentSnapshot snapshot,
      QuerySnapshot recentPeople, String upiID) async {
    String uid = snapshot.id;
    String name = snapshot['name'] ?? '';
    String hexColor = snapshot['hexColor'] ?? '#760e7d';
    List<RecentPeople> recentPeopleList =
        await RecentPeople.fromSnapShot(recentPeople);
    return User(
        uid: uid,
        upiID: upiID,
        name: name,
        recentPeopleList: recentPeopleList,
        hexColor: hexColor);
  }

  factory User.empty() {
    return User(
        uid: '',
        name: 'T',
        recentPeopleList: [],
        hexColor: '#760e7d',
        upiID: "");
  }
}

class RecentPeople {
  final String uid;
  final String name;
  final String lastTransactionTime;
  final String hexColor;

  RecentPeople({
    required this.uid,
    required this.name,
    required this.lastTransactionTime,
    required this.hexColor,
  });

  // Method to convert a RecentPeople instance to a map (JSON)
  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'name': name,
      'last_transaction_time': lastTransactionTime
    };
  }

  static Future<List<RecentPeople>> fromSnapShot(
      QuerySnapshot recentPeople) async {
    List<RecentPeople> recentPeopleList = [];

    List<dynamic> arrayData = recentPeople.docs;

    for (var map in arrayData) {
      String uid = map.id;
      if (uid == "ignore_this_collection") {
        continue;
      }
      String last_transaction_time = map['last_transaction_time'];
      DocumentSnapshot user =
          await FirebaseFirestore.instance.collection('users').doc(uid).get();
      String name = user['name'];
      String hexColor = user['hexColor'] ?? "#760e7d";
      RecentPeople recentPeople = RecentPeople(
          uid: uid,
          name: name,
          lastTransactionTime: last_transaction_time,
          hexColor: hexColor);
      recentPeopleList.add(recentPeople);
    }
    recentPeopleList
        .sort((a, b) => a.lastTransactionTime.compareTo(b.lastTransactionTime));
    return recentPeopleList.reversed.toList();
  }
}
