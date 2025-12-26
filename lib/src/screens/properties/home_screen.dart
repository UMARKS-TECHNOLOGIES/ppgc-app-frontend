import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../components/categoryWiget.dart';
import '../../components/featuredPropertyWidget.dart';
import '../../components/property/propertyWidget.dart';
import '../../components/property/shimmer.dart';
import '../../components/searchInputWidget.dart';
import '../../routes/routeConstant.dart';
import '../../store/models/property_models.dart';
import '../../store/property_provider.dart';
// ... other imports remain the same

class HomeScreen extends HookConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final searchController = useTextEditingController();
    // The scrollController now manages the SingleChildScrollView
    final scrollController = useScrollController();

    final propertyState = ref.watch(propertyProvider);
    final popularProperties = ref.watch(popularPropertiesProvider);
    final notifier = ref.read(propertyProvider.notifier);

    // Fetch only if the state is empty
    useEffect(() {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (propertyState.properties.isEmpty) {
          notifier.fetchNextPage();
        }
      });
      return null;
    }, []);

    // Detect scroll to bottom for pagination (Logic remains the same)
    useEffect(() {
      scrollController.addListener(() {
        // This checks the scroll position of the entire page
        if (scrollController.position.pixels >=
            scrollController.position.maxScrollExtent - 200) {
          // Load next page
          notifier.fetchNextPage();
        }
      });
      return null;
    }, [scrollController, propertyState.page]);

    ref.listen(propertyProvider, (previous, next) {
      if (next.status == PropertyStatus.error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.red.shade700,

            content: Text(
              next.errorMessage ?? 'Oops! sorry something went wrong',
              style: TextStyle(fontSize: 13),
            ),
          ),
        );
      }
    });

    return NotificationListener<ScrollNotification>(
      onNotification: (notification) {
        if (notification.metrics.pixels >=
                notification.metrics.maxScrollExtent - 200 &&
            !propertyState.isPaginating &&
            propertyState.hasMore) {
          ref.read(propertyProvider.notifier).fetchNextPage(pageSize: 20);
        }
        return false;
      },
      child: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: SearchInput(
                controller: searchController,
                title: "Find More Properties",
                icon: const Icon(Icons.mic),
              ),
            ),
            const CategoryScrollMenu(),
            const SizedBox(height: 20),
            popularProperties.isNotEmpty
                ? FeaturedPropertyWidget()
                : SizedBox.shrink(),
            const SizedBox(height: 10),

            // Property List with Pagination
            // NO Expanded needed, as it's inside SingleChildScrollView
            propertyState.status == PropertyStatus.loading &&
                    propertyState.properties.isEmpty
                ? const Center(child: PropertyCardShimmer())
                : ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount:
                        propertyState.properties.length +
                        (propertyState.isPaginating ? 1 : 0),
                    itemBuilder: (context, index) {
                      // Bottom spinner while paginating
                      if (index == propertyState.properties.length) {
                        return const Padding(
                          padding: EdgeInsets.symmetric(vertical: 20),
                          child: PropertyCardShimmer(),
                        );
                      }

                      final p = propertyState.properties[index];

                      return Container(
                        margin: const EdgeInsets.symmetric(
                          vertical: 5,
                          horizontal: 14,
                        ),
                        child: InkWell(
                          onTap: () {
                            ref
                                .read(propertyProvider.notifier)
                                .fetchPropertyById(p.id);

                            context.push(AppRoutes.singleProperty);
                          },
                          child: PropertyCard(property: p),
                        ),
                      );
                    },
                  ),
          ],
        ),
      ),
    );
  }
}
