import 'package:flutter/material.dart';

class ArrowListTile extends StatelessWidget {
  final Icon icon;
  final String text;
  final Widget Function(BuildContext) builder;
  const ArrowListTile({
    super.key,
    required this.icon,
    required this.text,
    required this.builder,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: builder));
      },
      child: ListTile(
        leading: icon,
        title: Text(
          text,
        ),
        trailing: const Icon(
          Icons.arrow_forward_ios,
          size: 15,
          color: Colors.black,
        ),
      ),
    );
  }
}
