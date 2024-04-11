import 'package:flutter/material.dart';

class TransactionDetailsCard extends StatelessWidget {
  final String amount;
  final String time;

  const TransactionDetailsCard({
    super.key,
    required this.amount,
    required this.time,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 100,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListTile(
          tileColor: Colors.red,
          title: Text(amount),
          subtitle: Text(time),
        ),
      ),
    );
  }
}
