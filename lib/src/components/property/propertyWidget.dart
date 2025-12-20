import 'package:flutter/material.dart';

import '../faildImageFallBack.dart';

class PropertyCard extends StatelessWidget {
  final String imageUrl;
  final String title;
  final Map<String, int>? roomsAndToilet; // made optional
  final String price;

  const PropertyCard({
    super.key,
    required this.imageUrl,
    required this.title,
    required this.price,
    this.roomsAndToilet,
  });

  @override
  Widget build(BuildContext context) {
    final bedrooms = roomsAndToilet?["bedroom"] ?? 0;
    final toilets = roomsAndToilet?["toilet"] ?? 0;

    return Row(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: NetworkImageFallback(
            height: 70,
            width: 70,
            imageUrl: imageUrl,
          ),
        ),
        const SizedBox(width: 10),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 16,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              price,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 13,
                color: Colors.green,
              ),
            ),
            Row(
              children: [
                const Icon(Icons.bed_rounded, color: Colors.black38),
                const SizedBox(width: 5),
                Text(
                  bedrooms.toString(),
                  style: const TextStyle(fontSize: 13, color: Colors.black38),
                ),
                const SizedBox(width: 2),
                const Text(
                  "Bedrooms",
                  style: TextStyle(fontSize: 13, color: Colors.black38),
                ),
                const SizedBox(width: 5),
                const Icon(Icons.shower_sharp, color: Colors.black38),
                Text(
                  toilets.toString(),
                  style: const TextStyle(fontSize: 13, color: Colors.black38),
                ),
                const SizedBox(width: 2),
                const Text(
                  "Bathroom",
                  style: TextStyle(fontSize: 13, color: Colors.black38),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}
