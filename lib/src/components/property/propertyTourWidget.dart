import 'package:flutter/material.dart';
import 'package:ppgc_pro/src/components/faildImageFallBack.dart';
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
        itemCount: images.length,
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemBuilder: (context, index) {
          return NetworkImageFallback(
            imageUrl: images[index].secureUrl,
            height: 100,
            width: 140,
            fit: BoxFit.cover,
            borderRadius: BorderRadius.circular(5),
          );
        },
      ),
    );
  }
}
