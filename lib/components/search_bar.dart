import 'package:flutter/material.dart';

class CustomSearchBar extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onSearchPressed;

  CustomSearchBar({required this.controller, required this.onSearchPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 170,
      padding: EdgeInsets.symmetric(horizontal: 2),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(30),
      ),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          hintText: 'Search',
          border: InputBorder.none,
          prefixIcon:
              IconButton(icon: Icon(Icons.search), onPressed: onSearchPressed),
        ),
      ),
    );
  }
}
