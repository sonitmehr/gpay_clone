import 'package:flutter/material.dart';

class AssetImageViewer extends StatelessWidget {
  final String assetImage;
  final double height;
  const AssetImageViewer({
    super.key,
    required this.assetImage,
    required this.height,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: height,
      child: Image.asset(
        assetImage,
      ),
    );
  }
}
