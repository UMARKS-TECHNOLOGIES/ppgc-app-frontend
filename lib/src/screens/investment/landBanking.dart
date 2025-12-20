// --- SCREEN 2 & 3: Land Banking Packages ---

import 'package:flutter/material.dart';

import '../../components/investment/button.dart';
import '../../components/investment/card.dart';

class LandBankingScreen extends StatefulWidget {
  final VoidCallback onBack;
  final Function(Map<String, dynamic>) onNext;

  const LandBankingScreen({
    super.key,
    required this.onBack,
    required this.onNext,
  });

  @override
  State<LandBankingScreen> createState() => _LandBankingScreenState();
}

class _LandBankingScreenState extends State<LandBankingScreen> {
  int? _selectedIndex;

  final List<Map<String, dynamic>> _packages = [
    {
      'rate': '2%',
      'period': 'Monthly',
      'icon': Icons.calendar_view_month,
      'subtitle': '30 days (2% monthly interest)',
    },
    {
      'rate': '10%',
      'period': 'Quarterly',
      'icon': Icons.calendar_view_week,
      'subtitle': '90 days (10% quarterly interest)',
    },
    {
      'rate': '15%',
      'period': 'Half yearly',
      'icon': Icons.date_range,
      'subtitle': '6 months (15% bi-annual interest)',
    },
    {
      'rate': '30%',
      'period': 'Yearly',
      'icon': Icons.calendar_today,
      'subtitle': '1 year (30% yearly interest)',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Packages",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 15,
                mainAxisSpacing: 15,
                childAspectRatio: 1.1,
              ),
              itemCount: _packages.length,
              itemBuilder: (context, index) {
                final pkg = _packages[index];
                return SelectionCard(
                  title: pkg['rate'],
                  subtitle: pkg['period'],
                  icon: pkg['icon'],
                  isSelected: _selectedIndex == index,
                  centered: true,
                  onTap: () {
                    setState(() {
                      _selectedIndex = index;
                    });
                  },
                );
              },
            ),
          ),
          PrimaryButton(
            text: "Next",
            isEnabled: _selectedIndex != null,
            onPressed: () {
              if (_selectedIndex != null) {
                widget.onNext(_packages[_selectedIndex!]);
              }
            },
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }
}
