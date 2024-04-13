import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';

class TransactionDetailsCard extends StatelessWidget {
  final String amount;
  final String time;
  final String name;

  const TransactionDetailsCard({
    super.key,
    required this.amount,
    required this.time,
    required this.name,
  });

  @override
  Widget build(BuildContext context) {
    DateTime transactionTime = DateTime.parse(time);
    String timeInNewFormat = DateFormat('MMM dd').format(transactionTime);
    return Align(
      alignment: Alignment.centerRight,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          padding: const EdgeInsets.all(16.0),
          height: 140,
          width: 230,
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(30),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.6),
                  spreadRadius: 1,
                  blurRadius: 2,
                  offset: const Offset(0, 3),
                ),
                const BoxShadow(
                  color: Colors.white,
                  spreadRadius: 1,
                  offset: Offset(-1, 0),
                ),
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  spreadRadius: 1,
                  blurRadius: 2,
                  offset: const Offset(0.5, 0),
                ),
              ]),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: 200,
                child: Text(
                  'Payment to $name',
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                      fontSize: 16,
                      fontFamily: 'Product-Sans',
                      fontWeight: FontWeight.w500),
                ),
              ),
              Text(
                "₹$amount",
                style:
                    const TextStyle(fontSize: 32, fontFamily: 'Product-Sans'),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      SizedBox(
                        width: 20,
                        height: 14,
                        child: SvgPicture.asset(
                          'assets/images/secure.svg',
                          // fit: BoxFit.fitHeight,
                        ),
                      ),
                      Text(
                        "Paid • $timeInNewFormat",
                        style: const TextStyle(
                            fontSize: 13.5,
                            fontFamily: 'Product-Sans',
                            fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                  const Icon(
                    Icons.arrow_forward_ios,
                    size: 16,
                  )
                ],
              ),
            ],
          ),
        ),

        // child: ListTile(
        //   title: Text(amount),
        //   subtitle: Text(time),
        // ),
      ),
    );
  }
}
