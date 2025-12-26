import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../components/investment/card.dart';
import '../../components/investment/investmentCard.dart';
import '../../routes/routeConstant.dart';
import '../../store/models/ivestment_models.dart';
import '../../utils/themeData.dart';

class FindInvestmentScreen extends StatelessWidget {
  final VoidCallback onLandBankingTap;

  const FindInvestmentScreen({super.key, required this.onLandBankingTap});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Categories",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 15),
            Row(
              children: [
                Expanded(
                  child: SelectionCard(
                    title: "Land Banking",
                    icon: Icons.landscape_outlined,
                    isSelected: true,
                    onTap: () => context.push(
                      AppRoutes.add,
                      extra: "Land Banking Investment",
                    ),
                  ),
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: SelectionCard(
                    title: "Property Investment",
                    icon: Icons.house_outlined,
                    isSelected: false,
                    onTap: () => context.push(
                      AppRoutes.add,
                      extra: "Property Investment",
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 60),
            // Empty / Content state
            Center(
              child: false
                  ? Container(
                      padding: const EdgeInsets.all(5.0),
                      decoration: BoxDecoration(
                        color: Colors.grey[100], // Light grey background
                        borderRadius: BorderRadius.circular(
                          20.0,
                        ), // Rounded corners
                      ),
                      child: Column(
                        children: [
                          InvestmentCard(
                            data: InvestmentCardData(
                              title: "title",
                              status: "active",
                              amount: "2222",
                              interest: "3%",
                              maturityDate: "20/06/2026",
                            ),
                          ),

                          const SizedBox(height: 16),

                          InvestmentCard(
                            data: InvestmentCardData(
                              title: "title",
                              status: "status",
                              amount: "2222",
                              interest: "3%",
                              maturityDate: "20/06/2026",
                            ),
                          ),
                        ],
                      ),
                    )
                  : Column(
                      children: [
                        Container(
                          height: 100,
                          width: 100,
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(50),
                          ),
                          child: Icon(
                            Icons.priority_high_rounded,
                            size: 50,
                            color: Colors.green[300],
                          ),
                        ),

                        const SizedBox(height: 20),

                        const Text(
                          "There are currently no investments",
                          style: TextStyle(color: AppColors.grayColor),
                        ),

                        const SizedBox(height: 30),
                      ],
                    ),
            ),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}
