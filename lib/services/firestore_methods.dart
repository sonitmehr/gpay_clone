// ignore_for_file: non_constant_identifier_names, avoid_function_literals_in_foreach_calls

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gpay_clone/models/transaction_model.dart';
import 'package:gpay_clone/models/user_model.dart' as model;
import 'package:gpay_clone/resources/constants.dart';

import '../resources/utils.dart';

class FireStoreMethods {
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  Future<model.User> getUserDetails(String uid) async {
    DocumentSnapshot firebaseIDSnapShot = await _firebaseFirestore
        .collection("firebase_link_user")
        .doc(uid)
        .get();
    String upiID = firebaseIDSnapShot['upiID'];
    DocumentReference userDoc =
        _firebaseFirestore.collection("users").doc(upiID);
    DocumentSnapshot userDocSnap = await userDoc.get();
    QuerySnapshot recentPeopleSnap =
        await userDoc.collection("recent_people_list").get();
    return await model.User.fromSnapshot(userDocSnap, recentPeopleSnap);
  }

  Future<model.User> getUserDetailsFromUpiID(String upiID) async {
    DocumentReference userDoc =
        _firebaseFirestore.collection("users").doc(upiID);
    DocumentSnapshot userDocSnap = await userDoc.get();
    QuerySnapshot recentPeopleSnap =
        await userDoc.collection("recent_people_list").get();
    return await model.User.fromSnapshot(userDocSnap, recentPeopleSnap);
  }

  Future<bool> addTransactionDetails(String sender_id, String reciever_id,
      String amount, String bankingName, String hexColor) async {
    String time = DateTime.now().toString();
    String name = bankingName.substring(7);
    DocumentReference recieverCollection =
        _firebaseFirestore.collection("users").doc(reciever_id);

    DocumentSnapshot receiverCollectionSnapshot =
        await recieverCollection.get();

    if (!receiverCollectionSnapshot.exists || sender_id == reciever_id) {
      return false;
    }
    String receiverProfileColor = receiverCollectionSnapshot['hexColor'];
    String recieverName = receiverCollectionSnapshot['name'];
    TransactionModel transactionModel = TransactionModel(
        amount: amount,
        sender_id: sender_id,
        reciever_id: reciever_id,
        time: time,
        name: name);
    Map<String, dynamic> transactionMap = transactionModel.toJson();

    DocumentReference transaction =
        await _firebaseFirestore.collection('transactions').add(transactionMap);

    String transaction_id = transaction.id;

    DocumentReference senderCollection =
        _firebaseFirestore.collection("users").doc(sender_id);

    DocumentReference senderRecentPeopleCollection =
        senderCollection.collection("recent_people_list").doc(reciever_id);
    DocumentSnapshot senderRecentPeopleSnapshot =
        await senderRecentPeopleCollection.get();
    String currTime = DateTime.now().toString();
    Map<String, dynamic> updateQuery = {"last_transaction_time": currTime};
    if (senderRecentPeopleSnapshot.exists) {
      senderRecentPeopleCollection.update(updateQuery);
    } else {
      senderRecentPeopleCollection.set(updateQuery);
    }
    DocumentReference receiverRecentPeopleCollection =
        senderCollection.collection("recent_people_list").doc(reciever_id);
    DocumentSnapshot receiverRecentPeopleSnapshot =
        await senderRecentPeopleCollection.get();

    if (receiverRecentPeopleSnapshot.exists) {
      receiverRecentPeopleCollection.update(updateQuery);
    } else {
      receiverRecentPeopleCollection.set(updateQuery);
    }
    transactionMap['hexColor'] = receiverProfileColor;
    transactionMap['name'] = recieverName;
    await senderCollection
        .collection("transaction_history")
        .doc(transaction_id)
        .set(transactionMap);
    transactionMap['hexColor'] = hexColor;
    transactionMap['name'] = bankingName;

    await recieverCollection
        .collection("transaction_history")
        .doc(transaction_id)
        .set(transactionMap);
    await addTransactionDetailsNew(
        sender_id, reciever_id, amount, bankingName, hexColor, transaction_id);

    return true;
  }

  Future<List<String>> getTransactionDetailsHistory(
      String sender_id, String reciever_id) async {
    CollectionReference senderUserDetails = _firebaseFirestore
        .collection("users")
        .doc(sender_id)
        .collection("transaction_history");
    CollectionReference reciverUserDetails = _firebaseFirestore
        .collection("users")
        .doc(reciever_id)
        .collection("transaction_history");
    QuerySnapshot senderTransactionDetails = await senderUserDetails.get();
    QuerySnapshot reciverTransactionDetails = await reciverUserDetails.get();

    Map<String, int> uniqueTransactions = {};

    senderTransactionDetails.docs.forEach((element) {
      if (element.id != "ignore_this_collection") {
        if (uniqueTransactions.containsKey(element.id)) {
          uniqueTransactions[element.id] = uniqueTransactions[element.id]! + 1;
        } else {
          uniqueTransactions[element.id] = 1;
        }
      }
    });

    reciverTransactionDetails.docs.forEach((element) {
      if (element.id != "ignore_this_collection") {
        if (uniqueTransactions.containsKey(element.id)) {
          uniqueTransactions[element.id] = uniqueTransactions[element.id]! + 1;
        } else {
          uniqueTransactions[element.id] = 1;
        }
      }
    });
    List<String> transactions = [];
    uniqueTransactions.forEach((key, value) {
      if (value == 2) {
        transactions.add(key);
      }
    });
    return transactions;
  }

  Future<TransactionModel> getTransactionFromTransactionID(
      String transactionID) async {
    DocumentSnapshot snap = await _firebaseFirestore
        .collection("transactions")
        .doc(transactionID)
        .get();

    return TransactionModel.fromSnapshot(snap);
  }

