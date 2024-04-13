import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gpay_clone/resources/utils.dart';
import 'package:gpay_clone/resources/colors.dart' as colors;

import '../resources/colors.dart';

class AppBarTransactionDetails extends StatelessWidget
    implements PreferredSizeWidget {
  final String name;
  final String hexColor;
  final String total;
  final String duration;
  final Future<void> Function() loadFullTransactions;
  const AppBarTransactionDetails({
    super.key,
    required this.name,
    required this.hexColor,
    required this.total,
    required this.duration,
    required this.loadFullTransactions,
  });

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: appBarTransactionDetails, // transparent status bar
    ));
    double radius = 25;
    return SafeArea(
        child: Container(
      color: appBarTransactionDetails,
      child: Row(
        children: [
          SizedBox(
            width: 60,
            child: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () => Navigator.pop(context),
              color: Colors.black,
            ),
          ),
          SizedBox(
            width: 320,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  width: 250,
                  child: Row(
                    children: [
                      SizedBox(
                        width: 40,
                        child: CircleAvatar(
                          radius: radius + 2,
                          backgroundColor:
                              const Color.fromARGB(0, 189, 192, 190),
                          child: CircleAvatar(
                            radius: radius,
                            backgroundColor: hexToColor(hexColor),
                            child: Text(
                              name.substring(0, 1).toUpperCase(),
                              style: const TextStyle(
                                  fontSize: 20, color: colors.backgroundColor),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 200,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: Text(
                            name,
                            style: const TextStyle(
                                color: Colors.black,
                                fontSize: 17,
                                fontFamily: 'Product-Sans',
                                fontWeight: FontWeight.w500),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                PopupMenuButton<String>(
                  onSelected: (choice) async {
                    switch (choice) {
                      case 'Full History':
                        await loadFullTransactions();
                        break;
                      case 'Total Amount':
                        _showPopup(context);
                        break;
                    }
                  },
                  itemBuilder: (BuildContext context) {
                    return ['Full History', 'Total Amount']
                        .map((String choice) {
                      return PopupMenuItem<String>(
                        value: choice,
                        child: Text(choice),
                      );
                    }).toList();
                  },
                ),
                // GestureDetector(
                //     onTap: () => _showPopup(context),
                //     child: Text(total,
                //         style: const TextStyle(
                //             color: Colors.black,
                //             fontSize: 17,
                //             fontFamily: 'Product-Sans'))),
              ],
            ),
          ),
        ],
      ),
      //
    ));
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
