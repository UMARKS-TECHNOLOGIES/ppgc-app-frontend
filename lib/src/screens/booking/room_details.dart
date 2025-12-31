import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ppgc_pro/src/components/shared/userAvatar.dart';

import '../../components/faildImageFallBack.dart';
import '../../routes/routeConstant.dart';
import '../../store/booking_provider.dart';
import '../../store/utils/dummyData.dart';
import '../../utils/themeData.dart';

// Define the colors based on the design
// const Color AppColors.fromColor = Color(0xFFEED202);
const Color kBgWhite = Colors.white;

class RoomDetailScreen extends ConsumerWidget {
  const RoomDetailScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final room = ref.watch(selectedRoomProvider);
    return Scaffold(
      backgroundColor: kBgWhite,
      // AppBar with a back button
      appBar: AppBar(
        backgroundColor: kBgWhite,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.black),
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
                imageUrl: room?.imageUrl ?? "",
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
                  Text(
                    room?.roomName ?? "",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: AppColors.black,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    "${room?.pricePerNight ?? 0}/ Night",
                    style: TextStyle(
                      fontSize: 16,
                      color: AppColors.green,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 10),
                  // Location and Rating Row
                  Row(
                    children: [
                      Icon(
                        Icons.location_on_outlined,
                        size: 18,
                        color: AppColors.grayColor,
                      ),
                      SizedBox(width: 5),
                      Text(
                        room?.location ?? "",
                        style: TextStyle(color: AppColors.grayColor),
                      ),
                      Spacer(),
                      Icon(Icons.star, size: 18, color: AppColors.fromColor),
                      SizedBox(width: 5),
                      Text(
                        room?.rating.toString() ?? '',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: AppColors.black,
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
                      color: AppColors.black,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    room?.description ?? '',
                    style: TextStyle(color: AppColors.grayColor, height: 1.5),
                  ),
                  const SizedBox(height: 25),
                  // "What we offer" Section
                  const Text(
                    "What we offer",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.black,
                    ),
                  ),
                  const SizedBox(height: 20),
                  // Row of amenity icons
                  Builder(
                    builder: (context) {
                      // 1. Get the list (safely handle nulls)
                      final amenityList = room?.amenities ?? [];

                      if (amenityList.isEmpty) {
                        return const Text(
                          "No amenities listed",
                          style: TextStyle(color: AppColors.grayColor),
                        );
                      }

                      // 2. Render dynamic items
                      return Wrap(
                        spacing: 24.0, // Horizontal space between items
                        runSpacing: 16.0, // Vertical space between lines
                        alignment: WrapAlignment.start,
                        children: amenityList.map<Widget>((amenityString) {
                          return _AmenityItem(
                            icon: _getAmenityIcon(amenityString),
                            label: amenityString,
                          );
                        }).toList(),
                      );
                    },
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
                          color: AppColors.black,
                        ),
                      ),
                      Text(
                        "Add Review",
                        style: TextStyle(
                          color: AppColors.toColor,
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
            child: const Text("Book Now"),
          ),
        ),
      ),
    );
  }
}

IconData _getAmenityIcon(String amenity) {
  // Normalize string: convert to lowercase and remove spaces/hyphens for better matching
  final key = amenity.toLowerCase().replaceAll(RegExp(r'[^a-z]'), '');

  if (key.contains('wifi') || key.contains('internet')) return Icons.wifi;
  if (key.contains('ac') || key.contains('aircond')) return Icons.ac_unit;
  if (key.contains('tv') || key.contains('television')) return Icons.tv;
  if (key.contains('bath') || key.contains('hot') || key.contains('tub'))
    return Icons.hot_tub;
  if (key.contains('food') ||
      key.contains('breakfast') ||
      key.contains('restaurant'))
    return Icons.restaurant;
  if (key.contains('gym') || key.contains('fitness'))
    return Icons.fitness_center;
  if (key.contains('pool')) return Icons.pool;
  if (key.contains('park')) return Icons.local_parking;

  // Default fallback icon if no match found
  return Icons.check_circle_outline;
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
          UserAvatar(imgUrl: 'https://example.com/profile.jpg', radius: 30),
          const SizedBox(width: 15),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: AppColors.black,
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
                        color: AppColors.fromColor,
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

// Helper widget for a single amenity item (icon and label)
class _AmenityItem extends StatelessWidget {
  final IconData icon;

  final String label;

  const _AmenityItem({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, color: AppColors.grayColor, size: 28),

        const SizedBox(height: 8),

        Text(
          label,

          style: const TextStyle(color: AppColors.grayColor, fontSize: 12),
        ),
      ],
    );
  }
}
