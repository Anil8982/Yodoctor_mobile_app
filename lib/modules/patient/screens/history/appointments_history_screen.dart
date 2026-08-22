import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yodoctor/modules/widgets/app_snack_bar.dart';
import '../../../../core/utils/responsive.dart';
import '../../controllers/appointment_history_controller.dart';
import '../../widgets/custom_sliver_app_bar.dart';
import '../../widgets/patient_drawer.dart';
import 'widgets/appointment_details_dialog.dart';
import 'widgets/history_appointment_card.dart';
import 'widgets/history_header.dart';
import 'widgets/history_table_header.dart';
import 'widgets/prescription_bottom_sheet.dart';

class AppointmentsHistoryScreen extends ConsumerStatefulWidget {
  const AppointmentsHistoryScreen({super.key});

  @override
  ConsumerState<AppointmentsHistoryScreen> createState() =>
      _AppointmentsHistoryScreenState();
}

class _AppointmentsHistoryScreenState
    extends ConsumerState<AppointmentsHistoryScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      final historyState = ref.read(appointmentHistoryControllerProvider);
      if (historyState.appointments.isEmpty && !historyState.isLoading) {
        ref.read(appointmentHistoryControllerProvider.notifier).refresh();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final historyState = ref.watch(appointmentHistoryControllerProvider);
    final notifier = ref.read(appointmentHistoryControllerProvider.notifier);

    final double horizontal = Responsive.horizontalPadding(context);
    final bool isWideScreen = MediaQuery.sizeOf(context).width >= 980;

    return Scaffold(
      key: _scaffoldKey,
      drawer: const PatientDrawer(),
      backgroundColor: theme.scaffoldBackgroundColor,
      body: NestedScrollView(
        physics: const ClampingScrollPhysics(),
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            CustomSliverAppBar(
              expandedHeight: 220,
              scaffoldKey: _scaffoldKey,
              background: HistoryHeader(
                appointmentCount: historyState.appointments.length,
              ),
            ),
            if (historyState.isLoading)
              SliverToBoxAdapter(
                child: Container(
                  color: theme.scaffoldBackgroundColor,
                  child: const LinearProgressIndicator(minHeight: 3),
                ),
              ),
          ];
        },
        body: historyState.appointments.isEmpty && !historyState.isLoading
            ? _buildEmptyState(context)
            : RefreshIndicator(
                onRefresh: notifier.refresh,
                child: CustomScrollView(
                  physics: const AlwaysScrollableScrollPhysics(
                    parent: BouncingScrollPhysics(),
                  ),
                  slivers: <Widget>[
                    if (isWideScreen)
                      SliverPadding(
                        padding: EdgeInsets.fromLTRB(
                          horizontal,
                          12,
                          horizontal,
                          0,
                        ),
                        sliver: const SliverToBoxAdapter(
                          child: HistoryTableHeader(),
                        ),
                      ),
                    if (historyState.appointments.isEmpty &&
                        historyState.isLoading)
                      SliverFillRemaining(
                        hasScrollBody: false,
                        child: _buildLoadingState(),
                      )
                    else
                      SliverPadding(
                        padding: EdgeInsets.fromLTRB(
                          horizontal,
                          12,
                          horizontal,
                          95,
                        ),
                        sliver: SliverList(
                          delegate: SliverChildBuilderDelegate((
                            BuildContext context,
                            int index,
                          ) {
                            final appointment =
                                historyState.appointments[index];
                            final bool statusIsNotCompleted = !appointment
                                .status
                                .toUpperCase()
                                .contains('COMPLETED');

                            return Padding(
                              padding: const EdgeInsets.only(bottom: 12.0),
                              child: HistoryAppointmentCard(
                                appointment: appointment,
                                onViewDetails: statusIsNotCompleted
                                    ? null
                                    : () {
                                        showAppointmentDetailsDialog(
                                          context: context,
                                          appointment: appointment,
                                          initialRating: notifier.ratingFor(
                                            appointment.id,
                                          ),
                                          initialFeedback: notifier.feedbackFor(
                                            appointment.id,
                                          ),
                                          onSubmitRating:
                                              (
                                                int rating,
                                                String feedback,
                                              ) async {
                                                await notifier.submitRating(
                                                  appointmentId: appointment.id,
                                                  rating: rating,
                                                  feedback: feedback,
                                                );

                                                if (!context.mounted) {
                                                  return;
                                                }

                                                AppSnackBar.show(
                                                  message:
                                                      'Thanks! You rated ${appointment.doctorName} $rating stars.',
                                                  type: AppSnackBarType.success,
                                                );
                                              },
                                          onDownloadPrescription: () async {
                                            try {
                                              final prescription =
                                                  await notifier
                                                      .getPrescription(
                                                        appointment.id,
                                                      );

                                              if (!context.mounted) return;

                                              PrescriptionBottomSheet.show(
                                                context,
                                                prescription,
                                              );
                                            } catch (e) {
                                              if (!context.mounted) return;
                                              AppSnackBar.show(
                                                message: e
                                                    .toString()
                                                    .replaceFirst(
                                                      "Exception: ",
                                                      "",
                                                    ),
                                                type: AppSnackBarType.error,
                                              );
                                            }
                                          },
                                        );
                                      },
                              ),
                            );
                          }, childCount: historyState.appointments.length),
                        ),
                      ),
                  ],
                ),
              ),
      ),
    );
  }

  Widget _buildLoadingState() {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          SizedBox(
            width: 40,
            height: 40,
            child: CircularProgressIndicator(
              strokeWidth: 3,
              valueColor: AlwaysStoppedAnimation<Color>(colorScheme.primary),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Loading appointments...',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    final TextTheme textTheme = Theme.of(context).textTheme;

    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          CircleAvatar(
            radius: 36,
            backgroundColor: colorScheme.surfaceContainerHighest,
            child: Icon(
              Icons.event_busy_rounded,
              size: 36,
              color: colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'No appointment history available',
            style: textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Booked appointments will appear here.',
            style: textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}
