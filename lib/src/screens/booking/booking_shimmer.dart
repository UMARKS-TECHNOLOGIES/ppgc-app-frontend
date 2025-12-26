import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class BookingShimmer extends StatelessWidget {
  const BookingShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    // Define your base shimmer colors here to match your app's theme
    final baseColor = Colors.grey[300]!;
    final highlightColor = Colors.grey[100]!;

    return SingleChildScrollView(
      physics:
          const NeverScrollableScrollPhysics(), // Disable scrolling while loading
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header "Booking"
            _buildShimmerText(
              width: 120,
              height: 32,
              baseColor: baseColor,
              highlightColor: highlightColor,
            ),
            const SizedBox(height: 24),

            // "Most Popular" Section Header
            _buildShimmerText(
              width: 150,
              height: 20,
              baseColor: baseColor,
              highlightColor: highlightColor,
            ),
            const SizedBox(height: 16),

            // "Most Popular" Horizontal List
            SizedBox(
              height: 280, // Approximate height of the card in your design
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: 2, // Show a couple of cards partially
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.only(right: 16.0),
                    child: _buildPopularCardShimmer(baseColor, highlightColor),
                  );
                },
              ),
            ),
            const SizedBox(height: 24),

            // "Available Rooms" Section Header
            _buildShimmerText(
              width: 180,
              height: 20,
              baseColor: baseColor,
              highlightColor: highlightColor,
            ),
            const SizedBox(height: 16),

            // "Available Rooms" Vertical List
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: 3,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 16.0),
                  child: _buildAvailableRoomRowShimmer(
                    baseColor,
                    highlightColor,
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  // --- Helper Widgets ---

  Widget _buildPopularCardShimmer(Color base, Color highlight) {
    return Shimmer.fromColors(
      baseColor: base,
      highlightColor: highlight,
      child: Container(
        width: 260, // Width matches the large cards in your screenshot
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image Placeholder
            Container(
              height: 160,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title
                  Container(height: 18, width: 180, color: Colors.white),
                  const SizedBox(height: 8),
                  // Subtitle (Location)
                  Container(height: 14, width: 120, color: Colors.white),
                  const SizedBox(height: 12),
                  // Price and Rating Row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(height: 16, width: 100, color: Colors.white),
                      Container(height: 16, width: 40, color: Colors.white),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAvailableRoomRowShimmer(Color base, Color highlight) {
    return Shimmer.fromColors(
      baseColor: base,
      highlightColor: highlight,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Thumbnail Image
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          const SizedBox(width: 16),
          // Text Details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 4),
                // Title
                Container(
                  height: 16,
                  width: double.infinity,
                  color: Colors.white,
                ),
                const SizedBox(height: 8),
                // Subtitle
                Container(height: 14, width: 150, color: Colors.white),
                const SizedBox(height: 12),
                // Price and Rating Row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(height: 16, width: 100, color: Colors.white),
                    Container(height: 16, width: 30, color: Colors.white),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildShimmerText({
    required double width,
    required double height,
    required Color baseColor,
    required Color highlightColor,
  }) {
    return Shimmer.fromColors(
      baseColor: baseColor,
      highlightColor: highlightColor,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(4),
        ),
      ),
    );
  }
}
