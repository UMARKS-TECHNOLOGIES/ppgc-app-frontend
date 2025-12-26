import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ppgc_pro/src/components/faildImageFallBack.dart';
import 'package:ppgc_pro/src/routes/routeConstant.dart';

import '../store/models/property_models.dart';
import '../store/property_provider.dart';

class FeaturedPropertyWidget extends ConsumerWidget {
  const FeaturedPropertyWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(propertyProvider);
    final properties = state.popularProperties;

    if (state.status == PropertyStatus.loading) {
      return const SizedBox(
        height: 180,
        child: Center(child: CircularProgressIndicator()),
      );
    }

    if (properties.isEmpty) {
      return const SizedBox(
        height: 180,
        child: Center(child: Text("No featured properties")),
      );
    }

    return SizedBox(
      height: 180,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: properties.length,
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemBuilder: (context, index) {
          final item = properties[index];

          return InkWell(
            onTap: () {
              context.push(AppRoutes.singleProperty, extra: item.id);
            },
            child: Stack(
              children: [
                NetworkImageFallback(
                  imageUrl: item.coverImageUrl,
                  width: 250,
                  height: 180,
                  fit: BoxFit.cover,
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(0),
                    bottomRight: Radius.circular(30),
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                ),
                Positioned(
                  left: 12,
                  bottom: 12,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.title,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Colors.white,
                          shadows: [Shadow(blurRadius: 4, color: Colors.black)],
                        ),
                      ),
                      Text(
                        item.title,
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
