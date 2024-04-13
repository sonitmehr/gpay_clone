// ignore_for_file: use_build_context_synchronously, non_constant_identifier_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gpay_clone/models/user_model.dart' as model;
import 'package:gpay_clone/screens/payment_successful_screen_wrapper.dart';
import 'package:gpay_clone/services/firestore_methods.dart';
import 'package:gpay_clone/widgets/bottom_sheet_payment_loading.dart';
import 'package:provider/provider.dart';

import '../providers/user_providers.dart';
import '../resources/colors.dart';
import '../resources/utils.dart';
import '../widgets/bottom_sheet_payment_screen.dart';

class PaymentScreen extends StatefulWidget {
  final String upiID;
  final bool isCustomTransaction;
  final String payingName;
  final String bankingName;
  const PaymentScreen({
    super.key,
    required this.upiID,
    this.isCustomTransaction = false,
    this.payingName = "",
    this.bankingName = "",
  });

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  final TextEditingController _payingNameController =
      TextEditingController(text: "S");
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  final TextEditingController _upiIDController = TextEditingController();

  final TextEditingController _bankingNameController = TextEditingController();
  final FocusNode _amountFocus = FocusNode();
  final TextEditingController _amountController = TextEditingController();
  Color receiverColor = Colors.green;
  double multiply = 0.1;
  String recieverIconLetter = "S";
  bool isLoading = false;
  Future<void> _addTransaction(
      String sender_id, String reciever_id, String senderHexColor) async {
    bool check = false;
    if (widget.isCustomTransaction) {
      check = false;
    } else {
      check = await FireStoreMethods().addTransactionDetails(
          sender_id,
          reciever_id,
          _amountController.text,
          _bankingNameController.text,
          senderHexColor);
    }
    if (!check) {
      //TODO : Add into a dummy account to track values.
      await FireStoreMethods().addTransactionDetails(sender_id, "dummy@upi",
          _amountController.text, _bankingNameController.text, senderHexColor);
      // showSnackBar(context, "UPI ID Not Found");
    }
    UserProvider _userProvider = Provider.of(context, listen: false);
    _userProvider.refreshUser();
  }

  Future<void> getRecieverDetails() async {
    DocumentReference userDoc =
        _firebaseFirestore.collection("users").doc(widget.upiID);
    DocumentSnapshot userDocSnap = await userDoc.get();

    // setState(() {
    _upiIDController.text = widget.upiID;
    _payingNameController.text = "Paying ${userDocSnap['paying_name']}";
    _bankingNameController.text = "Banking Name : ${userDocSnap['name']}";
    receiverColor = hexToColor(userDocSnap['hexColor']);
    if (_payingNameController.text.contains("Paytm Merchant") ||
        _payingNameController.text.contains("PhonePe")) {
      receiverColor = hexToColor("#9546c7");
    } else if (_payingNameController.text.contains("Google")) {
      receiverColor = hexToColor("#079494");
    } else {
      receiverColor = hexToColor("#969595");
    }
    recieverIconLetter =
        userDocSnap['paying_name'].substring(0, 1).toUpperCase();
    // });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadDetails();
  }

