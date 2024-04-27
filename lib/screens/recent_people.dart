import 'package:flutter/material.dart';
import 'package:gpay_clone/resources/utils.dart';
import 'package:gpay_clone/screens/transaction_details.dart';
import 'package:provider/provider.dart';

import '../providers/user_providers.dart';
import '../widgets/recent_people_icon.dart';
import '../models/user_model.dart' as model;

class RecentPeople extends StatelessWidget {
  final bool isExpanded;
  const RecentPeople({super.key, required this.isExpanded});

  @override
  Widget build(BuildContext context) {
    model.User user = Provider.of<UserProvider>(context).getUser;
    return GridView.builder(
      scrollDirection: Axis.vertical,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4, // 4 items per row
      ),
      itemCount: user.recentPeopleList.length,
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => TransactionDetails(
                  sender_id: user.uid,
                  reciever_id: user.recentPeopleList[index].uid,
                  reciever_hex_color: user.recentPeopleList[index].hexColor,
                  reciever_name: user.recentPeopleList[index].name,
                ),
              ),
            );
          },
          child: RecentPeopleIcon(
            backgroundColor: hexToColor(user.recentPeopleList[index].hexColor),
            name: user.recentPeopleList[index].name,
            radius: 30,
            width: 90,
            height: 100,
            isArrow: false,
          ),
        );
      },
    );
  }
}
