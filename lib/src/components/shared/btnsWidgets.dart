import 'package:flutter/material.dart';
import 'package:ppgc_pro/src/utils/themeData.dart';

class OutlineBTNWidget extends StatelessWidget {
  final VoidCallback onPressed;
  final String title;
  const OutlineBTNWidget({
    super.key,
    required this.title,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ButtonStyle(
        padding: WidgetStatePropertyAll(
          EdgeInsets.symmetric(vertical: 14, horizontal: 40),
        ),
        shape: WidgetStatePropertyAll(
          RoundedRectangleBorder(
            side: BorderSide(width: 1, color: AppColors.toColor),
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        backgroundColor: WidgetStatePropertyAll(Colors.white),
      ),
      child: Text(
        title,
        style: TextStyle(
          fontWeight: FontWeight.w500,
          color: Colors.black,
          fontSize: 14,
        ),
      ),
    );
  }
}

class BTNWidget extends StatelessWidget {
  final String title;
  final VoidCallback? onPressed;

  /// Layout controls
  final bool fullWidth;
  final double height;
  final EdgeInsetsGeometry? padding;
  final double? width;

  const BTNWidget({
    super.key,
    required this.title,
    this.onPressed,
    this.fullWidth = true, // 🔑 fullscreen by default
    this.height = 55, // 🔑 default button height
    this.padding, // 🔑 override when needed
    this.width, // 🔑 used when fullWidth = false
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: fullWidth ? double.infinity : width,
      height: height,
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [AppColors.fromColor, AppColors.toColor],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
          borderRadius: BorderRadius.circular(10),
        ),
        child: TextButton(
          onPressed: onPressed,
          style: TextButton.styleFrom(
            padding:
                padding ??
                const EdgeInsets.symmetric(horizontal: 20), // default padding
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            foregroundColor: Colors.black,
          ),
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
          ),
        ),
      ),
    );
  }
}
