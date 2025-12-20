import 'package:flutter/material.dart';
import 'package:ppgc_pro/src/components/faildImageFallBack.dart';

class Featuredpropertywidget extends StatelessWidget {
  final List<Map<String, String>> properties = [
    {
      'imageUrl':
          'https://images.unsplash.com/photo-1600585154340-be6161a56a0c?auto=format&fit=crop&w=800&q=80',
      'title': 'The Kings Apartment',
      'subtitle': 'Foste (mazamaz)',
    },
    {
      'imageUrl':
          'https://images.unsplash.com/photo-1570129477492-45c003edd2be?auto=format&fit=crop&w=800&q=80',
      'title': 'Unique Suites',
      'subtitle': '23 Wuye Road',
    },
    {
      'imageUrl':
          'https://images.unsplash.com/photo-1570129477492-45c003edd2be?auto=format&fit=crop&w=800&q=80',
      'title': 'Unique Suites',
      'subtitle': '23 Wuye Road',
    },
  ];

  Featuredpropertywidget({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 180,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: properties.length,
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemBuilder: (context, index) {
          final item = properties[index];

          return ClipRRect(
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(0),
              bottomRight: Radius.circular(30),
              topLeft: Radius.circular(30),
              topRight: Radius.circular(30),
            ),
            child: Stack(
              children: [
                NetworkImageFallback(
                  imageUrl: item['imageUrl']!,
                  width: 250,
                  height: 180,
                  fit: BoxFit.cover,
                ),
                Positioned(
                  left: 12,
                  bottom: 12,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item['title']!,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Colors.white,
                          shadows: [Shadow(blurRadius: 4, color: Colors.black)],
                        ),
                      ),
                      Text(
                        item['subtitle']!,
                        style: const TextStyle(
                          fontSize: 13,
                          color: Colors.white70,
                          shadows: [Shadow(blurRadius: 4, color: Colors.black)],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
