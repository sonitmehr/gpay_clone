import 'package:flutter/material.dart';

class CustomSearchBar extends StatelessWidget {
  const CustomSearchBar({super.key});

  @override
  Widget build(BuildContext context) {
    return SearchBar(
      hintText: 'Search by name or number',
      hintStyle: MaterialStateProperty.resolveWith(
          (states) => TextStyle(fontSize: 16)),
      leading: Icon(Icons.search),
    );
  }
}
