import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ppgc_pro/src/utils/themeData.dart';

import '../../components/faildImageFallBack.dart';
import '../../components/shared/datetimeparser.dart';
import '../../store/authProvider.dart';
import '../../store/booking_provider.dart';

// Define the colors based on the design

class ReviewSummaryScreen extends ConsumerWidget {
  const ReviewSummaryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final room = ref.watch(selectedRoomProvider);
    final user = ref.read(currentUserProvider);

    return Scaffold(
      backgroundColor: AppColors.white,
      // AppBar with a back button and title
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: AppColors.black),
          onPressed: () => context.pop(),
        ),
        title: Text(
          "Review Summary",
          style: TextStyle(color: AppColors.black, fontWeight: FontWeight.bold),
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
                  _SummaryRow(
                    label: "Booking Date",
                    value: formatDateWithSuffix(DateTime.now()),
                  ),
                  _SummaryRow(
                    label: "Check In",
                    value: formatDateWithSuffix(DateTime.now()),
                  ),
                  _SummaryRow(
                    label: "Check Out",
                    value: formatDateWithSuffix(
                      DateTime.now().add(const Duration(days: 1)),
                    ),
                  ),
                  _SummaryRow(
                    label: "Guests",
                    value: "${user?.lastName ?? ''} ${user?.firstName ?? ''}",
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 10.0),
                    child: Divider(),
                  ),
                  _SummaryRow(
                    label: "Amounts",
                    value: room?.pricePerNight ?? '',
                  ),
                  const _SummaryRow(label: "Additional charges", value: "0.0"),
                  _SummaryRow(
                    label: "Total",
                    value: room?.pricePerNight ?? '',
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
                        style: TextStyle(color: AppColors.black, fontSize: 16),
                      ),
                      GestureDetector(
                        onTap: () {
                          // Handle change payment method action
                        },
                        child: const Text(
                          "Add card",
                          style: TextStyle(
                            color: AppColors.black,
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
          color: AppColors.white,
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
              backgroundColor: AppColors.fromColor,
              foregroundColor: AppColors.black,
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
            style: const TextStyle(color: AppColors.black, fontSize: 16),
          ),
          Text(
            value,
            style: TextStyle(
              color: AppColors.grayColor,
              fontSize: 16,
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}
