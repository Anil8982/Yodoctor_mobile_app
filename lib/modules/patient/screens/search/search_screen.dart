import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:yodoctor/modules/patient/screens/search/widgets/search_suggestions_overlay.dart';
import 'package:yodoctor/modules/patient/screens/search/widgets/specialty_card_list.dart';
import 'package:yodoctor/modules/patient/widgets/custom_sliver_app_bar.dart';

import '../../../../core/routes/app_routes.dart';
import '../../../../core/utils/app_spacing.dart';

import '../../../../core/utils/responsive.dart';
import '../../controllers/patient_search_controller.dart';
import '../../widgets/patient_drawer.dart';
import 'widgets/hero_section.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  late final TextEditingController _locationController;
  late final TextEditingController _searchController;

  final LayerLink _searchLink = LayerLink();

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
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      key: _scaffoldKey,
      drawer: const PatientDrawer(),
      backgroundColor: theme.scaffoldBackgroundColor,
      body: Consumer<PatientSearchController>(
        builder: (context, controller, child) {
          final horizontalPadding = Responsive.horizontalPadding(context);
          final hasSuggestions = controller.doctorSuggestions.isNotEmpty;

          return Stack(
            children: [
              NestedScrollView(
                headerSliverBuilder: (context, innerBoxIsScrolled) {
                  return [
                    CustomSliverAppBar(
                      expandedHeight: 290.0,
                      scaffoldKey: _scaffoldKey,
                      background: HeroSection(
                        locationController: _locationController,
                        searchController: _searchController,
                        searchLayerLink: _searchLink,
                        onLocationChanged: (val) =>
                            controller.updateLocation(val),
                        onQueryChanged: (val) => controller.updateQuery(val),
                        onSearchTap: () => _onSearchTap(context, controller),
                      ),
                    ),
                  ];
                },

                body: SingleChildScrollView(
                  padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: AppSpacing.xl),

                      // 1. QUICK ACTION BAR (Icon + Text in a row)
                      _buildQuickActions(colorScheme),

                      const SizedBox(height: AppSpacing.xxl),

                      // 2. FEATURED SPECIALTIES (With Depth)
                      _buildSectionHeader(theme, 'Featured Specialties'),
                      SpecialtyCardList(
                        specialties: controller.trendingSpecialties,
                        onTap: (specialtyName) {
                          controller.selectTrending(specialtyName);
                          _searchController.text = specialtyName;
                          _onSearchTap(context, controller);
                        },
                      ),
                      const SizedBox(height: AppSpacing.xxl),

                      const SizedBox(height: 100),
                    ],
                  ),
                ),
              ),

              if (hasSuggestions)
                Positioned(
                  width:
                      MediaQuery.of(context).size.width -
                      (horizontalPadding * 2) -
                      64,
                  child: CompositedTransformFollower(
                    link: _searchLink,
                    showWhenUnlinked: false,
                    offset: const Offset(0, 56),
                    child: Material(
                      elevation: 24,
                      borderRadius: BorderRadius.circular(24),
                      color: colorScheme.surface,
                      child: Container(
                        constraints: const BoxConstraints(maxHeight: 350),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(24),
                          border: Border.all(
                            color: colorScheme.outlineVariant.withValues(
                              alpha: 0.4,
                            ),
                          ),
                        ),
                        child: SearchSuggestionsOverlay(
                          controller: controller,
                          searchController: _searchController,
                          onSearchTap: _onSearchTap,
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }

  void _onSearchTap(BuildContext context, PatientSearchController controller) {
    final query = _searchController.text.trim();
    if (query.isEmpty) {
      context.push(AppRoutes.findDoctors);
    } else {
      context.push('${AppRoutes.findDoctors}?q=${Uri.encodeComponent(query)}');
    }
  }

  // 1. Horizontal Quick Actions (Clean Glassmorphic Feel)
  Widget _buildQuickActions(ColorScheme colorScheme) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _actionItem(Icons.near_me_rounded, 'Near Me', colorScheme),
        _actionItem(Icons.star_rounded, 'Top Rated', colorScheme),
        _actionItem(Icons.bolt_rounded, 'Available', colorScheme),
        _actionItem(
          Icons.local_fire_department_rounded,
          'Trending',
          colorScheme,
        ),
      ],
    );
  }

  Widget _actionItem(IconData icon, String label, ColorScheme colorScheme) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: colorScheme.primary.withValues(alpha: 0.05),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: colorScheme.primary, size: 24),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  // 3. Section Header Helper
  Widget _buildSectionHeader(ThemeData theme, String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(
        title,
        style: theme.textTheme.titleMedium?.copyWith(
          fontWeight: FontWeight.w900,
          letterSpacing: -0.5,
        ),
      ),
    );
  }
}
