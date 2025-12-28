import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../components/shared/userIconAction.dart';
import '../../routes/routeConstant.dart';
import '../../store/investment_provider.dart';
import '../../utils/themeData.dart';

class LandBankingScreen extends ConsumerStatefulWidget {
  final String packageSubtitle;
  final VoidCallback onBack;

  const LandBankingScreen({
    super.key,
    required this.onBack,
    required this.packageSubtitle,
  });

  @override
  ConsumerState<LandBankingScreen> createState() => _LandBankingScreenState();
}

class _LandBankingScreenState extends ConsumerState<LandBankingScreen> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.dark, // Android
          statusBarBrightness: Brightness.light, // iOS
        ),

        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => context.go(AppRoutes.investment),
        ),
        title: Text(
          widget.packageSubtitle,
          style: const TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        actions: const [UserIcon(route: "")],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Packages',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 1,
                children: [
                  _buildCard(
                    index: 0,
                    icon: Icons.calendar_view_month_rounded,
                    percentage: '2%',
                    frequency: 'Monthly',
                    color: Colors.orange,
                  ),
                  _buildCard(
                    index: 1,
                    icon: Icons.monetization_on_rounded,
                    percentage: '10%',
                    frequency: 'Quarterly',
                    color: Colors.blue,
                  ),
                  _buildCard(
                    index: 2,
                    icon: Icons.calendar_today_rounded,
                    percentage: '15%',
                    frequency: 'Half yearly',
                    color: Colors.green,
                  ),
                  _buildCard(
                    index: 3,
                    icon: Icons.event_available_rounded,
                    percentage: '30%',
                    frequency: 'Yearly',
                    color: Colors.purple,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  _handleNext;
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
                  padding: EdgeInsets.zero,
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

  Widget _buildCard({
    required int index,
    required IconData icon,
    required String percentage,
    required String frequency,
    required Color color,
  }) {
    final isSelected = _selectedIndex == index;

    return InkWell(
      onTap: () => setState(() => _selectedIndex = index),
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
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
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 32, color: color),
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

  void _handleNext() {
    ref
        .read(investmentProvider.notifier)
        .updateDraft(
          title: widget.packageSubtitle,
          percentage: _selectedIndex == 0
              ? 2
              : _selectedIndex == 1
              ? 10
              : _selectedIndex == 2
              ? 15
              : 30,
        );
  }
}
