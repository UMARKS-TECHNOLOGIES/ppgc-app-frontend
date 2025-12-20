import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../components/shared/userIconAction.dart';
import '../../routes/routeConstant.dart';
import '../../utils/themeData.dart';

// Main screen widget
class LandBankingScreen extends StatefulWidget {
  final String packageSubtitle;
  final VoidCallback onBack;

  const LandBankingScreen({
    super.key,
    required this.onBack,
    required this.packageSubtitle,
  });

  @override
  State<LandBankingScreen> createState() => _LandBankingScreenState();
}

class _LandBankingScreenState extends State<LandBankingScreen> {
  int _selectedIndex = 0;
  // only ONE can be selected
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5), // Light grey background
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => context.go(AppRoutes.investment),
        ),
        title: Text(
          widget.packageSubtitle,
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        actions: [UserIcon(route: "")],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Packages',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            // Grid of package cards
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 1.0, // Square cards
                children: [
                  PackageCard(
                    icon: Icons.calendar_view_month_rounded,
                    percentage: '2%',
                    frequency: 'Monthly',
                    iconColor: Colors.orange,
                    isSelected: _selectedIndex == 0,
                    onTap: () {
                      setState(() => _selectedIndex = 0);
                    },
                  ),
                  PackageCard(
                    icon: Icons.monetization_on_rounded,
                    percentage: '10%',
                    frequency: 'Quarterly',
                    iconColor: Colors.blue,
                    isSelected: _selectedIndex == 1,
                    onTap: () {
                      setState(() => _selectedIndex = 1);
                    },
                  ),
                  PackageCard(
                    icon: Icons.calendar_today_rounded,
                    percentage: '15%',
                    frequency: 'Half yearly',
                    iconColor: Colors.green,
                    isSelected: _selectedIndex == 2,
                    onTap: () {
                      setState(() => _selectedIndex = 2);
                    },
                  ),
                  PackageCard(
                    icon: Icons.event_available_rounded,
                    percentage: '30%',
                    frequency: 'Yearly',
                    iconColor: Colors.purple,
                    isSelected: _selectedIndex == 3,
                    onTap: () {
                      setState(() => _selectedIndex = 3);
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            // Next button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  context.push(
                    AppRoutes.add2,
                    extra: {
                      "investment": widget.packageSubtitle,

                      "plan": _selectedIndex == 0
                          ? "2"
                          : _selectedIndex == 1
                          ? "10"
                          : _selectedIndex == 2
                          ? "15"
                          : "30",
                    },
                  );
                },
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.zero, // Important for gradient
                  elevation: 0,
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Ink(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [AppColors.fromColor, AppColors.toColor],
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Container(
                    alignment: Alignment.center,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    child: const Text(
                      'Next',
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Reusable card widget for each package

class PackageCard extends StatelessWidget {
  final IconData icon;
  final String percentage;
  final String frequency;
  final Color iconColor;
  final bool isSelected;
  final VoidCallback onTap;

  const PackageCard({
    super.key,
    required this.icon,
    required this.percentage,
    required this.frequency,
    required this.iconColor,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? AppColors.toColor : Colors.transparent,
            width: 2,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withValues(alpha: 0.1),
              spreadRadius: 1,
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 32, color: iconColor),
            const SizedBox(height: 12),
            Text(
              percentage,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text(
              frequency,
              style: TextStyle(fontSize: 14, color: Colors.grey[600]),
            ),
          ],
        ),
      ),
    );
  }
}