  @override
  Widget build(BuildContext context) {
    model.User user = Provider.of<UserProvider>(context).getUser;
    print("Hello " + _bankingNameController.text.length.toString());
    double fullScreenWidth = MediaQuery.of(context).size.width;
    double fullScreenHeight = MediaQuery.of(context).size.height;
    double heightOfTextField = 23;
    double amountFieldSize = 55;
    double variableMaxwidth = fullScreenWidth * multiply;

    return Scaffold(
      resizeToAvoidBottomInset: true,
      floatingActionButton: SizedBox(
        height: 50,
        width: 55,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: blueButtonColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12), // Button border radius
            ),
          ),
          onPressed: (allowPayment())
              ? () async => await showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    barrierColor: Colors.transparent,
                    builder: (context) {
                      return BottomSheetPaymentScreen(
                        amount: _amountController.text,
                        isLoading: isLoading,
                        onPressedPayButton: () async =>
                            await onPressedPayButton(user),
                      );
                    },
                  )
              : () => showSnackBar(context, "Enter positive amount"),
          // onPressed: () async => await _addTransaction(
          //     user.uid, _upiIDController.text, user.hexColor),
          child: const Icon(Icons.arrow_forward),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: CircleAvatar(
                backgroundColor: upiIDBorderColor,
                radius: 31.5,
                child: CircleAvatar(
                  radius: 30,
                  backgroundColor: receiverColor,
                  child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        recieverIconLetter,
                        style:
                            const TextStyle(fontSize: 27, color: Colors.white),
                      )),
                ),
              ),
            ),
            SizedBox(
              width: fullScreenWidth * 0.8,
              height: heightOfTextField,
              child: TextField(
                onTapOutside: (event) {
                  FocusManager.instance.primaryFocus?.unfocus();
                },
                enableInteractiveSelection: false,
                focusNode: FocusNode(),
                decoration: const InputDecoration(border: InputBorder.none),
                textAlign: TextAlign.center,
                controller: _payingNameController,
                style: const TextStyle(
                    fontFamily: 'Product Sans',
                    fontSize: 18.5,
                    fontWeight: FontWeight.w300),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 4.0),
                  child: SizedBox(
                    width: fullScreenWidth * 0.05,
                    height: heightOfTextField,
                    child: SvgPicture.asset('assets/images/secure.svg'),
                  ),
                ),
                Text(
                  _bankingNameController.text,
                  style: TextStyle(
                      fontFamily: 'Product Sans',
                      fontSize:
                          _bankingNameController.text.length > 40 ? 10 : 15),
                )
              ],
            ),
            SizedBox(
              height: heightOfTextField,
              width: fullScreenWidth * 0.8,
              child: TextField(
                enableInteractiveSelection: false,
                decoration: const InputDecoration(border: InputBorder.none),
                textAlign: TextAlign.center,
                controller: _upiIDController,
                style:
                    const TextStyle(fontFamily: 'Product Sans', fontSize: 15),
              ),
            ),
            Container(
                // color: Colors.red,
                // constraints: BoxConstraints(
                //   maxWidth: variableMaxwidth,
                //   minWidth: fullScreenWidth * 0.1,
                // ),
                // height: fullScreenHeight * 0.1,
                width: fullScreenWidth * 0.9,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: fullScreenWidth * 0.05,
                      height: 28,
                      child: SvgPicture.asset(
                        'assets/images/rupee.svg',
                        fit: BoxFit.fitHeight,
                      ),
                    ),
                    Container(
                      constraints: BoxConstraints(
                        maxWidth: variableMaxwidth,
                        minWidth: fullScreenWidth * 0.1,
                      ),
                      child: TextFormField(
                        enableInteractiveSelection: false,
                        focusNode: _amountFocus,
                        textAlign: TextAlign.center,
                        textAlignVertical: TextAlignVertical.center,
                        keyboardType: TextInputType.phone,
                        cursorHeight: amountFieldSize,
                        style: TextStyle(
                            fontSize: amountFieldSize,
                            fontFamily: 'Product Sans'),
                        onChanged: (value) {
                          if (value.isEmpty) {
                            setState(() {
                              multiply = 0.1;
                            });
                            return;
                          }
                          setState(() {
                            multiply = 0.1 * value.length;
                          });
                        },
                        decoration: InputDecoration(
                            hintText: "0",
                            contentPadding: const EdgeInsets.only(left: 0),
                            hintStyle: TextStyle(fontSize: amountFieldSize),
                            border: InputBorder.none),
                        controller: _amountController,
                      ),
                    ),
                  ],
                )),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 18),
              decoration: BoxDecoration(
                  color: greyAddNote, borderRadius: BorderRadius.circular(14)),
              child: const Text('Add a note',
                  style: TextStyle(fontFamily: 'Product Sans', fontSize: 15)),
            )
          ],
        ),
      ),
    );
  }

  Future<void> loadDetails() async {
    if (widget.isCustomTransaction == false) {
      await getRecieverDetails();
    } else {
      recieverIconLetter = widget.payingName.substring(0, 1).toUpperCase();
      _payingNameController.text = "Paying ${widget.payingName}";
      _upiIDController.text = widget.bankingName;
      _bankingNameController.text = "Banking Name : ${widget.bankingName}";
    }
    setState(() {});
  }

  bool allowPayment() {
    double val = toDouble(_amountController.text);
    if (val <= 0) return false;
    return true;
  }

  Future<void> onPressedPayButton(model.User user) async {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      barrierColor: Colors.transparent,
      builder: (context) {
        return BottomSheetPaymentLoading(
          amount: _amountController.text,
          name: _payingNameController.text.substring(7),
        );
      },
    );
    await _addTransaction(user.uid, _upiIDController.text, user.hexColor);
    // Future.delayed(const Duration(seconds: 3), () {
    Navigator.pop(context);
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => PaymentSuccessWrapper(
                  amount: _amountController.text,
                  payingName: _payingNameController.text,
                  upiID: _upiIDController.text,
                  bankingName: _bankingNameController.text,
                )));
    // }
    // );
  }
}
