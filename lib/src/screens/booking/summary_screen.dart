import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../components/faildImageFallBack.dart';

// Define the colors based on the design
const Color kPrimaryBlack = Color(0xFF1A1A1A);
const Color kSecondaryGrey = Color(0xFF828282);
const Color kYellowColor = Color(0xFFEED202);
const Color kBgWhite = Colors.white;

class ReviewSummaryScreen extends StatelessWidget {
  const ReviewSummaryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBgWhite,
      // AppBar with a back button and title
      appBar: AppBar(
        backgroundColor: kBgWhite,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: kPrimaryBlack),
          onPressed: () => context.pop(),
        ),
        title: const Text(
          "Review Summary",
          style: TextStyle(color: kPrimaryBlack, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      // The main content is scrollable
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Room Image at the top
            SizedBox(
              width: double.infinity,
              height: 250, // Adjust height as needed to match design
              child: NetworkImageFallback(
                imageUrl: '',
                height: 10,
                fit: BoxFit.cover,
              ),
            ),
            // Booking Details Section
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  const _SummaryRow(
                    label: "Booking Date",
                    value: "7th May, 2025",
                  ),
                  const _SummaryRow(label: "Check In", value: "7th May, 2025"),
                  const _SummaryRow(label: "Check Out", value: "7th May, 2025"),
                  const _SummaryRow(label: "Guests", value: "7th May, 2025"),
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 10.0),
                    child: Divider(),
                  ),
                  const _SummaryRow(label: "Amounts", value: "7th May, 2025"),
                  const _SummaryRow(
                    label: "Additional charges",
                    value: "7th May, 2025",
                  ),
                  const _SummaryRow(
                    label: "Total",
                    value: "7th May, 2025",
                    isBold: true, // Make the Total value bold
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 10.0),
                    child: Divider(),
                  ),
                  // Debit Card Row with a "Change" option
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Debit Card",
                        style: TextStyle(color: kPrimaryBlack, fontSize: 16),
                      ),
                      GestureDetector(
                        onTap: () {
                          // Handle change payment method action
                        },
                        child: const Text(
                          "Change",
                          style: TextStyle(
                            color: kPrimaryBlack,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),

      // "Pay Now" Button fixed at the bottom
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(20.0),
        decoration: const BoxDecoration(
          color: kBgWhite,
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 10,
              offset: Offset(0, -5),
            ),
          ],
        ),
        child: SizedBox(
          height: 55,
          child: ElevatedButton(
            onPressed: () {
              // Handle payment action
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: kYellowColor,
              foregroundColor: kPrimaryBlack,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              textStyle: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            child: const Text("Pay Now"),
          ),
        ),
      ),
    );
  }
}

// Helper widget for a single row in the summary list
class _SummaryRow extends StatelessWidget {
  final String label;
  final String value;
  final bool isBold;

  const _SummaryRow({
    required this.label,
    required this.value,
    this.isBold = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(color: kPrimaryBlack, fontSize: 16),
          ),
          Text(
            value,
            style: TextStyle(
              color: kSecondaryGrey,
              fontSize: 16,
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}
