import 'package:chroma_kit/chroma_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:yodoctor/modules/patient/screens/search/widgets/search_suggestions_overlay.dart';
import 'package:yodoctor/modules/patient/screens/search/widgets/specialty_card_list.dart';

import '../../../../core/routes/app_routes.dart';
import '../../../../core/utils/app_spacing.dart';
import '../../../../core/utils/responsive.dart';
import '../../controllers/patient_search_controller.dart';
import 'widgets/hero_section.dart';

class SearchScreen extends ConsumerStatefulWidget {
  const SearchScreen({super.key});

  @override
  ConsumerState<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen> {
  late final TextEditingController _locationController;
  late final TextEditingController _searchController;
  final LayerLink _searchLink = LayerLink();
  final LayerLink _locationLink = LayerLink();

  @override
  void initState() {
    super.initState();
    final searchState = ref.read(patientSearchControllerProvider);

    _locationController = TextEditingController(
      text: searchState.locationQuery,
    );
    _searchController = TextEditingController(text: searchState.searchQuery);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final notifier = ref.read(patientSearchControllerProvider.notifier);
      if (searchState.specialties.isEmpty) {
        notifier.initialize();
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
    final horizontalPadding = Responsive.horizontalPadding(context);

    final searchState = ref.watch(patientSearchControllerProvider);
    final notifier = ref.read(patientSearchControllerProvider.notifier);

    // Sync Text Controllers gracefully
    if (_searchController.text != searchState.searchQuery) {
      _searchController.value = _searchController.value.copyWith(
        text: searchState.searchQuery,
        selection: TextSelection.collapsed(
          offset: searchState.searchQuery.length,
        ),
      );
    }
    if (_locationController.text != searchState.locationQuery) {
      _locationController.value = _locationController.value.copyWith(
        text: searchState.locationQuery,
        selection: TextSelection.collapsed(
          offset: searchState.locationQuery.length,
        ),
      );
    }

    final hasSearchSuggestions = searchState.searchSuggestions.isNotEmpty;
    final hasCitySuggestions = searchState.citySuggestions.isNotEmpty;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: Stack(
        children: [
          NestedScrollView(
            headerSliverBuilder: (context, innerBoxIsScrolled) {
              return [
                SliverAppBar(
                  expandedHeight: 225,
                  pinned: true,
                  stretch: true,
                  elevation: 0,
                  backgroundColor: colorScheme.primary,
                  title: Text(
                    'Search Doctors',
                    style: theme.textTheme.titleLarge?.copyWith(
                      color: colorScheme.onPrimary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  flexibleSpace: FlexibleSpaceBar(
                    stretchModes: const [StretchMode.zoomBackground],
                    background: HeroSection(
                      locationController: _locationController,
                      searchController: _searchController,
                      searchLayerLink: _searchLink,
                      locationLayerLink: _locationLink,
                      onLocationChanged: (val) => notifier.updateLocation(val),
                      onQueryChanged: (val) => notifier.updateSearch(val),
                      onSearchTap: () => _onSearchTap(context),
                    ),
                  ),
                ),
              ];
            },
            body: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: AppSpacing.xxl),
                  _buildSectionHeader(theme, 'Featured Specialties'),
                  SpecialtyCardList(
                    specialties: searchState.specialties,
                    onTap: (specialtyName) {
                      notifier.selectSpecialty(specialtyName);
                      if (context.mounted) {
                        _onSearchTap(context);
                      }
                    },
                  ),
                  const SizedBox(height: 100),
                ],
              ),
            ),
          ),
          if (hasSearchSuggestions)
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
                        color: colorScheme.outlineVariant.transparency(0.4),
                      ),
                    ),
                    child: SearchSuggestionsOverlay(
                      suggestions: searchState.searchSuggestions,
                      searchController: _searchController,
                      searchQuery: searchState.searchQuery,
                      onSelect: (suggestion) {
                        notifier.selectSuggestion(suggestion);
                        _onSearchTap(context);
                      },
                    ),
                  ),
                ),
              ),
            ),
          if (hasCitySuggestions)
            Positioned(
              width:
                  MediaQuery.of(context).size.width -
                  (horizontalPadding * 2) -
                  64,
              child: CompositedTransformFollower(
                link: _locationLink,
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
                        color: colorScheme.outlineVariant.transparency(0.4),
                      ),
                    ),
                    child: SearchSuggestionsOverlay(
                      suggestions: searchState.citySuggestions,
                      searchController: _locationController,
                      searchQuery: searchState.locationQuery,
                      onSelect: (suggestion) {
                        notifier.selectCity(suggestion);
                      },
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  void _onSearchTap(BuildContext context) {
    final controller = ref.read(patientSearchControllerProvider.notifier);

    final params = controller.prepareSearch();

    final queryParams = <String, String>{};
    if (params.search.trim().isNotEmpty) {
      queryParams['q'] = params.search.trim();
    }
    if (params.city.trim().isNotEmpty) {
      queryParams['city'] = params.city.trim();
    }

    if (queryParams.isEmpty) {
      context.push(AppRoutes.findDoctors);
      return;
    }

    final queryString = queryParams.entries
        .map(
          (e) =>
              '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}',
        )
        .join('&');

    context.push('${AppRoutes.findDoctors}?$queryString');
  }

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
