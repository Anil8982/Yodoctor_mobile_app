import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/utils/dummy_data.dart';
import '../../../../core/utils/responsive.dart';
import '../../controllers/appointment_history_controller.dart';
import '../../widgets/custom_sliver_app_bar.dart';
import '../../widgets/patient_drawer.dart';
import 'widgets/appointment_details_dialog.dart';
import 'widgets/history_appointment_card.dart';
import 'widgets/history_header.dart';
import 'widgets/history_table_header.dart';

class AppointmentsHistoryScreen extends ConsumerStatefulWidget {
  const AppointmentsHistoryScreen({super.key});

  @override
  ConsumerState<AppointmentsHistoryScreen> createState() => _AppointmentsHistoryScreenState();
}

class _AppointmentsHistoryScreenState extends ConsumerState<AppointmentsHistoryScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final double horizontal = Responsive.horizontalPadding(context);

    // Watch unified history state structure from manual notifier provider
    final appointmentsAsync = ref.watch(appointmentHistoryProvider);
    final notifier = ref.read(appointmentHistoryProvider.notifier);

    return appointmentsAsync.when(
      loading: () => Scaffold(
        backgroundColor: colorScheme.surfaceContainerLow,
        body: const Center(child: CircularProgressIndicator()),
      ),
      error: (error, stackTrace) => Scaffold(
        backgroundColor: colorScheme.surfaceContainerLow,
        body: Center(child: Text('Error: $error', style: theme.textTheme.bodyMedium)),
      ),
      // 🎯 FIX: Destructured the wrapper state payload to safely extract structural appointments array
      data: (historyState) {
        final appointments = historyState.appointments;
        final bool isRefreshing = appointmentsAsync.isRefreshing;

        return Scaffold(
          key: _scaffoldKey,
          drawer: const PatientDrawer(user: DummyData.currentUser),
          body: NestedScrollView(
            headerSliverBuilder: (context, innerBoxIsScrolled) {
              return <Widget>[
                CustomSliverAppBar(
                  expandedHeight: 220,
                  scaffoldKey: _scaffoldKey,
                  background: HistoryHeader(
                    appointmentCount: appointments.length,
                  ),
                ),
              ];
            },
            body: Padding(
              padding: EdgeInsets.fromLTRB(horizontal, 0, horizontal, 20),
              child: Column(
                children: <Widget>[
                  if (isRefreshing) const LinearProgressIndicator(),
                  if (MediaQuery.sizeOf(context).width >= 980) ...<Widget>[
                    const HistoryTableHeader(),
                    const SizedBox(height: 12),
                  ],
                  Expanded(
                    child: appointments.isEmpty
                        ? _buildEmptyState(context)
                        : ListView.separated(
                      physics: const BouncingScrollPhysics(),
                      itemCount: appointments.length,
                      separatorBuilder: (_, _) => const SizedBox(height: 12),
                      itemBuilder: (BuildContext context, int index) {
                        final appointment = appointments[index];

                        return HistoryAppointmentCard(
                          appointment: appointment,
                          onViewDetails: () {
                            showAppointmentDetailsDialog(
                              context: context,
                              appointment: appointment,
                              initialRating: notifier.ratingFor(appointment.id),
                              initialFeedback: notifier.feedbackFor(appointment.id),
                              onSubmitRating: (int rating, String feedback) async {
                                await notifier.submitRating(
                                  appointmentId: appointment.id,
                                  rating: rating,
                                  feedback: feedback,
                                );

                                if (!context.mounted) return;

                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      'Thanks! You rated ${appointment.doctorName} $rating stars.',
                                    ),
                                    behavior: SnackBarBehavior.floating,
                                  ),
                                );
                              },
                              onDownloadPrescription: () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      'Prescription download started for ${appointment.tokenNumber}.',
                                    ),
                                    behavior: SnackBarBehavior.floating,
                                  ),
                                );
                              },
                            );
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
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
            radius: 28,
            backgroundColor: colorScheme.primaryContainer,
            child: Icon(
              Icons.event_busy_rounded,
              size: 28,
              color: colorScheme.primary,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'No appointment history available',
            style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 6),
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