import 'package:flutter/material.dart';
import '/resources/colors.dart' as colors;

class UserProfileIcon extends StatelessWidget {
  final String name;
  final double radius;
  final Color backgroundColor;
  const UserProfileIcon({
    super.key,
    required this.name,
    required this.radius,
    required this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 60,
      child: CircleAvatar(
        backgroundColor: colors.upiIDBorderColor,
        radius: radius + 1,
        child: CircleAvatar(
          radius: radius,
          backgroundColor: backgroundColor,
          child: FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                name.substring(0, 1).toUpperCase(),
                style: const TextStyle(
                    fontSize: 20, color: colors.backgroundColor),
              )),
        ),
      ),
    );
  }
}
