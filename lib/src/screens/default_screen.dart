// lib/screens/home_screen.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ppgc_pro/src/routes/indexRoute.dart';
import 'package:ppgc_pro/src/routes/routeConstant.dart';
import 'package:ppgc_pro/src/utils/themeData.dart';

class DefaultScreen extends StatelessWidget {
  final Widget child;
  final PreferredSizeWidget? appBar;

  const DefaultScreen({required this.child, this.appBar, super.key});

  void _onItemTapped(int index, BuildContext context) {
    final tab = BottomTab.values[index];
    context.go(tab.path);
  }

  @override
  Widget build(BuildContext context) {
    final location = GoRouter.of(
      context,
    ).routerDelegate.currentConfiguration.uri.toString();
    final currentTab = BottomTabExtension.fromPath(location);
    final currentIndex = BottomTab.values.indexOf(currentTab);

    return Scaffold(
      appBar: appBar,
      body: child,
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Color(0XFF333333),
        type: BottomNavigationBarType.fixed,
        unselectedItemColor: Color(0xffA1A5C1),
        unselectedLabelStyle: TextStyle(color: Colors.red),
        showUnselectedLabels: true,

        showSelectedLabels: true,
        selectedItemColor: AppColors.fromColor,
        selectedLabelStyle: TextStyle(color: Colors.red),

        currentIndex: currentIndex,
        onTap: (index) => _onItemTapped(index, context),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(
            icon: Icon(Icons.trending_up),
            label: 'Investment',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.apartment), label: 'Rooms'),
          BottomNavigationBarItem(
            icon: Icon(Icons.savings),
            label: 'Savings (Daily Pay)',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'You '),
        ],
      ),
    );
  }
}
