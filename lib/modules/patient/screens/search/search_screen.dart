import 'dart:async';
import 'package:chroma_kit/chroma_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:yodoctor/modules/patient/models/search/doctor_search_model.dart';
import 'package:yodoctor/modules/patient/screens/search/widgets/find_doctors_shimmer.dart';
import 'package:yodoctor/modules/patient/screens/search/widgets/search_suggestions_overlay.dart';
import 'package:yodoctor/modules/widgets/app_snack_bar.dart';

import '../../../../core/routes/app_routes.dart';
import '../../../../core/utils/app_spacing.dart';
import '../../../../core/utils/responsive.dart';
import '../../controllers/doctor_detail_controller.dart';
import '../../controllers/doctor_listing_controller.dart';
import '../../controllers/patient_search_controller.dart';
import '../../models/search/search_params.dart';

import 'widgets/doctor_card.dart';
import 'widgets/hero_section.dart';
import 'widgets/auto_hide_specialty_filter.dart';

class SearchScreen extends ConsumerStatefulWidget {
  const SearchScreen({super.key});

  @override
  ConsumerState<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen> {
  final ScrollController _scrollController = ScrollController();
  late final TextEditingController _locationController;
  late final TextEditingController _searchController;
  final LayerLink _searchLink = LayerLink();
  final LayerLink _locationLink = LayerLink();
  bool _specialtyFilterVisible = true;
  double _lastScrollOffset = 0;
  static const double _scrollThreshold = 50;

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
      // Initial search only if no doctors loaded yet
      final listingState = ref.read(doctorListingControllerProvider);
      if (listingState.doctors.isEmpty) {
        _triggerSearch();
      }
    });

    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _locationController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _onScroll() {
    // Handle specialty filter auto-hide
    final currentOffset = _scrollController.position.pixels;
    final isScrollingDown = currentOffset > _lastScrollOffset;

    if ((currentOffset - _lastScrollOffset).abs() > _scrollThreshold) {
      if (isScrollingDown && _specialtyFilterVisible) {
        setState(() {
          _specialtyFilterVisible = false;
        });
      } else if (!isScrollingDown && !_specialtyFilterVisible) {
        setState(() {
          _specialtyFilterVisible = true;
        });
      }
      _lastScrollOffset = currentOffset;
    }

    // Handle pagination
    final controller = ref.read(doctorListingControllerProvider.notifier);
    final state = ref.read(doctorListingControllerProvider);

    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      if (!state.isLoading && state.hasMore && state.doctors.isNotEmpty) {
        controller.loadMore();
      }
    }
  }

  void _triggerSearch() {
    final searchNotifier = ref.read(patientSearchControllerProvider.notifier);
    final params = searchNotifier.prepareSearch();

    final listingParams = SearchParams(
      search: params.search,
      city: params.city,
    );
    ref.read(doctorListingControllerProvider.notifier).searchDoctors(listingParams);
  }

  void _handleSpecialtySelected(String specialtyName) {
    final notifier = ref.read(patientSearchControllerProvider.notifier);
    notifier.selectSpecialty(specialtyName);
    _triggerSearch();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final horizontalPadding = Responsive.horizontalPadding(context);

    final searchState = ref.watch(patientSearchControllerProvider);
    final notifier = ref.read(patientSearchControllerProvider.notifier);
    final listingState = ref.watch(doctorListingControllerProvider);

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
    final bool mobile = Responsive.isMobile(context);
    final bool desktop = Responsive.isDesktop(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: Stack(
        children: [
          CustomScrollView(
            controller: _scrollController,
            slivers: [
              // --- Redesigned App Bar / Hero Section ---
              SliverAppBar(
                expandedHeight: 240,
                pinned: true,
                stretch: true,
                elevation: 0,
                backgroundColor: colorScheme.primary,
                title: Text(
                  'Find Doctors',
                  style: theme.textTheme.titleLarge?.copyWith(
                    color: colorScheme.onPrimary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                actions: [
                  _buildResultCounter(listingState.doctors.length, colorScheme),
                  const SizedBox(width: AppSpacing.md),
                ],
                flexibleSpace: FlexibleSpaceBar(
                  stretchModes: const [StretchMode.zoomBackground],
                  background: HeroSection(
                    onSearch: _triggerSearch,
                  ),
                ),
              ),

              const SliverToBoxAdapter(child: SizedBox(height: AppSpacing.lg)),

              // --- Featured Specialties Section (Auto-Hiding) ---
              SliverToBoxAdapter(
                child: AnimatedSize(
                  duration: const Duration(milliseconds: 250),
                  curve: Curves.easeInOut,
                  child: _specialtyFilterVisible
                      ? AutoHideSpecialtyFilter(
                    specialties: searchState.specialties,
                    selectedSpecialty: searchState.selectedSpecialty,
                    onSpecialtySelected: _handleSpecialtySelected,
                  )
                      : const SizedBox.shrink(),
                ),
              ),

              // --- Doctors List / Grid Results ---
              if (listingState.isLoading && listingState.doctors.isEmpty)
                const SliverToBoxAdapter(child: FindDoctorsShimmer())
              else if (listingState.error != null)
                SliverFillRemaining(
                  hasScrollBody: false,
                  child: _ErrorView(
                    error: listingState.error!,
                    onRetry: _triggerSearch,
                  ),
                )
              else if (listingState.doctors.isEmpty)
                  const SliverFillRemaining(
                    hasScrollBody: false,
                    child: _EmptyDoctorsView(),
                  )
                else
                  SliverPadding(
                    padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
                    sliver: _buildDoctorGrid(listingState.doctors, mobile, desktop),
                  ),

              // --- Load More Indicator ---
              if (listingState.isLoading && listingState.doctors.isNotEmpty)
                const SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.all(16),
                    child: Center(
                      child: SizedBox(
                        height: 32,
                        width: 32,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                    ),
                  ),
                ),

              const SliverToBoxAdapter(child: SizedBox(height: 100)),
            ],
          ),

          // --- Search Suggestions Overlay (Search Field) ---
          if (hasSearchSuggestions)
            Positioned(
              width: MediaQuery.of(context).size.width - (horizontalPadding * 2) - 64,
              child: CompositedTransformFollower(
                link: _searchLink,
                showWhenUnlinked: false,
                offset: const Offset(0, 70),
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
                        _triggerSearch();
                      },
                    ),
                  ),
                ),
              ),
            ),

          // --- Location Suggestions Overlay ---
          if (hasCitySuggestions)
            Positioned(
              width: MediaQuery.of(context).size.width - (horizontalPadding * 2) - 64,
              child: CompositedTransformFollower(
                link: _locationLink,
                showWhenUnlinked: false,
                offset: const Offset(0, 70),
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
                        _triggerSearch();
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

  Widget _buildResultCounter(int count, ColorScheme colorScheme) {
    return Center(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: ShapeDecoration(
          shape: const StadiumBorder(),
          color: colorScheme.secondaryContainer,
        ),
        child: Text(
          '$count found',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 12,
            color: colorScheme.onSecondaryContainer,
          ),
        ),
      ),
    );
  }

  Widget _buildDoctorGrid(
      List<DoctorSearchModel> doctors,
      bool mobile,
      bool desktop,
      ) {
    if (mobile) {
      return SliverList(
        delegate: SliverChildBuilderDelegate(
              (context, index) => DoctorCard(
            doctor: doctors[index],
            onProfileTap: () => _openDoctorProfile(context, doctors[index]),
            onBookTap: () => _openBookAppointment(context, doctors[index]),
          ),
          childCount: doctors.length,
        ),
      );
    }

    final int columns = desktop ? 3 : 2;
    return SliverGrid(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: columns,
        mainAxisSpacing: AppSpacing.sm,
        crossAxisSpacing: AppSpacing.sm,
        childAspectRatio: desktop ? 1.4 : 1.1,
      ),
      delegate: SliverChildBuilderDelegate(
            (context, index) => DoctorCard(
          doctor: doctors[index],
          onProfileTap: () => _openDoctorProfile(context, doctors[index]),
          onBookTap: () => _openBookAppointment(context, doctors[index]),
        ),
        childCount: doctors.length,
      ),
    );
  }

  void _openDoctorProfile(BuildContext context, DoctorSearchModel doctor) {
    context.push('${AppRoutes.doctorDetail}/${doctor.doctorId}');
  }

  Future<void> _openBookAppointment(
      BuildContext context,
      DoctorSearchModel doctor,
      ) async {
    final detailNotifier = ref.read(doctorDetailControllerProvider.notifier);
    await detailNotifier.loadDoctor(doctor.doctorId);
    final detailState = ref.read(doctorDetailControllerProvider);

    if (context.mounted) {
      if (detailState.doctor == null) {
        context.showErrorSnackBar('Unable to load doctor details');
        return;
      }
      context.push(AppRoutes.bookAppointment, extra: detailState.doctor);
    }
  }

}

class _ErrorView extends StatelessWidget {
  final String error;
  final VoidCallback onRetry;

  const _ErrorView({required this.error, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            size: 64,
            color: Theme.of(context).colorScheme.error,
          ),
          const SizedBox(height: 16),
          Text(
            error,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          const SizedBox(height: 16),
          ElevatedButton(onPressed: onRetry, child: const Text('Retry')),
        ],
      ),
    );
  }
}

class _EmptyDoctorsView extends StatelessWidget {
  const _EmptyDoctorsView();

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(height: 30),
          Icon(
            Icons.person_search_outlined,
            size: 64,
            color: colorScheme.outline,
          ),
          const SizedBox(height: 16),
          Text(
            'No doctors found',
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
          const Text('Try adjusting your search terms or location'),
        ],
      ),
    );
  }
}