import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:yodoctor/modules/widgets/app_header.dart';
import 'package:yodoctor/modules/widgets/app_snack_bar.dart';

import '../../../../core/routes/app_routes.dart';
import '../../../../core/utils/app_spacing.dart';
import '../../../../core/utils/responsive.dart';
import '../../controllers/doctor_detail_controller.dart';
import '../../controllers/doctor_listing_controller.dart';
import '../../controllers/patient_search_controller.dart';
import '../../models/search/doctor_search_model.dart';
import '../../models/search/search_params.dart';
import 'widgets/doctor_card.dart';
import 'widgets/find_doctors_shimmer.dart';

class FindDoctorsScreen extends ConsumerStatefulWidget {
  const FindDoctorsScreen({super.key, this.search = '', this.city = ''});

  final String search;
  final String city;

  @override
  ConsumerState<FindDoctorsScreen> createState() => _FindDoctorsScreenState();
}

class _FindDoctorsScreenState extends ConsumerState<FindDoctorsScreen> {
  final ScrollController _scrollController = ScrollController();
  late final TextEditingController _searchController;
  late final TextEditingController _locationController;
  final FocusNode _searchFocus = FocusNode();

  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController(text: widget.search);
    _locationController = TextEditingController(text: widget.city);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final params = SearchParams(search: widget.search, city: widget.city);
      ref.read(doctorListingControllerProvider.notifier).searchDoctors(params);
    });

    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _searchController.dispose();
    _locationController.dispose();
    _searchFocus.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant FindDoctorsScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.search != widget.search || oldWidget.city != widget.city) {
      _searchController.text = widget.search;
      _locationController.text = widget.city;
      final params = SearchParams(search: widget.search, city: widget.city);
      ref.read(doctorListingControllerProvider.notifier).searchDoctors(params);
    }
  }

  void _onScroll() {
    final controller = ref.read(doctorListingControllerProvider.notifier);
    final state = ref.read(doctorListingControllerProvider);

    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      if (!state.isLoading && state.hasMore && state.doctors.isNotEmpty) {
        controller.loadMore();
      }
    }
  }

  // ५००ms चा डिले देऊन सर्च कॉल करणारे फंक्शन
  void _onSearchChanged(String text) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();

    if (text.trim().isEmpty) {
      _debounce = Timer(const Duration(milliseconds: 500), () {
        _performSearch();
      });
    }
  }

  void _performSearch() {
    _debounce?.cancel(); // मॅन्युअली सर्च बटणावर किंवा सब्मिट केल्यावर टायमर कॅन्सल
    final search = _searchController.text.trim();
    final city = _locationController.text.trim();

    final patientNotifier = ref.read(patientSearchControllerProvider.notifier);
    if (search.isNotEmpty) {
      patientNotifier.updateSearch(search);
    } else {
      patientNotifier.clearSearch();
    }
    if (city.isNotEmpty) {
      patientNotifier.updateLocation(city);
    } else {
      patientNotifier.clearLocation();
    }

    final params = SearchParams(search: search, city: city);
    ref.read(doctorListingControllerProvider.notifier).searchDoctors(params);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final listingState = ref.watch(doctorListingControllerProvider);
    final controllerNotifier = ref.read(
      doctorListingControllerProvider.notifier,
    );

    final bool mobile = Responsive.isMobile(context);
    final bool desktop = Responsive.isDesktop(context);
    final double horizontal = Responsive.horizontalPadding(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppHeader(
        title: 'Find Doctors',
        actions: [
          _buildResultCounter(listingState.doctors.length, colorScheme),
          const SizedBox(width: AppSpacing.md),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () => controllerNotifier.refresh(),
        child: CustomScrollView(
          controller: _scrollController,
          physics: const AlwaysScrollableScrollPhysics(),
          slivers: [
            SliverToBoxAdapter(child: _buildSearchBar(context)),
            const SliverToBoxAdapter(child: SizedBox(height: AppSpacing.md)),

            if (listingState.isLoading)
              const SliverToBoxAdapter(child: FindDoctorsShimmer())
            else if (listingState.error != null)
              SliverFillRemaining(
                hasScrollBody: false,
                child: _ErrorView(
                  error: listingState.error!,
                  onRetry: controllerNotifier.retry,
                ),
              )
            else if (listingState.doctors.isEmpty)
                const SliverFillRemaining(
                  hasScrollBody: false,
                  child: _EmptyDoctorsView(),
                )
              else
                SliverPadding(
                  padding: EdgeInsets.fromLTRB(
                    horizontal,
                    0,
                    horizontal,
                    AppSpacing.xxs,
                  ),
                  sliver: _buildDoctorGrid(listingState.doctors, mobile, desktop),
                ),

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

            if (!listingState.hasMore && listingState.doctors.isNotEmpty)
              const SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Center(child: Text('No more doctors to load')),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchBar(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final horizontal = Responsive.horizontalPadding(context);

    return Padding(
      padding: EdgeInsets.fromLTRB(horizontal, AppSpacing.md, horizontal, 0),
      child: Container(
        decoration: BoxDecoration(
          color: colorScheme.surface,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: colorScheme.outlineVariant.withValues(alpha: 0.6),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.03),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.sm),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // --- Location Field ---
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Icon(
                      Icons.location_on_rounded,
                      color: colorScheme.primary,
                      size: 20,
                    ),
                  ),
                  Expanded(
                    child: TextField(
                      controller: _locationController,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: colorScheme.onSurface,
                      ),
                      onChanged: _onSearchChanged,
                      decoration: InputDecoration(
                        hintText: 'Location',
                        hintStyle: theme.textTheme.bodyMedium?.copyWith(
                            color: colorScheme.onSurfaceVariant
                        ),
                        border: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        isDense: true,
                        contentPadding: const EdgeInsets.symmetric(
                          vertical: 10,
                          horizontal: 4,
                        ),
                      ),
                      onSubmitted: (_) => _performSearch(),
                    ),
                  ),
                  ValueListenableBuilder<TextEditingValue>(
                    valueListenable: _locationController,
                    builder: (context, value, child) {
                      final hasText = value.text.isNotEmpty;
                      return IgnorePointer(
                        ignoring: !hasText,
                        child: AnimatedOpacity(
                          duration: const Duration(milliseconds: 150),
                          opacity: hasText ? 1.0 : 0.0,
                          child: SizedBox(
                            width: 36,
                            height: 36,
                            child: IconButton(
                              padding: EdgeInsets.zero,
                              icon: Icon(
                                Icons.close_rounded,
                                size: 18,
                                color: colorScheme.onSurfaceVariant,
                              ),
                              onPressed: () {
                                _locationController.clear();
                                _performSearch();
                              },
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),

              Divider(
                height: 16,
                thickness: 1,
                color: colorScheme.outlineVariant.withValues(alpha: 0.4),
              ),

              // --- Search Field ---
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Icon(
                      Icons.search_rounded,
                      color: colorScheme.primary,
                      size: 20,
                    ),
                  ),
                  Expanded(
                    child: TextField(
                      controller: _searchController,
                      focusNode: _searchFocus,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: colorScheme.onSurface,
                      ),
                      onChanged: _onSearchChanged,
                      decoration: InputDecoration(
                        hintText: 'Search doctors, specialties...',
                        hintStyle: theme.textTheme.bodyMedium?.copyWith(
                            color: colorScheme.onSurfaceVariant
                        ),
                        border: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        isDense: true,
                        contentPadding: const EdgeInsets.symmetric(
                          vertical: 10,
                          horizontal: 4,
                        ),
                      ),
                      onSubmitted: (_) => _performSearch(),
                    ),
                  ),
                  ValueListenableBuilder<TextEditingValue>(
                    valueListenable: _searchController,
                    builder: (context, value, child) {
                      final hasText = value.text.isNotEmpty;
                      return IgnorePointer(
                        ignoring: !hasText,
                        child: AnimatedOpacity(
                          duration: const Duration(milliseconds: 150),
                          opacity: hasText ? 1.0 : 0.0,
                          child: SizedBox(
                            width: 36,
                            height: 36,
                            child: IconButton(
                              padding: EdgeInsets.zero,
                              icon: Icon(
                                Icons.close_rounded,
                                size: 18,
                                color: colorScheme.onSurfaceVariant,
                              ),
                              onPressed: () {
                                _searchController.clear();
                                _performSearch();
                              },
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                  const SizedBox(width: AppSpacing.xs),
                  Material(
                    color: colorScheme.primary,
                    borderRadius: BorderRadius.circular(12),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(12),
                      onTap: _performSearch,
                      child: Padding(
                        padding: const EdgeInsets.all(10),
                        child: Icon(
                          Icons.arrow_forward_rounded,
                          color: colorScheme.onPrimary,
                          size: 20,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
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
          const SizedBox(height: 50),
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