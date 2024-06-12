import 'package:flutter/material.dart';
import 'package:tt/helpers/resources.dart';

class CustomSearchBar extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onSearchPressed;

  const CustomSearchBar(
      {super.key, required this.controller, required this.onSearchPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 170,
      padding: const EdgeInsets.symmetric(horizontal: 2),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(30),
      ),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
            hintText: resSearch,
            border: InputBorder.none,
            prefixIcon: IconButton(
                icon: const Icon(Icons.search), onPressed: onSearchPressed),
            suffix: controller.text.isEmpty
                ? null
                : GestureDetector(
                    onTap: () {
                      controller.clear();
                      onSearchPressed();
                    },
                    child: const Icon(Icons.close, size: 16))),
      ),
    );
  }
}
