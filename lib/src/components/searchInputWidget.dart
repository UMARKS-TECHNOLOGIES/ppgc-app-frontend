import 'package:flutter/material.dart';
import 'package:ppgc_pro/src/utils/themeData.dart';

// Placeholder for SearchInput widget
class SearchInput extends StatelessWidget {
  final TextEditingController controller;
  final String title;
  final Icon icon;

  const SearchInput({
    super.key,
    required this.controller,
    required this.title,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          border: OutlineInputBorder(
            borderSide: BorderSide(width: 0),
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
          fillColor: AppColors.lightGrayColor,
          filled: true,
          suffixIcon: icon,
          labelText: title,
        ),
      ),
    );
  }
}
