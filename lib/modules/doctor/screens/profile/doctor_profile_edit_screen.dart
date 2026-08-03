import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../controllers/doctor_profile_controller.dart';
import '../../widgets/doctor_sliver_app_bar.dart';
import 'widgets/clinic_details_tab.dart';
import 'widgets/consultation_timings_tab.dart';
import 'widgets/documents_tab.dart';
import 'widgets/personal_info_tab.dart';
import 'widgets/practice_type_tab.dart';
import 'widgets/professional_info_tab.dart';
import 'widgets/profile_header_section.dart';

class DoctorProfileEditScreen extends ConsumerStatefulWidget {
  const DoctorProfileEditScreen({super.key});

  @override
  ConsumerState<DoctorProfileEditScreen> createState() =>
      _DoctorProfileEditScreenState();
}

class _DoctorProfileEditScreenState
    extends ConsumerState<DoctorProfileEditScreen>
    with SingleTickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 6, vsync: this);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(doctorProfileProvider.notifier).loadProfile();
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final profileState = ref.watch(doctorProfileProvider);
    final notifier = ref.read(doctorProfileProvider.notifier);
    final doctor = profileState.profile;


    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: colorScheme.surfaceContainerLow,
      extendBodyBehindAppBar: true,
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            DoctorSliverAppBar(
              expandedHeight: 200.0,

              isNavBar: false,
              background: ProfileHeaderSection(doctor: doctor, isEditMode: true),
            ),
            SliverPersistentHeader(
              pinned: true,
              delegate: _SliverTabBarDelegate(
                child: Container(
                  color: colorScheme.surface,
                  child: TabBar(
                    controller: _tabController,
                    isScrollable: true,
                    tabAlignment: TabAlignment.start,
                    labelColor: colorScheme.primary,
                    unselectedLabelColor: colorScheme.onSurfaceVariant,
                    indicatorColor: colorScheme.primary,
                    indicatorSize: TabBarIndicatorSize.tab,
                    dividerColor: colorScheme.outlineVariant.withValues(
                      alpha: 0.5,
                    ),
                    labelStyle: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
                    unselectedLabelStyle: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                    tabs: const [
                      Tab(text: 'Personal'),
                      Tab(text: 'Professional'),
                      Tab(text: 'Clinic Details'),
                      Tab(text: 'Practice Type'),
                      Tab(text: 'Timings'),
                      Tab(text: 'Documents'),
                    ],
                  ),
                ),
              ),
            ),
          ];
        },
        body: SafeArea(
          top: false,
          child: TabBarView(
            controller: _tabController,
            children: [
              PersonalInfoTab(controller: notifier),
              ProfessionalInfoTab(controller: notifier),
              ClinicDetailsTab(controller: notifier),
              PracticeTypeTab(controller: notifier),
              ConsultationTimingsTab(controller: notifier),
              DocumentsTab(controller: notifier),
            ],
          ),
        ),
      ),

      floatingActionButton: FloatingActionButton.extended(
        onPressed: profileState.isLoading
            ? null
            : () async {
                final isValid = await notifier.validateAllTabs(_tabController);
                if (!isValid) return;

                if (!notifier.hasUnsavedChanges()) {
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Profile is already up-to-date! 👌'),
                      ),
                    );
                  }
                  return;
                }
                final success = await notifier.saveProfileChanges();

                if (success && context.mounted) {
                  final messenger = ScaffoldMessenger.of(context);

                  messenger.showSnackBar(
                    const SnackBar(
                      content: Text('Profile updated successfully! 🚀'),
                    ),
                  );

                  context.pop();
                }
              },
        label: Text(
          profileState.isLoading ? 'Saving...' : 'Save Profile',
          style: const TextStyle(fontWeight: FontWeight.w800),
        ),
        icon: profileState.isLoading
            ? SizedBox(
                width: 18,
                height: 18,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: colorScheme.onPrimary,
                ),
              )
            : const Icon(Icons.check_rounded),
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.onPrimary,
      ),
    );
  }
}

class _SliverTabBarDelegate extends SliverPersistentHeaderDelegate {
  final Container child;
  _SliverTabBarDelegate({required this.child});

  @override
  double get minExtent => 48.0;
  @override
  double get maxExtent => 48.0;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) => child;
  @override
  bool shouldRebuild(_SliverTabBarDelegate oldDelegate) => false;
}
