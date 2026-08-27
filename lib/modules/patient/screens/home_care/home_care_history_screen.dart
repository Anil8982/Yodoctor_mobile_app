import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:yodoctor/core/routes/app_routes.dart';
import 'package:yodoctor/core/theme/app_theme.dart';
import 'package:yodoctor/modules/patient/controllers/home_care_history_controller.dart';
import 'package:yodoctor/modules/patient/screens/home_care/widgets/cancel_booking_dialog.dart';
import 'package:yodoctor/modules/widgets/app_header.dart';
import 'package:yodoctor/modules/widgets/app_snack_bar.dart';

import 'widgets/home_care_booking_details.dart';
import 'widgets/home_care_history_card.dart';
import 'widgets/home_care_history_empty.dart';
import 'widgets/home_care_history_filter.dart';
import 'widgets/home_care_history_shimmer.dart';

class HomeCareHistoryScreen extends ConsumerStatefulWidget {
  const HomeCareHistoryScreen({super.key});

  @override
  ConsumerState<HomeCareHistoryScreen> createState() =>
      _HomeCareHistoryScreenState();
}

class _HomeCareHistoryScreenState extends ConsumerState<HomeCareHistoryScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(homeCareHistoryProvider.notifier).fetchHistory();
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final state = ref.watch(homeCareHistoryProvider);
    final notifier = ref.read(homeCareHistoryProvider.notifier);
    final filteredBookings = notifier.filteredBookings;

    ref.listen(homeCareHistoryProvider, (previous, next) {
      if (next.errorMessage != null &&
          next.errorMessage != previous?.errorMessage) {
        AppSnackBar.show(
          message: next.errorMessage!,
          type: AppSnackBarType.error,
        );
        notifier.clearError();
      }
    });

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: const AppHeader(title: 'Home Care History'),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 10),
            const HomeCareHistoryFilter(),
            Expanded(
              child:
                  state.isLoading &&
                      state.isRefreshing == false &&
                      filteredBookings.isEmpty
                  ? const HomeCareHistoryShimmer()
                  : RefreshIndicator(
                      color: colorScheme.primary,
                      onRefresh: () => notifier.fetchHistory(isRefresh: true),
                      child: filteredBookings.isEmpty
                          ? HomeCareHistoryEmpty(
                              onBookNew: () {
                                context.push(AppRoutes.homeServiceBooking);
                              },
                            )
                          : ListView.builder(
                              physics: const AlwaysScrollableScrollPhysics(
                                parent: BouncingScrollPhysics(),
                              ),
                              padding: const EdgeInsets.all(16),
                              itemCount: filteredBookings.length,
                              itemBuilder: (context, index) {
                                final booking = filteredBookings[index];
                                final isTerminal =
                                    booking.status.toUpperCase() ==
                                        'CANCELLED' ||
                                    booking.status.toUpperCase() == 'COMPLETED';

                                return HomeCareHistoryCard(
                                  booking: booking,
                                  onTap: () {
                                    notifier.fetchBookingDetails(booking.id);
                                    _showDetailsBottomSheet(context);
                                  },
                                  onCancel: isTerminal
                                      ? null
                                      : () => CancelBookingDialog.show(
                                          context,
                                          ref,
                                          bookingId: booking.id,
                                        ),
                                );
                              },
                            ),
                    ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Container(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 20),
          decoration: BoxDecoration(
            color: theme.cardColor,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
            border: Border(
              top: BorderSide(
                color: colorScheme.outlineVariant.withValues(alpha: 0.4),
              ),
            ),
            boxShadow: [
              BoxShadow(
                color: colorScheme.shadow.withValues(alpha: 0.04),
                blurRadius: 10,
                offset: const Offset(0, -4),
              ),
            ],
          ),
          child: SizedBox(
            height: 50,
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () {
                context.push(AppRoutes.homeServiceBooking);
              },
              icon: const Icon(Icons.add_rounded, size: 20),
              label: const Text(
                'Book New Care Service',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: colorScheme.primary,
                foregroundColor: colorScheme.onPrimary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 0,
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _showDetailsBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppTheme.transparent,
      builder: (context) => const HomeCareBookingDetails(),
    ).then((_) {
      ref.read(homeCareHistoryProvider.notifier).clearSelectedBooking();
    });
  }
}
