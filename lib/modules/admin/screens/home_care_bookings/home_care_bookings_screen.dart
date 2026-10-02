import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yodoctor/modules/admin/controllers/admin_dashboard_controller.dart';
import 'package:yodoctor/modules/admin/controllers/home_care_bookings_controller.dart';

import 'package:yodoctor/modules/admin/widgets/admin_drawer.dart';
import 'package:yodoctor/modules/admin/widgets/admin_sliver_app_bar.dart';

import 'widgets/empty_bookings_list_widget.dart';
import 'widgets/home_care_booking_card.dart';
import 'widgets/home_care_bookings_header.dart';

class HomeCareBookingsScreen extends ConsumerWidget {
  HomeCareBookingsScreen({super.key});

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    final adminState = ref.watch(adminDashboardProvider);
    final bookingsStateAsync = ref.watch(homeCareBookingsProvider);

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
                  background: const HomeCareBookingsHeader(),
                ),
              ];
            },
            body: bookingsStateAsync.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (err, stack) => Center(child: Text(err.toString())),
              data: (bookingsState) {
                // आकडेमोड (Stats Calculations)
                final totalBookings = bookingsState.allBookings.length;
                final totalServices = bookingsState.allBookings.map((e) => e.service).toSet().length;
                final thisWeekBookings = totalBookings > 1 ? 1 : 0;

                return RefreshIndicator(
                  onRefresh: () => ref.read(homeCareBookingsProvider.notifier).refreshBookings(),
                  child: ListView(
                    padding: const EdgeInsets.all(16),
                    children: [
                      /// SEARCH BAR
                      Row(
                        children: [
                          SizedBox(
                            width: 250,
                            child: TapRegion(
                              onTapOutside: (_) => FocusManager.instance.primaryFocus?.unfocus(),
                              child: TextField(
                                onChanged: (val) => ref.read(homeCareBookingsProvider.notifier).searchBookings(val),
                                decoration: InputDecoration(
                                  hintText: "Search name or service...",
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
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),

                      /// STATS CARDS
                      IntrinsicHeight(
                        child: Row(
                          children: [
                            Expanded(child: _statCard("Total Bookings", totalBookings.toString())),
                            const SizedBox(width: 5),
                            Expanded(child: _statCard("This Week", thisWeekBookings.toString())),
                            const SizedBox(width: 5),
                            Expanded(child: _statCard("Avg. Days", "1.0")),
                            const SizedBox(width: 5),
                            Expanded(child: _statCard("Services", totalServices.toString())),
                          ],
                        ),
                      ),
                      const SizedBox(height: 30),

                      /// LISTING
                      if (bookingsState.filteredBookings.isEmpty)
                        const EmptyBookingsListWidget()
                      else
                        ...bookingsState.filteredBookings.map(
                              (booking) => HomeCareBookingCard(
                            booking: booking,
                            onDelete: (id) => ref.read(homeCareBookingsProvider.notifier).deleteBooking(id),
                          ),
                        ),
                    ],
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

  Widget _statCard(String title, String value) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 42,
            child: Text(title, softWrap: true, style: const TextStyle(color: Colors.grey)),
          ),
          const SizedBox(height: 10),
          Text(
            value,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}