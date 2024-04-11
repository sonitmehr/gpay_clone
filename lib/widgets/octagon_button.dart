import 'package:flutter/material.dart';
import 'dart:math' as math;

class OctagonElevatedButton extends StatelessWidget {
  final VoidCallback onPressed;
  final Widget child;

  const OctagonElevatedButton({
    Key? key,
    required this.onPressed,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        padding: EdgeInsets.all(16.0), // Adjust padding as needed
        shape: RoundedRectangleBorder(
          borderRadius:
              BorderRadius.circular(10.0), // Border radius for elevation effect
        ),
      ),
      child: ClipPath(
        clipper: OctagonClipper(),
        child: Container(
          color: Theme.of(context).primaryColor, // Change color as needed
          child: Padding(
            padding: const EdgeInsets.all(16.0), // Adjust padding as needed
            child: Center(
              child: DefaultTextStyle(
                style: Theme.of(context).textTheme.button!,
                child: child,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class OctagonClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    final double radius = size.width / 2.0;
    final double angle = math.pi / 4.0; // 45 degrees in radians

    path.moveTo(
        radius + radius * math.cos(0.0), radius + radius * math.sin(0.0));

    for (double i = 0; i < 2 * math.pi; i += angle) {
      path.lineTo(radius + radius * math.cos(i), radius + radius * math.sin(i));
    }

    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}
