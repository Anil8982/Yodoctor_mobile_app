import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:yodoctor/core/routes/app_routes.dart';
import 'package:yodoctor/modules/patient/controllers/lab_test_controller.dart';

import '../../../../core/utils/dummy_data.dart';
import 'widgets/lab_hero_section.dart';
import 'widgets/lab_categories_list.dart';
import 'widgets/lab_package_card.dart';
import 'widgets/lab_trust_section.dart';
import 'widgets/lab_support_banner.dart';

class LabTestsScreen extends ConsumerStatefulWidget {
  const LabTestsScreen({super.key});

  @override
  ConsumerState<LabTestsScreen> createState() => _LabTestsScreenState();
}

class _LabTestsScreenState extends ConsumerState<LabTestsScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final selectedCategory = ref.watch(labCategoryProvider);
    final filteredPackages = ref.watch(filteredLabPackagesProvider);
    final cartItems = ref.watch(labCartProvider);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        scrolledUnderElevation: 0,
        title: const Text('Lab Tests'),
        centerTitle: true,
        actions: [
          Stack(
            alignment: Alignment.center,
            children: [
              IconButton(
                icon: const Icon(Icons.shopping_cart_rounded),
                onPressed: () {
                  context.push(AppRoutes.labCart);
                },
              ),
              if (cartItems.isNotEmpty)
                Positioned(
                  right: 6,
                  top: 6,
                  child: CircleAvatar(
                    radius: 8,
                    backgroundColor: colorScheme.error,
                    child: Text(
                      '${cartItems.length}',
                      style: TextStyle(
                        fontSize: 10,
                        color: colorScheme.onError,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            LabHeroSection(controller: _searchController, onSearch: (value) {}),
            const SizedBox(height: 5),
            LabCategoriesList(
              categories: DummyData.labCategories,
              selectedCategoryId: selectedCategory,
              onCategorySelected: (catId) {
                ref.read(labCategoryProvider.notifier).selectCategory(catId);
              },
            ),
            const SizedBox(height: 6),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Available Packages / Tests',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      context.push(AppRoutes.allLabTests);
                    },
                    child: const Text('View All'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            SizedBox(
              height: 283,
              child: filteredPackages.isEmpty
                  ? const Center(
                      child: Text('No tests available in this category'),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      scrollDirection: Axis.horizontal,
                      physics: const BouncingScrollPhysics(),
                      itemCount: filteredPackages.length,
                      itemBuilder: (context, index) {
                        final package = filteredPackages[index];
                        final isInCart = cartItems.any(
                          (item) => item.id == package.id,
                        );

                        return Padding(
                          padding: const EdgeInsets.only(right: 14),
                          child: LabPackageCard(
                            package: package,
                            isInCart: isInCart,
                            onAddToCart: () {
                              ref
                                  .read(labCartProvider.notifier)
                                  .toggleCartItem(package);
                            },
                            onViewDetails: () {
                              context.push(
                                AppRoutes.labTestDetails,
                                extra: package,
                              );
                            },
                          ),
                        );
                      },
                    ),
            ),
            const SizedBox(height: 24),
            const LabTrustSection(),
            const SizedBox(height: 12),
            const LabSupportBanner(),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
