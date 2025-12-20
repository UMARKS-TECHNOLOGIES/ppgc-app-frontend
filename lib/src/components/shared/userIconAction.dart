import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../utils/themeData.dart';

class UserIcon extends StatelessWidget {
  final String route;

  const UserIcon({super.key, required this.route});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {
        context.go(route);
      },
      icon: Container(
        width: 40,
        height: 40,
        decoration: const BoxDecoration(
          color: AppColors.grayColor,
          shape: BoxShape.circle,
        ),
        child: const Center(
          child: Icon(Icons.person_2, color: Colors.black, size: 20),
        ),
      ),
    );
  }
}
