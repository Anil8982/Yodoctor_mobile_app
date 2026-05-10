import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/routes/app_routes.dart';
import '../../../../core/utils/app_spacing.dart';
import '../../../../core/utils/responsive.dart';
import '../../../../core/widgets/app_chip.dart';
import '../../controllers/doctor_listing_controller.dart';
import 'widgets/doctor_card.dart';

class FindDoctorsScreen extends StatefulWidget {
  const FindDoctorsScreen({super.key, this.initialQuery = ''});

  final String initialQuery;

  @override
  State<FindDoctorsScreen> createState() => _FindDoctorsScreenState();
}

class _FindDoctorsScreenState extends State<FindDoctorsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<DoctorListingController>().loadDoctors(query: widget.initialQuery);
    });
  }

  @override
  void didUpdateWidget(covariant FindDoctorsScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.initialQuery != widget.initialQuery) {
      context.read<DoctorListingController>().loadDoctors(query: widget.initialQuery);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<DoctorListingController>(
      builder: (context, controller, child) {
        final bool mobile = Responsive.isMobile(context);
        final bool desktop = Responsive.isDesktop(context);
        final double horizontal = Responsive.horizontalPadding(context);

        final bool loading = controller.isLoading;
        final String? error = controller.errorMessage;

        return Scaffold(
          appBar: AppBar(
            title: const Text('Find Doctors'),
            leadingWidth: 64,
            leading: Padding(
              padding: const EdgeInsets.only(left: 16),
              child: IconButton(
                style: IconButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 18),
                onPressed: () {
                  if (context.canPop()) {
                    context.pop();
                  } else {
                    context.go(AppRoutes.dashboard);
                  }
                },
              ),
            ),
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 16),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(99),
                  ),
                  child: Text(
                    '${controller.foundCount} found',
                    style: Theme.of(context).textTheme.labelLarge?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                ),
              ),
            ],
          ),
          body: SafeArea(
            top: false,
            bottom: false,
            child: loading && controller.doctors.isEmpty
                ? const Center(child: CircularProgressIndicator())
                : error != null && controller.doctors.isEmpty
                    ? Center(
                        child: Padding(
                          padding: const EdgeInsets.all(AppSpacing.xl),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              Text(error, textAlign: TextAlign.center),
                              const SizedBox(height: AppSpacing.sm),
                              FilledButton(
                                onPressed: () =>
                                    controller.loadDoctors(query: widget.initialQuery),
                                child: const Text('Retry'),
                              ),
                            ],
                          ),
                        ),
                      )
                    : ResponsiveContainer(
                        child: RefreshIndicator(
                          onRefresh: () => controller.loadDoctors(
                            query: controller.activeQuery,
                          ),
                          child: SingleChildScrollView(
                            physics: const AlwaysScrollableScrollPhysics(),
                            child: Padding(
                              padding: EdgeInsets.fromLTRB(
                                horizontal,
                                AppSpacing.md,
                                horizontal,
                                AppSpacing.xl,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  if (controller.activeQuery.trim().isNotEmpty) ...<Widget>[
                                    const SizedBox(height: AppSpacing.sm),
                                    Text(
                                      'Results for "${controller.activeQuery}"',
                                      style: Theme.of(context).textTheme.bodyMedium,
                                    ),
                                  ],
                                  const SizedBox(height: AppSpacing.md),
                                  SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    child: Row(
                                      children: controller.specialties
                                          .map(
                                            (String item) => Padding(
                                              padding: const EdgeInsets.only(right: 8),
                                              child: AppChip(
                                                label: item,
                                                selected: controller.selectedSpecialty == item,
                                                onSelected: (_) =>
                                                    controller.setSpecialty(item),
                                              ),
                                            ),
                                          )
                                          .toList(),
                                    ),
                                  ),
                                  const SizedBox(height: AppSpacing.md),
                                  if (controller.doctors.isEmpty)
                                    const _EmptyDoctorsView()
                                  else
                                    LayoutBuilder(
                                      builder:
                                          (BuildContext context, BoxConstraints c) {
                                        if (mobile) {
                                          return Column(
                                            children: controller.doctors
                                                .map(
                                                  (doctor) => Padding(
                                                    padding: const EdgeInsets.only(
                                                      bottom: AppSpacing.md,
                                                    ),
                                                    child: DoctorCard(
                                                      doctor: doctor,
                                                      onProfileTap: () =>
                                                          _showPlaceholder(
                                                        context,
                                                        'Profile',
                                                      ),
                                                      onBookTap: () =>
                                                          _showPlaceholder(
                                                        context,
                                                        'Book Appointment',
                                                      ),
                                                      onContactTap: () =>
                                                          _showPlaceholder(
                                                        context,
                                                        'Contact',
                                                      ),
                                                    ),
                                                  ),
                                                )
                                                .toList(),
                                          );
                                        }

                                        final int columns = desktop ? 3 : 2;
                                        final double spacing = AppSpacing.md;
                                        final double itemWidth =
                                            (c.maxWidth - ((columns - 1) * spacing)) /
                                                columns;

                                        return Wrap(
                                          spacing: spacing,
                                          runSpacing: spacing,
                                          children: controller.doctors
                                              .map(
                                                (doctor) => SizedBox(
                                                  width: itemWidth,
                                                  child: DoctorCard(
                                                    doctor: doctor,
                                                    onProfileTap: () =>
                                                        _showPlaceholder(
                                                      context,
                                                      'Profile',
                                                    ),
                                                    onBookTap: () =>
                                                        _showPlaceholder(
                                                      context,
                                                      'Book Appointment',
                                                    ),
                                                    onContactTap: () =>
                                                        _showPlaceholder(
                                                      context,
                                                      'Contact',
                                                    ),
                                                  ),
                                                ),
                                              )
                                              .toList(),
                                        );
                                      },
                                    ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
          ),
        );
      },
    );
  }

  void _showPlaceholder(BuildContext context, String action) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('$action flow will be connected to API soon.')),
    );
  }
}

class _EmptyDoctorsView extends StatelessWidget {
  const _EmptyDoctorsView();

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Row(
          children: <Widget>[
            const Icon(Icons.search_off_rounded),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: Text(
                'No doctors matched your search.',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
