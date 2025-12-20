import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../components/faildImageFallBack.dart';
import '../../routes/routeConstant.dart';
import '../../store/utils/dummyData.dart';

// Define the colors based on the design
const Color kPrimaryBlack = Color(0xFF1A1A1A);
const Color kSecondaryGrey = Color(0xFF828282);
const Color kPriceGreen = Color(0xFF27AE60);
const Color kYellowColor = Color(0xFFEED202);
const Color kBgWhite = Colors.white;

class RoomDetailScreen extends StatelessWidget {
  const RoomDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBgWhite,
      // AppBar with a back button
      appBar: AppBar(
        backgroundColor: kBgWhite,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: kPrimaryBlack),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      // The main content is scrollable
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Room Image at the top
            SizedBox(
              width: double.infinity,
              height: 250, // Adjust height as needed
              child: NetworkImageFallback(
                imageUrl: '',
                height: 10,
                fit: BoxFit.cover,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Room Title and Price
                  const Text(
                    "Room 12 Kings Hotel",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: kPrimaryBlack,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    "₦40,000.00 / Night",
                    style: TextStyle(
                      fontSize: 16,
                      color: kPriceGreen,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 10),
                  // Location and Rating Row
                  Row(
                    children: const [
                      Icon(
                        Icons.location_on_outlined,
                        size: 18,
                        color: kSecondaryGrey,
                      ),
                      SizedBox(width: 5),
                      Text(
                        "Agip, Port Harcourt",
                        style: TextStyle(color: kSecondaryGrey),
                      ),
                      Spacer(),
                      Icon(Icons.star, size: 18, color: kYellowColor),
                      SizedBox(width: 5),
                      Text(
                        "4.5",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: kPrimaryBlack,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 25),
                  // Description Section
                  const Text(
                    "Description",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: kPrimaryBlack,
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    "Your comfortable retreat awaits. Relax and recharge in our well-appointed room, featuring modern amenities for a seamless stay.",
                    style: TextStyle(color: kSecondaryGrey, height: 1.5),
                  ),
                  const SizedBox(height: 25),
                  // "What we offer" Section
                  const Text(
                    "What we offer",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: kPrimaryBlack,
                    ),
                  ),
                  const SizedBox(height: 20),
                  // Row of amenity icons
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      _AmenityItem(
                        icon: Icons.hot_tub_outlined,
                        label: "Hot Bath",
                      ),
                      _AmenityItem(
                        icon: Icons.ac_unit,
                        label: "Air Conditioning",
                      ),
                      _AmenityItem(icon: Icons.restaurant, label: "Breakfast"),
                      _AmenityItem(icon: Icons.wifi, label: "Wifi"),
                    ],
                  ),
                  const SizedBox(height: 25),
                  // Reviews Section Header
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      Text(
                        "Reviews",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: kPrimaryBlack,
                        ),
                      ),
                      Text(
                        "Add Review",
                        style: TextStyle(
                          color: kYellowColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  // List of reviews
                  Column(
                    children: reviews
                        .map(
                          (review) => _ReviewItem(
                            name: review.name,
                            rating: review.rating,
                            userImage: review.userImage,
                          ),
                        )
                        .toList(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      // "Book Now" Button at the bottom
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
              context.push(AppRoutes.reviewSummary);
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
            child: const Text("Book Now"),
          ),
        ),
      ),
    );
  }
}

// Helper widget for a single amenity item (icon and label)
class _AmenityItem extends StatelessWidget {
  final IconData icon;
  final String label;

  const _AmenityItem({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, color: kSecondaryGrey, size: 28),
        const SizedBox(height: 8),
        Text(
          label,
          style: const TextStyle(color: kSecondaryGrey, fontSize: 12),
        ),
      ],
    );
  }
}

// Helper widget for a single review item
class _ReviewItem extends StatelessWidget {
  final String name;
  final double rating;
  final String userImage;

  const _ReviewItem({
    required this.name,
    required this.rating,
    required this.userImage,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20.0),
      child: Row(
        children: [
          // User Avatar
          CircleAvatar(
            radius: 24,
            backgroundImage: AssetImage(
              userImage,
            ), // Replace with network image if needed
            backgroundColor: kSecondaryGrey,
          ),
          const SizedBox(width: 15),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: kPrimaryBlack,
                ),
              ),
              const SizedBox(height: 5),
              // Rating Row with stars and value
              Row(
                children: [
                  Text(
                    rating.toString(),
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(width: 8),
                  // Generate 5 stars, filling them based on the rating
                  Row(
                    children: List.generate(5, (index) {
                      return Icon(
                        index < rating.floor() ? Icons.star : Icons.star_border,
                        color: kYellowColor,
                        size: 16,
                      );
                    }),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
