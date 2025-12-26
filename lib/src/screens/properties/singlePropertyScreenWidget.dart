import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ppgc_pro/src/components/faildImageFallBack.dart';

import '../../components/property/detailShimmer.dart';
import '../../components/property/propertyTourWidget.dart';
import '../../components/shared/btnsWidgets.dart';
import '../../components/titleWidget.dart';
import '../../routes/routeConstant.dart';
import '../../store/models/property_models.dart';
import '../../store/property_provider.dart';
import '../../utils/themeData.dart';

class SinglePropertyScreen extends HookConsumerWidget {
  const SinglePropertyScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final propertyState = ref.watch(propertyProvider);
    final propertyNotifier = ref.read(propertyProvider.notifier);

    Widget body;

    switch (propertyState.status) {
      case PropertyStatus.loading:
        body = const PropertyDetailsShimmer();
        break;

      case PropertyStatus.error:
        body = Center(
          child: Text(
            'Error: ${propertyState.errorMessage ?? "Something went wrong"}',
          ),
        );
        break;

      case PropertyStatus.loaded:
        final property = propertyState.property;

        if (property == null) {
          body = const PropertyDetailsShimmer();
          break;
        }

        body = SingleChildScrollView(
          child: Column(
            children: [
              Stack(
                children: [
                  NetworkImageFallback(
                    imageUrl: property.coverImageUrl,
                    height: 250,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    borderRadius: BorderRadius.all(Radius.zero),
                  ),
                  Container(
                    width: double.infinity,
                    height: 250,
                    color: Colors.black12,
                  ),
                  Positioned(
                    top: 12,
                    right: 12,
                    child: InkWell(
                      onTap: () => {},
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
                  ),
                ],
              ),

              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          property.title,
                          style: const TextStyle(
                            color: Colors.black54,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          property.price,
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Text(
                          property.area.cityOrTown,
                          style: TextStyle(color: Colors.black54),
                        ),
                        const Icon(
                          Icons.location_on,
                          color: AppColors.grayColor,
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // description
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const TitleWidget(title: "Description"),
                        const SizedBox(height: 6),
                        Text(
                          property.description,
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        const SizedBox(height: 10),
                      ],
                    ),

                    if (property.otherImages.isNotEmpty)
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 16),
                          const TitleWidget(title: "Apartment Tour"),
                          PropertyTourGallery(images: property.otherImages),
                        ],
                      ),
                  ],
                ),
              ),

              Container(
                margin: const EdgeInsets.symmetric(vertical: 40),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 140,
                      child: OutlineBTNWidget(
                        title: "Inspect",
                        onPressed: () {
                          context.push(
                            AppRoutes.inspect_property,
                            extra: property.id,
                          );
                        },
                      ),
                    ),
                    const SizedBox(width: 40),
                    SizedBox(
                      width: 140,
                      child: const BTNWidget(title: "Buy now"),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );

        break;

      case PropertyStatus.idle:
        body = const SizedBox.shrink();
        break;
      case PropertyStatus.submittingInspection:
        body = const SizedBox.shrink();

        break;
      case PropertyStatus.submittedInspection:
        body = const SizedBox.shrink();
        break;
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
