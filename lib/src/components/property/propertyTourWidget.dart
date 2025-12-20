import 'package:flutter/material.dart';
import 'package:ppgc_pro/src/store/models/property_models.dart';

class PropertyTourGallery extends StatelessWidget {
  final List<OtherImages> images;

  const PropertyTourGallery({required this.images, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100, // Adjust height as needed
      margin: const EdgeInsets.symmetric(vertical: 12),
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: images.length,
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemBuilder: (context, index) {
          return ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.network(
              images[index].secureUrl,
              width: 140,
              height: 100,
              fit: BoxFit.cover,
            ),
          );
        },
      ),
    );
  }
}
