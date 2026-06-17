import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/routes/app_routes.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/app_spacing.dart';
import '../../../../core/utils/dummy_data.dart';
import '../../../../core/utils/responsive.dart';
import '../../controllers/doctor_listing_controller.dart';
import 'widgets/doctor_card.dart';

class FindDoctorsScreen extends ConsumerStatefulWidget {
  const FindDoctorsScreen({super.key, this.initialQuery = ''});

  final String initialQuery;

  @override
  ConsumerState<FindDoctorsScreen> createState() => _FindDoctorsScreenState();
}

class _FindDoctorsScreenState extends ConsumerState<FindDoctorsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Trigger fetch loop utilizing read context over manual notifier channel
      ref.read(doctorListingProvider.notifier).loadDoctors(
        query: widget.initialQuery,
      );
    });
  }

  @override
  void didUpdateWidget(covariant FindDoctorsScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.initialQuery != widget.initialQuery) {
      ref.read(doctorListingProvider.notifier).loadDoctors(
        query: widget.initialQuery,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final bool mobile = Responsive.isMobile(context);
    final bool desktop = Responsive.isDesktop(context);
    final double horizontal = Responsive.horizontalPadding(context);

    // Watch dynamic asynchronous state wrappers directly from provider
    final listingAsync = ref.watch(doctorListingProvider);
    final notifier = ref.read(doctorListingProvider.notifier);

    return listingAsync.when(
      loading: () => Scaffold(
        backgroundColor: theme.scaffoldBackgroundColor,
        appBar: AppBar(
          flexibleSpace: DecoratedBox(decoration: BoxDecoration(gradient: AppTheme.patientGradient)),
          leading: Center(child: _buildBackButton(context, colorScheme)),
          title: Text('Find Doctors', style: TextStyle(color: colorScheme.onPrimary, fontWeight: FontWeight.bold)),
        ),
        body: const _LoadingView(),
      ),
      error: (error, stack) => Scaffold(
        body: Center(child: Text('Error: $error', style: theme.textTheme.bodyMedium)),
      ),
      data: (listingState) {
        final bool isRefreshing = listingAsync.isRefreshing;

        return Scaffold(
          backgroundColor: theme.scaffoldBackgroundColor,
          appBar: AppBar(
            elevation: 0,
            scrolledUnderElevation: 0,
            flexibleSpace: DecoratedBox(
              decoration: BoxDecoration(gradient: AppTheme.patientGradient),
            ),
            centerTitle: false,
            leadingWidth: 72,
            leading: Center(child: _buildBackButton(context, colorScheme)),
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Find Doctors',
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: colorScheme.onPrimary,
                  ),
                ),
                if (listingState.activeQuery.isNotEmpty)
                  Text(
                    'Results for "${listingState.activeQuery}"',
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: colorScheme.onPrimary.withValues(alpha: 0.8),
                    ),
                  ),
              ],
            ),
            actions: [
              _buildResultCounter(listingState.filteredDoctors.length, colorScheme),
              const SizedBox(width: AppSpacing.md),
            ],
          ),
          body: RefreshIndicator(
            onRefresh: () => notifier.loadDoctors(query: listingState.activeQuery),
            child: CustomScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              slivers: [
                // --- Sticky Filter Section ---
                SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: horizontal,
                      vertical: AppSpacing.md,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (isRefreshing) ...[
                          const LinearProgressIndicator(),
                          const SizedBox(height: AppSpacing.sm),
                        ],
                        if (listingState.activeQuery.trim().isNotEmpty)
                          Padding(
                            padding: const EdgeInsets.only(
                              bottom: AppSpacing.md,
                            ),
                            child: Text(
                              'Results for "${listingState.activeQuery}"',
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: colorScheme.onSurfaceVariant,
                              ),
                            ),
                          ),
                        _buildSpecialtyFilters(listingState, notifier),
                      ],
                    ),
                  ),
                ),

                // --- Doctor Listing ---
                SliverPadding(
                  padding: EdgeInsets.fromLTRB(
                    horizontal,
                    0,
                    horizontal,
                    AppSpacing.xxs,
                  ),
                  sliver: listingState.filteredDoctors.isEmpty
                      ? const SliverToBoxAdapter(
                    child: _EmptyDoctorsView(),
                  )
                      : _buildDoctorGrid(listingState.filteredDoctors, mobile, desktop),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // --- Widgets: Back Button ---
  Widget _buildBackButton(BuildContext context, ColorScheme colorScheme) {
    return IconButton(
      icon: Icon(
        Icons.arrow_back_rounded,
        color: colorScheme.onPrimary,
      ),
      onPressed: () {
        if (context.canPop()) {
          context.pop();
        } else {
          context.go(AppRoutes.dashboard);
        }
      },
    );
  }

  // --- Widgets: Result Counter ---
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

  // --- Widgets: Filter Row ---
  Widget _buildSpecialtyFilters(DoctorListingState listingState, DoctorListingNotifier notifier) {
    // Generate sync categories directly via notifier options query mappings
    final specialtiesList = notifier.getSpecialtiesList();

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      child: Row(
        children: specialtiesList.map((String item) {
          final isSelected = listingState.selectedSpecialty == item;
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: FilterChip(
              label: Text(item),
              selected: isSelected,
              onSelected: (_) => notifier.setSpecialty(item),
              showCheckmark: false,
              labelStyle: TextStyle(
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                color: isSelected
                    ? Theme.of(context).colorScheme.onPrimary
                    : null,
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  // --- Widgets: Doctor List / Grid ---
  Widget _buildDoctorGrid(
      List<DoctorProfile> doctorsList,
      bool mobile,
      bool desktop,
      ) {
    if (mobile) {
      return SliverList(
        delegate: SliverChildBuilderDelegate(
              (context, index) => DoctorCard(
            doctor: doctorsList[index],
            onProfileTap: () => _openDoctorProfile(context, doctorsList[index]),
            onBookTap: () => _openBookAppointment(
              context,
              doctorsList[index],
            ),
          ),
          childCount: doctorsList.length,
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
          doctor: doctorsList[index],
          onProfileTap: () => _openDoctorProfile(context, doctorsList[index]),
          onBookTap: () => _openBookAppointment(
            context,
            doctorsList[index],
          ),
        ),
        childCount: doctorsList.length,
      ),
    );
  }

  void _openDoctorProfile(BuildContext context, DoctorProfile doctor) {
    context.push(AppRoutes.doctorDetail, extra: doctor);
  }

  void _openBookAppointment(BuildContext context, DoctorProfile doctor) {
    context.push(AppRoutes.bookAppointment, extra: doctor);
  }
}

// --- Helper Views ---
class _LoadingView extends StatelessWidget {
  const _LoadingView();
  @override
  Widget build(BuildContext context) {
    return const Center(child: CircularProgressIndicator.adaptive());
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
          const Text('Try adjusting your filters or search query'),
        ],
      ),
    );
  }
}