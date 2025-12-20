import 'package:flutter/material.dart';
import 'package:ppgc_pro/src/components/shared/userIconAction.dart';

// Define the colors based on the design
const Color kPrimaryBlack = Color(0xFF1A1A1A);
const Color kSecondaryGrey = Color(0xFF828282);
const Color kLightGreyFill = Color(0xFFF5F5F5);
const Color kDisabledButtonGrey = Color(0xFFD3D3D3);
const Color kBgWhite = Colors.white;

class SavingsCreateTokenScreen extends StatelessWidget {
  const SavingsCreateTokenScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBgWhite,
      // AppBar with back button, title, and profile icon
      appBar: AppBar(
        backgroundColor: kBgWhite,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: kPrimaryBlack),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          "Savings",
          style: TextStyle(color: kPrimaryBlack, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        actions: [UserIcon(route: "")],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            // Instructional text at the top
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 30.0),
              child: Text(
                "Create a passcode to generate a Unique Identification Number (UIN)",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: kPrimaryBlack,
                  height: 1.5,
                ),
              ),
            ),
            // Card containing the passcode input fields
            Container(
              padding: const EdgeInsets.all(20.0),
              decoration: BoxDecoration(
                color: kBgWhite,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // "Enter passcode" field
                  const Text(
                    "Enter passcode (6 digits)",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: kPrimaryBlack,
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    obscureText: true,
                    keyboardType: TextInputType.number,
                    maxLength: 6,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: kLightGreyFill,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide.none,
                      ),
                      counterText:
                          "", // Hides the character counter below the text field
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 15,
                        vertical: 15,
                      ),
                    ),
                  ),
                  const SizedBox(height: 25),
                  // "Re-enter passcode" field
                  const Text(
                    "Re-enter passcode",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: kPrimaryBlack,
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    obscureText: true,
                    keyboardType: TextInputType.number,
                    maxLength: 6,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: kLightGreyFill,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide.none,
                      ),
                      counterText: "",
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 15,
                        vertical: 15,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const Spacer(),
            // "Continue" Button at the bottom
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                onPressed: null, // Disabled state as shown in the image
                style: ElevatedButton.styleFrom(
                  backgroundColor: kDisabledButtonGrey,
                  foregroundColor: kPrimaryBlack.withOpacity(0.5),
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  textStyle: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                child: const Text("Continue"),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
