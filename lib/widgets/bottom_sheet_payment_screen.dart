import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../resources/colors.dart';

class BottomSheetPaymentScreen extends StatelessWidget {
  final String amount;
  final bool isLoading;
  final Future<void> Function() onPressedPayButton;
  const BottomSheetPaymentScreen(
      {super.key,
      required this.amount,
      required this.isLoading,
      required this.onPressedPayButton});

  @override
  Widget build(BuildContext context) {
    double fullScreenWidth = MediaQuery.of(context).size.width;
    double fullScreenHeight = MediaQuery.of(context).size.height;

    return Container(
      height: 200,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1), // shadow color
            spreadRadius: 5, // spread radius
            blurRadius: 7, // blur radius
            offset: const Offset(0, 3), // changes position of shadow
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Choose account to pay with',
                style: TextStyle(fontFamily: 'Product Sans', fontSize: 16),
              )),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: ListTile(
              leading: SizedBox(
                  width: 50,
                  height: 50,
                  child: SvgPicture.asset('assets/images/cred.svg')),
              title: const Text(
                'CRED Bank ••••6969',
                style: TextStyle(fontFamily: 'Product Sans'),
              ),
              subtitle: const Text(
                'Savings account',
                style: TextStyle(fontFamily: 'Product Sans'),
              ),
              trailing: const Icon(Icons.keyboard_arrow_down_outlined),
            ),
          ),
          SizedBox(
            width: fullScreenWidth * 0.85,
            height: fullScreenHeight * 0.05,
            child: ElevatedButton(
              onPressed: () async {
                Navigator.pop(context);
                await onPressedPayButton();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: blueButtonColor,
                shape: RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.circular(20), // Button border radius
                ),
              ),
              child: Text(
                'Pay ₹$amount',
                style: TextStyle(
                    fontWeight: FontWeight.bold, fontFamily: 'Product Sans'),
              ),
            ),
          ),
          // ElevatedButton(
          //   child: const Text('Close BottomSheet'),
          //   onPressed: () => Navigator.pop(context),
          // ),
        ],
      ),
    );
  }
}
