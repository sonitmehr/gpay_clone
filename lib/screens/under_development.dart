import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gpay_clone/models/transaction_model.dart';
import 'package:gpay_clone/services/firestore_methods.dart';

class UnderDevelopmentScreen extends StatefulWidget {
  const UnderDevelopmentScreen({super.key});

  @override
  State<UnderDevelopmentScreen> createState() => _UnderDevelopmentScreenState();
}

class _UnderDevelopmentScreenState extends State<UnderDevelopmentScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.construction,
              size: 30,
            ),
            Text(
              'This page is under development',
              style: GoogleFonts.notoSansKhojki(
                textStyle: const TextStyle(
                  fontSize: 17, // Example font size
                  fontWeight: FontWeight.w400, // Example font weight
                ),
              ),
            ),
            ElevatedButton(
                onPressed: () async {
                  setState(() {
                    isLoading = true;
                  });
                  List<String> transactions = [];
                  Map<String, String> transactionsMap = {};

                  QuerySnapshot snapshot = await FirebaseFirestore.instance
                      .collection('users')
                      .doc('test@upi')
                      .collection('transaction_history')
                      .get();

                  snapshot.docs.forEach((element) {
                    if (element.id != "ignore_this_collection") {
                      transactionsMap
                          .addAll({element.id: element['reciever_id']});
                    }
                  });
                  Map<String, List<String>> map = {};

                  transactionsMap.forEach((key, value) {
                    if (map.containsKey(value) == false) {
                      map.addAll({value: []});
                    }
                    map[value]!.add(key);
                  });
                  map.forEach((key, transactions) async {
                    List<TransactionModel> transactionModelList = [];

                    for (int i = 0; i < transactions.length; i++) {
                      TransactionModel _transactionModel =
                          await FireStoreMethods()
                              .getTransactionFromTransactionID(transactions[i]);
                      transactionModelList.add(_transactionModel);
                    }
                    transactionModelList
                        .sort((a, b) => a.time.compareTo(b.time));
                    int totalLength = transactionModelList.length;
                    int pageNo = 1;
                    int entries = 0;
                    transactionModelList.forEach((element) {
                      if (entries == 5) {
                        pageNo++;
                        entries = 0;
                      }
                      FirebaseFirestore.instance
                          .collection('users')
                          .doc('test@upi')
                          .collection('transaction_history_new')
                          .doc(element.reciever_id)
                          .collection(pageNo.toString())
                          .doc(element.uid)
                          .set(element.toJson());

                      entries++;
                    });
                    FirebaseFirestore.instance
                        .collection('users')
                        .doc('test@upi')
                        .collection('transaction_history_new')
                        .doc(key)
                        .set({
                      "total_pages": pageNo,
                      "total_entries": totalLength,
                      "next_entry_page":
                          (totalLength % 5 == 0) ? pageNo + 1 : pageNo
                    });
                  });

                  setState(() {
                    isLoading = false;
                  });
                },
                child: (isLoading)
                    ? CircularProgressIndicator(
                        color: Colors.white,
                      )
                    : Text('Send Query'))
          ],
        ),
      ),
    );
  }
}
