// ignore_for_file: non_constant_identifier_names

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:gpay_clone/models/user_model.dart';
import 'package:gpay_clone/providers/user_providers.dart';
import 'package:gpay_clone/resources/utils.dart';
import 'package:gpay_clone/screens/payment_screen.dart';
import 'package:gpay_clone/screens/under_development.dart';
import 'package:gpay_clone/services/firestore_methods.dart';
import 'package:gpay_clone/widgets/app_bar_transaction_details.dart';
import 'package:gpay_clone/widgets/time_display_line.dart';
import 'package:gpay_clone/widgets/transaction_details_card.dart';
import 'package:gpay_clone/widgets/transaction_screen_call_to_action.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../models/transaction_model.dart';
import '../resources/colors.dart';

class TransactionDetails extends StatefulWidget {
  final String sender_id;
  final String reciever_id;
  final String reciever_hex_color;
  final String reciever_name;
  const TransactionDetails({
    super.key,
    required this.sender_id,
    required this.reciever_id,
    required this.reciever_hex_color,
    required this.reciever_name,
  });

  @override
  State<TransactionDetails> createState() => _TransactionDetailsState();
}

class _TransactionDetailsState extends State<TransactionDetails> {
  bool isLoading = true;
  bool isMore = true;
  bool loadedTotalPages = false;
  bool loadMoreTransactions = true;
  double totalTransactionAmount = 0;
  int numberOfDays = 0;
  int pageNo = 1;
  List<TransactionModel> transactionDetails = [];
  final ScrollController _scrollController = ScrollController();
  double previousScrollPosition = 0;
  Future<void> _getTransactionDetails() async {
    List<String> transactions = await FireStoreMethods()
        .getTransactionDetailsHistory(widget.sender_id, widget.reciever_id);
    for (var element in transactions) {
      TransactionModel transactionDetail =
          await FireStoreMethods().getTransactionFromTransactionID(element);
      transactionDetails.add(transactionDetail);
      totalTransactionAmount += toDouble(transactionDetail.amount);
    }
    transactionDetails.sort((a, b) => b.time.compareTo(a.time));
    addTimeDetails(transactionDetails);
    numberOfDays = getNumberOfDays(transactionDetails);
    setState(() {
      isLoading = false;
    });

    Future.delayed(const Duration(seconds: 1), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: Duration(seconds: 2),
          curve: Curves.fastOutSlowIn,
        );
      }
    });
  }

  Future<void> _getTransactionDetailsNew() async {
    if (loadMoreTransactions == false) return;
    List<String> firstTransactions = [];
    setState(() {
      isMore = true;
    });
    if (loadedTotalPages == false) {
      pageNo = await FireStoreMethods()
          .loadTotalPages(widget.sender_id, widget.reciever_id);
      firstTransactions = await FireStoreMethods()
          .getTransactionDetailsHistoryPageNo(
              widget.sender_id, widget.reciever_id, pageNo);
      pageNo--;
      loadedTotalPages = true;
    }
    List<String> transactions = await FireStoreMethods()
        .getTransactionDetailsHistoryPageNo(
            widget.sender_id, widget.reciever_id, pageNo);
    transactions.addAll(firstTransactions);
    if (transactions.isEmpty) {
      setState(() {
        isMore = false;
      });
      return;
    }
    List<TransactionModel> tempTransactionDetails = [];
    for (var element in transactions) {
      TransactionModel transactionDetail =
          await FireStoreMethods().getTransactionFromTransactionID(element);
      tempTransactionDetails.add(transactionDetail);
      totalTransactionAmount += toDouble(transactionDetail.amount);
    }

    tempTransactionDetails.sort((a, b) => b.time.compareTo(a.time));
    if (_scrollController.hasClients) {
      previousScrollPosition = _scrollController.offset;
    } else {
      previousScrollPosition = 300;
    }
    transactionDetails.addAll(tempTransactionDetails);
    addTimeDetails(transactionDetails);
    numberOfDays = getNumberOfDays(transactionDetails);

    setState(() {
      isLoading = false;
    });
    Future.delayed(const Duration(milliseconds: 500), () {
      if (_scrollController.hasClients) {
        _scrollDown(400);
      }
    });
  }

  Future<void> loadFullTransactions() async {
    loadMoreTransactions = false;
    isMore = false;
    setState(() {
      transactionDetails.clear();
      isLoading = true;
    });
    await _getTransactionDetails();
  }

  void addTimeDetails(List<TransactionModel> transactionDetails) {
    if (transactionDetails.isEmpty) return;
    String prevTime = transactionDetails[0].timeStore;
    DateTime transactionTime = DateTime.parse(prevTime);
    prevTime = DateFormat('MMM dd').format(transactionTime);
    for (int i = 1; i < transactionDetails.length; i++) {
      String currTime = transactionDetails[i].timeStore;
      if (transactionDetails[i].isTime == true) {
        transactionDetails.removeAt(i);
        continue;
      }
      transactionTime = DateTime.parse(currTime);
      currTime = DateFormat('MMM dd').format(transactionTime);

      if (currTime != prevTime) {
        TransactionModel timeModel = TransactionModel(
            amount: "0",
            sender_id: "",
            reciever_id: "",
            time: prevTime,
            name: "",
            isTime: true);
        transactionDetails.insert(i, timeModel);
      }

      prevTime = currTime;
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _scrollController.addListener(() {
      if (_scrollController.position.minScrollExtent ==
          _scrollController.offset) {
        // _getTransactionDetails();
        pageNo--;
        _getTransactionDetailsNew();
      }
    });
    // _getTransactionDetails();
    _getTransactionDetailsNew();
  }

  @override
  Widget build(BuildContext context) {
    User user = Provider.of<UserProvider>(context).getUser;

    return Scaffold(
      persistentFooterButtons: [
        SizedBox(
          height: 50,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TransactionScreenCallToAction(
                  onPressed: () => onPressPay(), text: "Pay"),
              TransactionScreenCallToAction(
                  onPressed: () => onPressRequest(), text: "Request"),
            ],
          ),
        ),
      ],
      appBar: AppBarTransactionDetails(
        duration: numberOfDays.toString(),
        total: totalTransactionAmount.toStringAsFixed(2),
        name: widget.reciever_name,
        hexColor: widget.reciever_hex_color,
        loadFullTransactions: () async => await loadFullTransactions(),
      ),
      body: (isLoading)
          ? const Center(
              child: CircularProgressIndicator(
              color: primaryColor,
            ))
          : Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    controller: _scrollController,
                    child: ListView.builder(
                        shrinkWrap: true,
                        reverse: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: (isMore)
                            ? transactionDetails.length + 1
                            : transactionDetails.length,
                        itemBuilder: (context, index) {
                          if (index < transactionDetails.length) {
                            TransactionModel transactionDetail =
                                transactionDetails[index];
                            if (transactionDetail.isTime) {
                              return TimeDisplayLine(
                                  time: transactionDetail.time);
                            }
                            return TransactionDetailsCard(
                              amount: transactionDetail.amount,
                              time: transactionDetail.time,
                              name: widget.reciever_name,
                              recieverID: transactionDetail.reciever_id,
                              userID: user.upiID,
                            );
                          }

                          // ignore: prefer_const_constructors
                          return Padding(
                              padding: const EdgeInsets.all(16),
                              child: const Center(
                                  child: CircularProgressIndicator(
                                color: primaryColor,
                              )));
                        }),
                  ),
                  // child: ListView.builder(
                  //     controller: _scrollController,
                  //     itemCount: (isMore)
                  //         ? transactionDetails.length + 1
                  //         : transactionDetails.length,
                  //     itemBuilder: (context, index) {
                  //       if (index < transactionDetails.length) {
                  //         TransactionModel transactionDetail =
                  //             transactionDetails[index];
                  //         return TransactionDetailsCard(
                  //             amount: transactionDetail.amount,
                  //             time: transactionDetail.time);
                  //       }

                  //       // ignore: prefer_const_constructors
                  //       return Padding(
                  //           padding: EdgeInsets.all(16),
                  //           child: Center(child: CircularProgressIndicator()));
                  //     }),
                ),
              ],
            ),
    );
  }

  void _scrollDown(double value) {
    _scrollController.jumpTo(value);

    // _scrollController.animateTo(
    //   _scrollController.position.maxScrollExtent,
    //   duration: Duration(seconds: 2),
    //   curve: Curves.fastOutSlowIn,
    // );
  }

  int getNumberOfDays(List<TransactionModel> transactionDetails) {
    if (transactionDetails.length > 2) {
      DateTime firstTime = stringToDateTime(transactionDetails.first.time);
      DateTime lastTime = stringToDateTime(transactionDetails.last.time);

      Duration difference = lastTime.difference(firstTime);
      return max(1, difference.inDays);
    }
    return 2;
  }

  void onPressPay() {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => PaymentScreen(upiID: widget.reciever_id)));
  }

  void onPressRequest() {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => const UnderDevelopmentScreen()));
  }
}
