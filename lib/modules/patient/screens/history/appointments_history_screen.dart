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
  Widget build(BuildContext context) {
    final historyState = ref.watch(appointmentHistoryControllerProvider);
    final notifier = ref.read(appointmentHistoryControllerProvider.notifier);

    final bool isLoadingInitial =
        historyState.isLoading && historyState.appointments.isEmpty;

    if (isLoadingInitial) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final double horizontal = Responsive.horizontalPadding(context);

    return Scaffold(
      key: _scaffoldKey,
      drawer: const PatientDrawer(),
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return <Widget>[
            CustomSliverAppBar(
              expandedHeight: 220,
              scaffoldKey: _scaffoldKey,
              background: HistoryHeader(
                appointmentCount: historyState.appointments.length,
              ),
            ),
          ];
        },
        body: Padding(
          padding: EdgeInsets.fromLTRB(horizontal, 0, horizontal, 20),
          child: Column(
            children: <Widget>[
              if (historyState.isLoading) const LinearProgressIndicator(),
              if (MediaQuery.sizeOf(context).width >= 980) ...<Widget>[
                const HistoryTableHeader(),
                const SizedBox(height: 12),
              ],
              Expanded(
                child: RefreshIndicator(
                  onRefresh: notifier.refresh,
                  child: historyState.appointments.isEmpty
                      ? _buildEmptyState(context)
                      : ListView.separated(
                          physics: const BouncingScrollPhysics(),
                          itemCount: historyState.appointments.length,
                          separatorBuilder: (_, _) =>
                              const SizedBox(height: 12),
                          itemBuilder: (BuildContext context, int index) {
                            final appointment =
                                historyState.appointments[index];

                            return HistoryAppointmentCard(
                              appointment: appointment,
                              onViewDetails: () {
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
                                      (int rating, String feedback) async {
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
                                      final prescription = await notifier
                                          .getPrescription(appointment.id);

                                      if (!context.mounted) return;

                                      showDialog(
                                        context: context,
                                        builder: (dialogContext) => AlertDialog(
                                          title: const Text("Prescription"),
                                          content: SingleChildScrollView(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                const Text(
                                                  "Medicines",
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                const SizedBox(height: 8),
                                                Text(
                                                  prescription["medicines"] ??
                                                      "",
                                                ),
                                                const SizedBox(height: 20),
                                                const Text(
                                                  "Instructions",
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                const SizedBox(height: 8),
                                                Text(
                                                  prescription["instructions"] ??
                                                      "",
                                                ),
                                              ],
                                            ),
                                          ),
                                          actions: [
                                            TextButton(
                                              onPressed: () =>
                                                  Navigator.pop(dialogContext),
                                              child: const Text("Close"),
                                            ),
                                          ],
                                        ),
                                      );
                                    } catch (e) {
                                      if (!context.mounted) return;
                                      AppSnackBar.show(
                                        message: e.toString().replaceFirst(
                                          "Exception: ",
                                          "",
                                        ),
                                        type: AppSnackBarType.error,
                                        bottomMargin: 0,
                                      );
                                    }
                                  },
                                );
                              },
                            );
                          },
                        ),
                ),
              ),
            ],
          ),
        ),
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
