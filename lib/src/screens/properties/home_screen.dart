import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../components/categoryWiget.dart';
import '../../components/featuredPropertyWidget.dart';
import '../../components/property/propertyWidget.dart';
import '../../components/property/shimmer.dart';
import '../../components/property/snackbar.dart';
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
    final notifier = ref.read(propertyProvider.notifier);

    // Fetch only if the state is empty
    useEffect(() {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (propertyState.properties.isEmpty) {
          notifier.fetchProperties(page: 1, size: 10);
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
          final nextPage = propertyState.page + 1;
          notifier.fetchProperties(page: nextPage, size: 10);
        }
      });
      return null;
    }, [scrollController, propertyState.page]);

    return SafeArea(
      child: PropertySnackListener(
        child: SingleChildScrollView(
          // <-- NEW: Makes the entire content scrollable
          controller: scrollController, // <-- NEW: Attach controller here
          child: Column(
            // NOTE: Column is now inside SingleChildScrollView
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
              Featuredpropertywidget(),
              const SizedBox(height: 10),

              // Property List with Pagination
              // NO Expanded needed, as it's inside SingleChildScrollView
              propertyState.status == PropertyStatus.loading &&
                      propertyState.properties.isEmpty
                  ? Center(child: ShimmerWrapper(child: PropertyCardShimmer()))
                  : ListView.builder(
                      // controller: scrollController, // <-- REMOVED: Managed by SingleChildScrollView
                      // <-- NEW: Allows ListView to take only the space it needs
                      shrinkWrap: true,
                      // <-- NEW: Disables inner scrolling so SingleChildScrollView handles it
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: propertyState.properties.length + 1,
                      itemBuilder: (context, index) {
                        // Loader at bottom
                        if (index == propertyState.properties.length) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            child: TextButton(
                              onPressed: () {},

                              style: ButtonStyle(
                                backgroundColor: WidgetStatePropertyAll(
                                  Colors.black12,
                                ),
                                padding: const WidgetStatePropertyAll(
                                  EdgeInsets.symmetric(
                                    vertical: 14,
                                    horizontal: 40,
                                  ),
                                ),
                                shape: WidgetStatePropertyAll(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                foregroundColor: const WidgetStatePropertyAll(
                                  Colors.white,
                                ),
                              ),
                              child: const Text(
                                "Load more",
                                style: TextStyle(
                                  color: Colors.black,

                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          );
                        }

                        final p = propertyState.properties[index];
                        return Container(
                          margin: const EdgeInsets.symmetric(
                            vertical: 5,
                            horizontal: 14,
                          ),
                          child: InkWell(
                            onTap: () => context.push(
                              AppRoutes.singleProperty,
                              extra: p.id,
                            ),
                            child: PropertyCard(
                              imageUrl: p.coverImageUrl,
                              title: p.title,
                              price: p.price,
                            ),
                          ),
                        );
                      },
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
