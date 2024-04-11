import 'package:flutter/material.dart';
import 'package:gpay_clone/resources/utils.dart';

class AppBarTransactionDetails extends StatelessWidget
    implements PreferredSizeWidget {
  final String name;
  final String hexColor;
  final String total;
  final String duration;
  const AppBarTransactionDetails({
    super.key,
    required this.name,
    required this.hexColor,
    required this.total,
    required this.duration,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(name),
          GestureDetector(onTap: () => _showPopup(context), child: Text(total)),
        ],
      ),
    );
  }

  void _showPopup(BuildContext context) {
    int average = (toDouble(total) / toDouble(duration)).round();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('$total spent in '),
          content: SizedBox(
            height: 50,
            width: 80,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('$duration days at'),
                Text('$average per day'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Close'),
            ),
          ],
        );
      },
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
