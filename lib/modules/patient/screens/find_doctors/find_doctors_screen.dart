import 'package:chroma_kit/chroma_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/routes/app_routes.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/app_spacing.dart';
import '../../models/search/doctor_search_model.dart';
import '../../../../core/utils/responsive.dart';
import '../../controllers/doctor_detail_controller.dart';
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
      ref
          .read(doctorListingControllerProvider.notifier)
          .loadDoctors(query: widget.initialQuery);
    });
  }

  @override
  void didUpdateWidget(covariant FindDoctorsScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.initialQuery != widget.initialQuery) {
      ref
          .read(doctorListingControllerProvider.notifier)
          .loadDoctors(query: widget.initialQuery);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    // 🎯 Watching Riverpod state channel directly
    final listingState = ref.watch(doctorListingControllerProvider);
    final controllerNotifier = ref.read(
      doctorListingControllerProvider.notifier,
    );

    final bool mobile = Responsive.isMobile(context);
    final bool desktop = Responsive.isDesktop(context);
    final double horizontal = Responsive.horizontalPadding(context);

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
                  color: colorScheme.onPrimary.transparency(0.8),
                ),
              ),
          ],
        ),
        actions: [
          _buildResultCounter(listingState.foundCount, colorScheme),
          const SizedBox(width: AppSpacing.md),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () =>
            controllerNotifier.loadDoctors(query: listingState.activeQuery),
        child: listingState.isLoading && listingState.doctors.isEmpty
            ? const _LoadingView()
            : CustomScrollView(
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
                          _buildSpecialtyFilters(
                            listingState,
                            controllerNotifier,
                          ),
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
                    sliver: listingState.doctors.isEmpty
                        ? const SliverToBoxAdapter(child: _EmptyDoctorsView())
                        : _buildDoctorGrid(
                            listingState.doctors,
                            mobile,
                            desktop,
                          ),
                  ),
                ],
              ),
      ),
    );
  }

  // --- Widgets: Back Button ---
  Widget _buildBackButton(BuildContext context, ColorScheme colorScheme) {
    return IconButton(
      icon: Icon(Icons.arrow_back_rounded, color: colorScheme.onPrimary),
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
  Widget _buildSpecialtyFilters(
    DoctorListingState state,
    DoctorListingController notifier,
  ) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      child: Row(
        children: state.specialties.map((String item) {
          final isSelected = state.selectedSpecialty == item;
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

    if (!context.mounted) return;

    if (detailState.doctor == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Unable to load doctor details")),
      );
      return;
    }

    context.push(AppRoutes.bookAppointment, extra: detailState.doctor);
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
