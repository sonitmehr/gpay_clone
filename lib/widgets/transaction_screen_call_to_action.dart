import 'package:flutter/material.dart';

import '../resources/colors.dart';

class TransactionScreenCallToAction extends StatelessWidget {
  final void Function() onPressed;
  final String text;

  const TransactionScreenCallToAction(
      {super.key, required this.onPressed, required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ElevatedButton(
        onPressed: () => onPressed(),
        child: Text(text),
        style: ElevatedButton.styleFrom(
          backgroundColor: blueButtonColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20), // Button border radius
          ),
        ),
      ),
    );
  }
}
