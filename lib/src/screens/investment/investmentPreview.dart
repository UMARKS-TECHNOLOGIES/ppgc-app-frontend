import 'package:flutter/material.dart';

// --- Theme Colors ---
const Color kPrimaryYellow = Color(0xFFEED202);
const Color kLightGreyCard = Color(
  0xFFF8F8F8,
); // A very light grey for the card
const Color kTextBlack = Color(0xFF1A1A1A);
const Color kTextGrey = Color(0xFF828282);

class PreviewScreen extends StatelessWidget {
  final VoidCallback onBack;
  final Map<String, dynamic> package;

  const PreviewScreen({super.key, required this.onBack, required this.package});

  @override
  Widget build(BuildContext context) {
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

                  // Details Card
                  Container(
                    padding: const EdgeInsets.all(20.0),
                    decoration: BoxDecoration(
                      color: kLightGreyCard,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      children: const [
                        _DetailRow(
                          label: "Amount",
                          value: "₦40,000.00",
                          isBold: true,
                        ),
                        SizedBox(height: 12),
                        _DetailRow(label: "Name", value: "Hair"),
                        SizedBox(height: 12),
                        _DetailRow(label: "Duration (Days)", value: "30"),
                        SizedBox(height: 12),
                        _DetailRow(label: "Interest rate", value: "2% Monthly"),
                        SizedBox(height: 12),
                        _DetailRow(
                          label: "Investment date",
                          value: "30 Apr 2025",
                        ),
                        SizedBox(height: 12),
                        _DetailRow(
                          label: "Maturity date",
                          value: "30 May 2025",
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 25),

                  const Text(
                    "₦40,000 will be invested until 30 May 2025. Actual duration and interest may vary based on the maturity date. If you wish to liquidate your funds, 100% of interest earned will be deducted.",
                    style: TextStyle(
                      fontSize: 14,
                      color: kTextGrey,
                      height: 1.5,
                    ),
                  ),
                ]),
              ),
            ),
            // Bottom section (button)
            SliverFillRemaining(
              hasScrollBody: false,
              child: Padding(
                padding: const EdgeInsets.all(18.0),
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: SizedBox(
                    width: double.infinity,
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
                      child: const Text("Payment ₦40,000.00"),
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

// Helper widget for a row in the details card
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
