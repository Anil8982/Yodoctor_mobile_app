import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yodoctor/modules/admin/controllers/admin_dashboard_controller.dart';
import 'package:yodoctor/modules/admin/controllers/doctors_management_controller.dart';
import 'package:yodoctor/modules/admin/screens/doctors_management/doctors_details_screen.dart';
import 'package:yodoctor/modules/admin/screens/doctors_management/widgets/doctor_card.dart';
import 'package:yodoctor/modules/admin/widgets/admin_drawer.dart';
import 'package:yodoctor/modules/admin/widgets/admin_sliver_app_bar.dart';

import 'widgets/doctors_management_header.dart';
import 'widgets/empty_doctor_list_widget.dart';

class DoctorsManagementScreen extends ConsumerWidget {
  DoctorsManagementScreen({super.key});

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    final adminState = ref.watch(adminDashboardProvider);

    final doctorsStateAsync = ref.watch(doctorsManagementProvider);

    return adminState.maybeWhen(
      data: (adminData) {
        final data = adminData.rawData;
        if (data == null) return const SizedBox.shrink();

        return Scaffold(
          key: _scaffoldKey,
          backgroundColor: theme.scaffoldBackgroundColor,
          extendBodyBehindAppBar: true,
          drawer: AdminDrawer(admin: data.admin),
          body: NestedScrollView(
            headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
              return [
                AdminSliverAppBar(
                  expandedHeight: 190,
                  scaffoldKey: _scaffoldKey,
                  background: const DoctorsManagementHeader(),
                ),
              ];
            },
            body: doctorsStateAsync.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (err, stack) => Center(child: Text(err.toString())),
              data: (doctorsState) {
                return RefreshIndicator(
                  onRefresh: () => ref.read(doctorsManagementProvider.notifier).refreshDoctors(),
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 24),

                        /// Search Bar
                        SizedBox(
                          width: 350,
                          child: TextField(
                            onChanged: (val) => ref.read(doctorsManagementProvider.notifier).searchDoctors(val),
                            decoration: InputDecoration(
                              hintText: 'Search by name or city',
                              prefixIcon: const Icon(Icons.search),
                              filled: true,
                              fillColor: Colors.white,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide.none,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 15),

                        /// Filter Chips
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          physics: const BouncingScrollPhysics(),
                          child: Row(
                            children: ['All', 'Pending', 'Approved', 'Rejected'].map((filter) {
                              final isSelected = doctorsState.selectedFilter == filter;

                              return Padding(
                                padding: const EdgeInsets.only(right: 8),
                                child: FilterChip(
                                  label: Text(filter),
                                  selected: isSelected,
                                  onSelected: (_) => ref.read(doctorsManagementProvider.notifier).setFilter(filter),
                                  showCheckmark: false,
                                  selectedColor: theme.colorScheme.primaryContainer,
                                  backgroundColor: theme.colorScheme.surface,
                                  side: BorderSide(color: theme.colorScheme.outlineVariant),
                                  labelStyle: TextStyle(
                                    color: isSelected ? theme.colorScheme.onPrimaryContainer : theme.colorScheme.onSurface,
                                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                                  ),
                                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                        const SizedBox(height: 5),

                        /// Doctors List
                        Expanded(
                          child: doctorsState.filteredDoctors.isEmpty
                              ? const EmptyDoctorListWidget()
                              : ListView.separated(
                            itemCount: doctorsState.filteredDoctors.length,
                            separatorBuilder: (_, _) => const SizedBox(height: 10),
                            itemBuilder: (context, index) {
                              final currentDoctor = doctorsState.filteredDoctors[index];
                              return DoctorCard(
                                doctor: currentDoctor,
                                onDelete: (id) => ref.read(doctorsManagementProvider.notifier).deleteDoctor(id),
                                onViewDetails: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => DoctorDetailsScreen(doctor: currentDoctor),
                                    ),
                                  );
                                },
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        );
      },
      orElse: () => const Scaffold(body: Center(child: CircularProgressIndicator())),
    );
  }
}