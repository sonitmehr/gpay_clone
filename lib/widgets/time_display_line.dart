import 'package:flutter/material.dart';

class TimeDisplayLine extends StatelessWidget {
  final String time;
  const TimeDisplayLine({super.key, required this.time});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 24.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(
              width: 140,
              child: Divider(
                color: Colors.black,
              )), // Divider on the left
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Text(
              time,
              style: const TextStyle(fontSize: 16, fontFamily: 'Product Sans'),
            ),
          ),
          const SizedBox(
              width: 140,
              child: Divider(
                color: Colors.black,
              )),
        ],
      ),
    );
  }
}
