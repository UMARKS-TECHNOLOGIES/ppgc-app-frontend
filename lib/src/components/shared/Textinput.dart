import 'package:flutter/material.dart';

// Placeholder for TextInput widget
class TextInput extends StatelessWidget {
  final TextEditingController controller;
  final String title;
  final bool obscureText;
  final TextInputType keyboardType;

  const TextInput({
    super.key,
    required this.controller,
    required this.title,
    this.obscureText = false,
    this.keyboardType = TextInputType.emailAddress,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          suffixIcon: title == "Pin" ? Icon(Icons.visibility) : null,
          labelText: "Enter $title",
          border: OutlineInputBorder(),
        ),
      ),
    );
  }
}
