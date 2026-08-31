import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:yodoctor/core/routes/app_routes.dart';
import 'package:yodoctor/modules/patient/controllers/lab_test_controller.dart';
import 'package:yodoctor/modules/widgets/app_header.dart';
import 'widgets/lab_categories_list.dart';
import 'widgets/lab_package_card.dart';

class AllLabTestsScreen extends ConsumerWidget {
  const AllLabTestsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final labState = ref.watch(labProvider);

    final notifier = ref.read(labProvider.notifier);

    final selectedCategory = labState.selectedCategory;

    final filteredPackages = notifier.filteredPackages;
    // final popularTests = labState.popularTests;
    final cartItems = labState.cart;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppHeader(
        title: 'All Packages & Tests',
        actions: [
          Stack(
            alignment: Alignment.center,
            children: [
              IconButton(
                icon: const Icon(Icons.shopping_cart_rounded),
                onPressed: () => context.push(AppRoutes.labCart),
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
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 8),
          LabCategoriesList(
            categories: labState.categories,
            selectedCategoryId: selectedCategory,
            onCategorySelected: (catId) {
              notifier.selectCategory(catId);
            },
          ),
          const SizedBox(height: 12),
          Expanded(
            child: filteredPackages.isEmpty
                ? const Center(
                    child: Text('No tests available in this category'),
                  )
                : GridView.builder(
                    padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
                    physics: const BouncingScrollPhysics(),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 12,
                          childAspectRatio: 0.61,
                        ),
                    itemCount: filteredPackages.length,
                    itemBuilder: (context, index) {
                      final package = filteredPackages[index];
                      final isInCart = cartItems.any(
                        (item) => item.id == package.id,
                      );

                      return LabPackageCard(
                        package: package,
                        isInCart: isInCart,
                        onAddToCart: () {
                          notifier.toggleCartItem(package);
                        },
                        onViewDetails: () {
                          context.push(
                            AppRoutes.labTestDetails,
                            extra: package,
                          );
                        },
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
