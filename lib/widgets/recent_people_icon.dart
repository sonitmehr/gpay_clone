import 'package:flutter/material.dart';

import '/resources/colors.dart' as colors;

class RecentPeopleIcon extends StatelessWidget {
  final String name;
  final double width;
  final double height;
  final double radius;
  final Color backgroundColor;
  const RecentPeopleIcon({
    super.key,
    required this.name,
    required this.width,
    required this.height,
    required this.radius,
    required this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SizedBox(
        width: width,
        height: height,
        child: Column(
          children: [
            CircleAvatar(
              radius: radius,
              backgroundColor: backgroundColor,
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  name.substring(0, 1),
                  style: const TextStyle(
                      fontSize: 27, color: colors.backgroundColor),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                name,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(fontFamily: 'Product Sans'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