  Future<List<String>> getTransactionDetailsHistoryPageNo(
      String sender_id, String reciever_id, int pageNo) async {
    CollectionReference senderUserDetails = _firebaseFirestore
        .collection("users")
        .doc(sender_id)
        .collection("transaction_history_new")
        .doc(reciever_id)
        .collection(pageNo.toString());
    CollectionReference reciverUserDetails = _firebaseFirestore
        .collection("users")
        .doc(reciever_id)
        .collection("transaction_history_new");

    QuerySnapshot senderTransactionDetails = await senderUserDetails.get();
    QuerySnapshot reciverTransactionDetails = await reciverUserDetails.get();
    if (senderTransactionDetails.docs.isEmpty) return [];
    List<String> transactions = [];
    senderTransactionDetails.docs.forEach((element) {
      transactions.add(element.id);
    });
    return transactions;
  }

  Future<bool> addTransactionDetailsNew(
      String sender_id,
      String reciever_id,
      String amount,
      String bankingName,
      String hexColor,
      String transaction_id) async {
    String time = DateTime.now().toString();
    String name = bankingName.substring(7);
    DocumentReference senderCollection =
        _firebaseFirestore.collection("users").doc(sender_id);
    DocumentReference recieverCollection =
        _firebaseFirestore.collection("users").doc(reciever_id);

    DocumentSnapshot receiverCollectionSnapshot =
        await recieverCollection.get();

    if (!receiverCollectionSnapshot.exists || sender_id == reciever_id) {
      return false;
    }
    String receiverProfileColor = receiverCollectionSnapshot['hexColor'];
    String recieverName = receiverCollectionSnapshot['name'];
    TransactionModel transactionModel = TransactionModel(
        amount: amount,
        sender_id: sender_id,
        reciever_id: reciever_id,
        time: time,
        name: name);
    Map<String, dynamic> transactionMap = transactionModel.toJson();

    // String transaction_id = transaction.id;

    DocumentSnapshot senderTransactionHistoryNew = await senderCollection
        .collection("transaction_history_new")
        .doc(reciever_id)
        .get();
    DocumentSnapshot recieverTransactionHistoryNew = await recieverCollection
        .collection("transaction_history_new")
        .doc(sender_id)
        .get();
    int nextPage = 1;
    int totalEntriesSenderReciever = 0;
    int totalEntriesRecieverSender = 0;
    int totalPages = 0;
    if (senderTransactionHistoryNew.exists) {
      nextPage = (senderTransactionHistoryNew['next_entry_page']);
      totalEntriesSenderReciever = senderTransactionHistoryNew['total_entries'];
      totalPages = senderTransactionHistoryNew['total_pages'];
    } else {
      nextPage = 1;
      totalPages = 1;
      await initializePageNo(sender_id, reciever_id);
    }
    transactionMap['hexColor'] = receiverProfileColor;
    transactionMap['name'] = recieverName;
    await addTransactionFromSenderToReciever(
        sender_id,
        reciever_id,
        transaction_id,
        nextPage,
        totalEntriesSenderReciever,
        totalPages,
        transactionMap);

    if (recieverTransactionHistoryNew.exists) {
      nextPage = (recieverTransactionHistoryNew['next_entry_page']);
      totalEntriesRecieverSender =
          recieverTransactionHistoryNew['total_entries'];
      totalPages = recieverTransactionHistoryNew['total_pages'];
    } else {
      nextPage = 1;
      totalPages = 1;
      await initializePageNo(reciever_id, sender_id);
    }

    transactionMap['hexColor'] = hexColor;
    transactionMap['name'] = bankingName;
    await addTransactionFromSenderToReciever(
        reciever_id,
        sender_id,
        transaction_id,
        nextPage,
        totalEntriesRecieverSender,
        totalPages,
        transactionMap);
    return true;
  }

  Future<int> loadTotalPages(String sender_id, String receiver_id) async {
    DocumentReference senderUserDetails = _firebaseFirestore
        .collection("users")
        .doc(sender_id)
        .collection("transaction_history_new")
        .doc(receiver_id);

    DocumentSnapshot snapshot = await senderUserDetails.get();
    if (snapshot.exists) {
      return snapshot['total_pages'];
    }
    return 0;
  }

  Future<void> initializePageNo(String sender_id, String receiver_id) async {
    await _firebaseFirestore
        .collection('users')
        .doc(sender_id)
        .collection('transaction_history_new')
        .doc(receiver_id)
        .set({"total_pages": 1, "total_entries": 1, "next_entry_page": 1});
  }

  Future<void> addTransactionFromSenderToReciever(
      String sender_id,
      String reciever_id,
      String transaction_id,
      int next_entry_page,
      int total_entries,
      int total_pages,
      Map<String, dynamic> transactionMap) async {
    DocumentReference recieverTransactionHistory = _firebaseFirestore
        .collection('users')
        .doc(sender_id)
        .collection('transaction_history_new')
        .doc(reciever_id);

    // Add Transaction

    int newEntries = total_entries + 1;

    if (newEntries % 5 == 0) {
      await recieverTransactionHistory.set({
        "next_entry_page": total_pages + 1,
        "total_entries": newEntries,
        "total_pages": total_pages + 1,
      });
      await recieverTransactionHistory
          .collection((total_pages + 1).toString())
          .doc(transaction_id)
          .set(transactionMap);
    } else {
      // Change pageNo
      await recieverTransactionHistory.set({
        "next_entry_page": total_pages,
        "total_entries": newEntries,
        "total_pages": total_pages,
      });
      await recieverTransactionHistory
          .collection((total_pages).toString())
          .doc(transaction_id)
          .set(transactionMap);
    }
  }
}
