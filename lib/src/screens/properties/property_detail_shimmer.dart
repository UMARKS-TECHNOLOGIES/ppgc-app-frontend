import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

// Make sure to add the shimmer package to your pubspec.yaml:
// dependencies:
//   shimmer: ^3.0.0

class LandBankingShimmerScreen extends StatelessWidget {
  const LandBankingShimmerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Define base and highlight colors for the shimmer effect to match a light theme
    const baseColor = Color(0xFFE0E0E0);
    const highlightColor = Color(0xFFF5F5F5);

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5), // Match the screen background
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Shimmer.fromColors(
            baseColor: baseColor,
            highlightColor: highlightColor,
            child: const CircleAvatar(backgroundColor: Colors.white),
          ),
        ),
        title: Shimmer.fromColors(
          baseColor: baseColor,
          highlightColor: highlightColor,
          child: Container(width: 120, height: 20, color: Colors.white),
        ),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: Shimmer.fromColors(
              baseColor: baseColor,
              highlightColor: highlightColor,
              child: const CircleAvatar(
                radius: 14,
                backgroundColor: Colors.white,
              ),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Shimmer for the "Packages" title
            Shimmer.fromColors(
              baseColor: baseColor,
              highlightColor: highlightColor,
              child: Container(width: 100, height: 24, color: Colors.white),
            ),
            const SizedBox(height: 16),
            // Shimmer grid for the package cards
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 1.0,
                physics:
                    const NeverScrollableScrollPhysics(), // Disable scrolling for shimmer
                children: List.generate(
                  4,
                  (index) => const _ShimmerPackageCard(),
                ),
              ),
            ),
            const SizedBox(height: 16),
            // Shimmer for the "Next" button
            Shimmer.fromColors(
              baseColor: baseColor,
              highlightColor: highlightColor,
              child: Container(
                width: double.infinity,
                height: 56, // Standard button height
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// A reusable widget for a single shimmer package card
class _ShimmerPackageCard extends StatelessWidget {
  const _ShimmerPackageCard();

  @override
  Widget build(BuildContext context) {
    const baseColor = Color(0xFFE0E0E0);
    const highlightColor = Color(0xFFF5F5F5);

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        // Optional: Add a subtle shadow placeholder
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.05),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      padding: const EdgeInsets.all(16.0),
      child: Shimmer.fromColors(
        baseColor: baseColor,
        highlightColor: highlightColor,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Shimmer for the icon
            const CircleAvatar(radius: 16, backgroundColor: Colors.white),
            const SizedBox(height: 12),
            // Shimmer for the percentage text
            Container(width: 60, height: 24, color: Colors.white),
            const SizedBox(height: 8),
            // Shimmer for the frequency text
            Container(width: 80, height: 14, color: Colors.white),
          ],
        ),
      ),
    );
  }
}
