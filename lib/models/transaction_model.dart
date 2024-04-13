// ignore_for_file: non_constant_identifier_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class TransactionModel {
  final String amount;
  final String sender_id;
  final String reciever_id;
  final String time;
  final String name;
  String uid = "";
  TransactionModel({
    required this.amount,
    required this.sender_id,
    required this.reciever_id,
    required this.time,
    required this.name,
    this.uid = "",
  });

  // Factory constructor to create a TransactionModel instance from a map
  factory TransactionModel.fromJson(Map<String, dynamic> json) {
    return TransactionModel(
        amount: json['amount'] ?? '',
        sender_id: json['sender_id'] ?? '',
        reciever_id: json['reciever_id'] ?? '',
        time: json['time'] ?? '',
        name: json['name'] ?? '2023-12-21 00:29:02.190635');
  }

  // Method to convert a TransactionModel instance to a map
  Map<String, dynamic> toJson() {
    return {
      'amount': amount,
      'sender_id': sender_id,
      'reciever_id': reciever_id,
      'time': time,
      'name': name
    };
  }

  factory TransactionModel.fromSnapshot(DocumentSnapshot snapshot) {
    Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
    // String time = "";

    return TransactionModel(
        amount: data['amount'] ?? '',
        sender_id: data['sender_id'] ?? '',
        reciever_id: data['reciever_id'] ?? '',
        time: data['time'] ?? '',
        name: data['name'] ?? '',
        uid: snapshot.id.toString());
  }
}
