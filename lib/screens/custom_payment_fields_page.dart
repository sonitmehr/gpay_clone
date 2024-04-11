import 'package:flutter/material.dart';
import 'package:gpay_clone/screens/payment_screen.dart';

class CustomPaymentFieldsPage extends StatelessWidget {
  CustomPaymentFieldsPage({super.key});
  final TextEditingController _payingNameController = TextEditingController();
  final TextEditingController _bankingNameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text("CUSTOM FIELDS"),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: _payingNameController,
                decoration: const InputDecoration(
                    hintText: "Paying Name", border: OutlineInputBorder()),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: _bankingNameController,
                decoration: const InputDecoration(
                    hintText: "Banking Name", border: OutlineInputBorder()),
              ),
            ),
            ElevatedButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => PaymentScreen(
                                upiID: _bankingNameController.text,
                                isCustomTransaction: true,
                                bankingName: _bankingNameController.text,
                                payingName: _payingNameController.text,
                              )));
                },
                child: const Text('Next'))
          ],
        ),
      ),
    );
  }
}
