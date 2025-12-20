import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ppgc_pro/src/components/property/propertyTourWidget.dart';
import 'package:ppgc_pro/src/components/titleWidget.dart';
import 'package:ppgc_pro/src/routes/routeConstant.dart';
import 'package:ppgc_pro/src/utils/themeData.dart';

import '../../components/property/detailShimmer.dart';
import '../../components/shared/btnsWidgets.dart';
import '../../store/models/property_models.dart';
import '../../store/property_provider.dart';

class SinglePropertyScreen extends HookConsumerWidget {
  final String propertyId;

  const SinglePropertyScreen({required this.propertyId, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final propertyState = ref.watch(propertyProvider);

    // Trigger fetch when widget mounts
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (propertyState.property?.id != propertyId) {
        ref.read(propertyProvider.notifier).fetchPropertyById(propertyId);
      }
    });

    final propertyNotifier = ref.read(
      propertyProvider.notifier,
    ); // Get the notifier

    Widget body;

    switch (propertyState.status) {
      case PropertyStatus.loading:
        body = const PropertyDetailsShimmer();

        break;
      case PropertyStatus.error:
        body = Center(child: Text('Error: ${propertyState.errorMessage}'));
        break;

      case PropertyStatus.loaded:
        final property = propertyState.property!;

        body = SingleChildScrollView(
          child: Column(
            children: [
              // Image & overlay
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Stack(
                    children: [
                      Image.network(
                        property.coverImageUrl ?? '',
                        width: double.infinity,
                        height: 250,
                        fit: BoxFit.cover,
                      ),
                      Container(
                        width: double.infinity,
                        height: 250,
                        color: Colors.black12,
                      ),
                      Positioned(
                        top: 12,
                        right: 12,
                        child: Container(
                          padding: const EdgeInsets.all(6),
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.favorite_border,
                            color: Colors.red,
                            size: 20,
                          ),
                        ),
                      ),
                      Positioned(
                        left: 12,
                        bottom: 12,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              property.title ?? '',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                shadows: [
                                  Shadow(
                                    offset: Offset(1, 1),
                                    blurRadius: 3,
                                    color: Colors.black38,
                                  ),
                                ],
                              ),
                            ),
                            Row(
                              children: [
                                Text(
                                  property.area.cityOrTown ?? '',
                                  style: TextStyle(
                                    color: AppColors.lightGrayColor,
                                    shadows: const [
                                      Shadow(
                                        offset: Offset(1, 1),
                                        blurRadius: 3,
                                        color: Colors.black38,
                                      ),
                                    ],
                                  ),
                                ),
                                const Icon(
                                  Icons.location_on,
                                  color: AppColors.lightGrayColor,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Description
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const TitleWidget(title: "Description"),
                    const SizedBox(height: 6),
                    Text(
                      property.description ?? '',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),

              // Attributes
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                width: double.infinity,
                // child: Column(
                //   crossAxisAlignment: CrossAxisAlignment.start,
                //   children: attributes.entries
                //       .map(
                //         (e) => buildAttributeRow(
                //           e.key,
                //           e.value,
                //           icon: iconMap[e.key],
                //         ),
                //       )
                //       .toList(),
                // ),
              ),

              // Apartment Tour
              if (property.otherImages.isNotEmpty)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 16),
                    const TitleWidget(title: "Apartment Tour"),
                    PropertyTourGallery(images: property.otherImages),
                  ],
                ),

              // Inspect / Buy Buttons
              Container(
                margin: const EdgeInsets.symmetric(vertical: 40),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    OutlineBTNWidget(
                      title: "Inspect",
                      onPressed: () {
                        context.push(
                          AppRoutes.inspect_property,
                          extra: property.id,
                        );
                      },
                    ),
                    const SizedBox(width: 40),
                    const BTNWidget(title: "Buy now"),
                  ],
                ),
              ),
            ],
          ),
        );
        break;

      case PropertyStatus.idle:
        body = const SizedBox.shrink();
    }

    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(child: body),
    );
  }
}

Widget buildAttributeRow(String label, dynamic value, {IconData? icon}) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 6.0),
    child: Row(
      children: [
        if (icon != null) ...[Icon(icon, size: 18), const SizedBox(width: 6)],
        label == "water"
            ? const Text(
                "Running",
                style: TextStyle(fontWeight: FontWeight.bold),
              )
            : Text(
                "$value",
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
        const SizedBox(width: 4),
        Text(label[0].toUpperCase() + label.substring(1)),
      ],
    ),
  );
}

// Icon map for known attributes
final iconMap = {
  "bedroom": Icons.bed_sharp,
  "toilet": Icons.bathroom_outlined,
  "electricity": Icons.bolt,
  "water": Icons.water_drop_outlined,
};
