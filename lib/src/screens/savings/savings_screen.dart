import 'package:flutter/material.dart';

// Define the colors based on the design
const Color kPrimaryBlack = Color(0xFF1A1A1A);
const Color kSecondaryGrey = Color(0xFF828282);
const Color kCardDarkBlue = Color(0xFF0A0E45); // Dark blue for the main card
const Color kCardLightBlue = Color(0xFF3646A6); // Lighter blue for buttons
const Color kBgWhite = Colors.white;
const Color kLightGreyFill = Color(0xFFF5F5F5); // For the empty state container

class SavingsHomeScreen extends StatelessWidget {
  const SavingsHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBgWhite,
      // AppBar with back button, title, and profile icon
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Subtitle text
              // Main Savings Card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20.0),
                decoration: BoxDecoration(
                  color: kCardDarkBlue,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Balance Section
                    const Text(
                      "Balance",
                      style: TextStyle(color: Colors.white, fontSize: 14),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Text(
                          "₦******",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(width: 10),
                        GestureDetector(
                          onTap: () {
                            // Handle toggle balance visibility
                          },
                          child: const Icon(
                            Icons.visibility_off,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 25),
                    // Identification Number Section
                    const Text(
                      "Identification Number",
                      style: TextStyle(color: Colors.white, fontSize: 14),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Text(
                          "25736536934",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(width: 10),
                        GestureDetector(
                          onTap: () {
                            // Handle copy ID action
                          },
                          child: const Icon(
                            Icons.copy,
                            color: Colors.white,
                            size: 18,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 30),
                    // Deposit and Withdraw Buttons
                    Row(
                      children: [
                        Expanded(
                          child: SizedBox(
                            height: 50,
                            child: ElevatedButton(
                              onPressed: () {
                                // Handle deposit action
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: kCardLightBlue,
                                foregroundColor: Colors.white,
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              child: const Text(
                                "Deposit",
                                style: TextStyle(fontSize: 16),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 20),
                        Expanded(
                          child: SizedBox(
                            height: 50,
                            child: ElevatedButton(
                              onPressed: () {
                                // Handle withdraw action
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: kCardLightBlue,
                                foregroundColor: Colors.white,
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              child: const Text(
                                "Withdraw",
                                style: TextStyle(fontSize: 16),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(bottom: 25.0),
                child: Text(
                  "Save daily, weekly or monthly with discipline",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 14, color: kPrimaryBlack),
                ),
              ),

              const SizedBox(height: 30),
              // Recent Activities Section Header
              const Text(
                "Recent activities",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: kPrimaryBlack,
                ),
              ),
              const SizedBox(height: 20),
              // Empty State for Recent Activities
              Container(
                width: double.infinity,
                height: 250, // Fixed height for the empty state placeholder
                decoration: BoxDecoration(
                  color: kLightGreyFill,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Center(
                  child: Text(
                    "No Records",
                    style: TextStyle(color: kSecondaryGrey, fontSize: 14),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
