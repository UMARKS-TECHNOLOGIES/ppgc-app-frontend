import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:ppgc_pro/src/components/shared/userIconAction.dart';
import 'package:ppgc_pro/src/routes/routeConstant.dart';
import 'package:ppgc_pro/src/store/models/user_models.dart';

import '../notification/NotificationBellWithGradient.dart';

PreferredSizeWidget buildDynamicAppBar({
  required String path,
  required BuildContext context,
  required Profile user,
  required String location,
}) {
  return AppBar(
    backgroundColor: Colors.white,
    elevation: 0,
    toolbarHeight: 120,
    leadingWidth: MediaQuery.of(context).size.width / 2,
    leading: Padding(
      padding: const EdgeInsets.only(top: 20.0, left: 16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          UserIcon(route: AppRoutes.profile),
          Text(
            "${user.firstName} ${user.lastName}",
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          SizedBox(height: 4),
          Text(location, style: TextStyle(fontSize: 12, color: Colors.grey)),
        ],
      ),
    ),
    title: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: const [],
    ),
    actions: [
      Padding(
        padding: const EdgeInsets.only(right: 16),
        child: AnimatedNotificationBell(),
      ),
    ],
  );
}

PreferredSizeWidget investmentAppBar(String path, context) {
  return AppBar(
    backgroundColor: Colors.white,
    elevation: 0,
    toolbarHeight: 70,
    title: Text("Find investment"),
    centerTitle: true,
    actions: [UserIcon(route: AppRoutes.profile)],
  );
}

PreferredSizeWidget customAppBar({
  required BuildContext context,
  required String title,
  String? route,
  bool isBack = false,
  bool isCenterTitle = true,
  bool isAction = true,
  List<Widget> action = const [],
}) {
  return AppBar(
    backgroundColor: Colors.white,
    elevation: 0,
    toolbarHeight: 70,
    systemOverlayStyle: const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark, // Android
      statusBarBrightness: Brightness.light, // iOS
    ),

    // ⬅️ BACK BUTTON (GoRouter-safe)
    leading: isBack
        ? IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () => context.pop(),
          )
        : null,

    title: Text(
      title,
      style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
    ),

    centerTitle: isCenterTitle,

    // 👤 ACTION ICON (conditionally rendered)
    actions: action,
  );
}
