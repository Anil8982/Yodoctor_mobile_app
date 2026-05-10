import 'package:chroma_kit/chroma_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/routes/app_routes.dart';
import '../../../../core/utils/app_spacing.dart';
import '../../../../core/utils/responsive.dart';
import '../../controllers/patient_search_controller.dart';
import 'widgets/hero_section.dart';
import 'widgets/privacy_section.dart';
import 'widgets/trending_chips.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  late final TextEditingController _locationController;
  late final TextEditingController _searchController;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    final controller = context.read<PatientSearchController>();
    _locationController = TextEditingController(text: controller.location);
    _searchController = TextEditingController(text: controller.query);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (controller.trendingSpecialties.isEmpty) {
        controller.loadTrendingSpecialties();
      }
    });
  }

  @override
  void dispose() {
    _locationController.dispose();
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      extendBodyBehindAppBar: true,

      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        toolbarHeight: 0,
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.light,
        ),
      ),

      body: Container(
        decoration: BoxDecoration(
          color: const Color(0xFFF8FAFC),
        ),
        child: SingleChildScrollView(
          controller: _scrollController,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              HeroSection(
                locationController: _locationController,
                searchController: _searchController,
                onLocationChanged: (val) => context.read<PatientSearchController>().updateLocation(val),
                onQueryChanged: (val) => context.read<PatientSearchController>().updateQuery(val),
                onSearchTap: () => _onSearchTap(context, context.read<PatientSearchController>()),
              ),

              // --- 2. MAIN CONTENT ---
              Consumer<PatientSearchController>(
                builder: (context, controller, child) {
                  final horizontalPadding = Responsive.horizontalPadding(context);

                  return Padding(
                    padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: AppSpacing.xl),

                        // Section Title: "Find by Specialty"
                        Text(
                          'Popular Specialties',
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Colors.blueGrey[900],
                            letterSpacing: 0.5,
                          ),
                        ),
                        const SizedBox(height: AppSpacing.md),

                        // Loading State
                        if (controller.isLoading && controller.trendingSpecialties.isEmpty)
                          _buildShimmerLoading()
                        else if (controller.errorMessage != null)
                          _buildErrorUI(controller)
                        else
                        // Trending Chips with refined styling
                          TrendingChips(
                            items: controller.trendingSpecialties,
                            selectedItem: controller.selectedTrending,
                            onSelect: (specialty) {
                              HapticFeedback.selectionClick();
                              controller.selectTrending(specialty);
                              _searchController.text = specialty;
                            },
                          ),

                        const SizedBox(height: AppSpacing.xxl),

                        // Privacy Section (Refined with a Card look)
                        Container(
                          decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                color: Colors.blue.transparency(0.05),
                                blurRadius: 20,
                                offset: const Offset(0, 10),
                              )
                            ],
                          ),
                          child: const PrivacySection(),
                        ),

                        const SizedBox(height: AppSpacing.xxl),
                      ],
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

  Widget _buildShimmerLoading() {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: List.generate(4, (index) => Container(
        width: 100,
        height: 40,
        decoration: BoxDecoration(
          color: Colors.black12,
          borderRadius: BorderRadius.circular(20),
        ),
      )),
    );
  }

  Widget _buildErrorUI(PatientSearchController controller) {
    return Center(
      child: Column(
        children: [
          const Text('Something went wrong'),
          TextButton(
            onPressed: controller.loadTrendingSpecialties,
            child: const Text('Try Again'),
          ),
        ],
      ),
    );
  }

  void _onSearchTap(BuildContext context, PatientSearchController controller) {
    final query = _searchController.text.trim();
    HapticFeedback.mediumImpact(); // Premium feel on button tap

    if (query.isEmpty) {
      context.go(AppRoutes.findDoctors);
    } else {
      context.go('${AppRoutes.findDoctors}?q=${Uri.encodeComponent(query)}');
    }
  }
}