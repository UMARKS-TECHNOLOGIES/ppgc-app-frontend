import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../store/investment_provider.dart';

// --- Theme Colors ---
const Color kPrimaryYellow = Color(0xFFEED202);
const Color kLightGreyCard = Color(0xFFF8F8F8);
const Color kTextBlack = Color(0xFF1A1A1A);
const Color kTextGrey = Color(0xFF828282);

class PreviewScreen extends ConsumerWidget {
  const PreviewScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final draft = ref.watch(investmentProvider).draft;

    final amount = draft.amount ?? 0;
    final name = (draft.name?.isNotEmpty ?? false) ? draft.name! : "-";
    final percentage = draft.percentage ?? 0;

    final DateTime investmentDate = DateTime.now();

    final int durationDays;
    final String interestLabel;

    switch (percentage) {
      case 2:
        durationDays = 30;
        interestLabel = "2% Monthly";
        break;
      case 10:
        durationDays = 90;
        interestLabel = "10% Quarterly";
        break;
      case 15:
        durationDays = 180;
        interestLabel = "15% Half yearly";
        break;
      default:
        durationDays = 365;
        interestLabel = "30% Yearly";
    }

    final maturityDate = investmentDate.add(Duration(days: durationDays));

    final currency = NumberFormat.currency(
      locale: "en_NG",
      symbol: "₦",
      decimalDigits: 2,
    );

    final dateFormat = DateFormat("dd MMM yyyy");

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: kTextBlack),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          "Preview",
          style: TextStyle(
            color: kTextBlack,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.account_circle, size: 30, color: kTextBlack),
            onPressed: () {},
          ),
          const SizedBox(width: 10),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.only(bottom: 20.0),
        child: CustomScrollView(
          slivers: [
            SliverPadding(
              padding: const EdgeInsets.all(20),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  const Text(
                    "Plan details",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: kTextBlack,
                    ),
                  ),
                  const SizedBox(height: 20),

                  Container(
                    padding: const EdgeInsets.all(20.0),
                    decoration: BoxDecoration(
                      color: kLightGreyCard,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      children: [
                        _DetailRow(
                          label: "Amount",
                          value: currency.format(amount),
                          isBold: true,
                        ),
                        const SizedBox(height: 12),
                        _DetailRow(label: "Name", value: name),
                        const SizedBox(height: 12),
                        _DetailRow(
                          label: "Duration (Days)",
                          value: durationDays.toString(),
                        ),
                        const SizedBox(height: 12),
                        _DetailRow(
                          label: "Interest rate",
                          value: interestLabel,
                        ),
                        const SizedBox(height: 12),
                        _DetailRow(
                          label: "Investment date",
                          value: dateFormat.format(investmentDate),
                        ),
                        const SizedBox(height: 12),
                        _DetailRow(
                          label: "Maturity date",
                          value: dateFormat.format(maturityDate),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 25),

                  Text(
                    "${currency.format(amount)} will be invested until "
                    "${dateFormat.format(maturityDate)}. Actual duration and "
                    "interest may vary based on the maturity date. If you wish "
                    "to liquidate your funds, 100% of interest earned will be deducted.",
                    style: const TextStyle(
                      fontSize: 14,
                      color: kTextGrey,
                      height: 1.5,
                    ),
                  ),
                ]),
              ),
            ),

            SliverFillRemaining(
              hasScrollBody: false,
              child: Padding(
                padding: const EdgeInsets.all(18.0),
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Row(
                    children: [
                      Expanded(
                        child: SizedBox(
                          height: 55,
                          child: ElevatedButton(
                            onPressed: () {
                              ref
                                  .read(investmentProvider.notifier)
                                  .resetDraft();
                              context.go('/investment');
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              foregroundColor: kTextBlack,
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                                side: const BorderSide(color: kTextGrey),
                              ),
                              textStyle: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            child: const Text("Cancel"),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: SizedBox(
                          height: 55,
                          child: ElevatedButton(
                            onPressed: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text("Processing Payment..."),
                                ),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: kPrimaryYellow,
                              foregroundColor: kTextBlack,
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              textStyle: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            child: Text(
                              "Payment ₦${amount.toStringAsFixed(2)}",
                            ),
                          ),
                        ),
                      ),
                    ],
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

// Helper widget (unchanged)
class _DetailRow extends StatelessWidget {
  final String label;
  final String value;
  final bool isBold;

  const _DetailRow({
    required this.label,
    required this.value,
    this.isBold = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(fontSize: 14, color: kTextGrey)),
        Text(
          value,
          style: TextStyle(
            fontSize: 14,
            fontWeight: isBold ? FontWeight.bold : FontWeight.w500,
            color: kTextBlack,
          ),
        ),
      ],
    );
  }
}
