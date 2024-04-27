import 'package:flutter/material.dart';

import '../resources/colors.dart';
import '/resources/colors.dart' as colors;

class RecentPeopleIcon extends StatelessWidget {
  final String name;
  final double width;
  final double height;
  final double radius;
  final Color backgroundColor;
  final bool isArrow;
  const RecentPeopleIcon(
      {super.key,
      required this.name,
      required this.width,
      required this.height,
      required this.radius,
      required this.backgroundColor,
      required this.isArrow});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: Column(
        children: [
          CircleAvatar(
            backgroundColor: iconBorderColor,
            radius: radius + 1,
            child: CircleAvatar(
              radius: radius,
              backgroundColor: (isArrow) ? Colors.white : backgroundColor,
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: (isArrow)
                    ? const Icon(
                        Icons.keyboard_arrow_down_outlined,
                        color: primaryColor,
                      )
                    : Text(
                        name.substring(0, 1),
                        style: const TextStyle(
                            fontSize: 27, color: colors.backgroundColor),
                      ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              name,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontFamily: 'Product Sans'),
            ),
          ),
        ],
      ),
    );
  }
}
