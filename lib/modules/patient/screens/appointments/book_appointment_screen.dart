import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:yodoctor/core/constants/log_tags.dart';
import 'package:yodoctor/core/debug/app_logger.dart';
import 'package:yodoctor/modules/patient/controllers/book_appointment_controller.dart';
import 'package:yodoctor/modules/patient/controllers/family_controller.dart';
import 'package:yodoctor/modules/widgets/app_header.dart';
import 'package:yodoctor/modules/widgets/app_snack_bar.dart';
import '../../../../core/routes/app_routes.dart';
import '../../models/search/doctor_detail_model.dart';
import 'models/appointment_queue_info.dart';
import 'widgets/appointment_queue_dialog.dart';
import 'widgets/appointment_bottom_bar.dart';
import 'widgets/date_timeline_picker.dart';
import 'widgets/doctor_info_card.dart';
import 'widgets/patient_selection_section.dart';
import 'widgets/session_selection_section.dart';

class BookAppointmentScreen extends ConsumerWidget {
  // 🎯 Converted to simple ConsumerWidget!
  const BookAppointmentScreen({super.key, required this.doctor});

  final DoctorDetailModel doctor;
  static const String _subTag = 'BookAppointmentScreen';

  Future<void> _pickCustomDate(
    BuildContext context,
    WidgetRef ref,
    DateTime currentDate,
  ) async {
    final DateTime now = DateTime.now();
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: currentDate,
      firstDate: now,
      lastDate: now.add(const Duration(days: 60)),
    );

    if (picked == null) return;
    ref.read(bookAppointmentControllerProvider.notifier).updateDate(picked);
  }

  Future<void> _confirmAppointment(BuildContext context, WidgetRef ref) async {
    AppLogger.info(
      'User triggered appointment confirmation process',
      tag: LogTags.patient,
      subTag: _subTag,
    );

    final notifier = ref.read(bookAppointmentControllerProvider.notifier);
    final success = await notifier.book(doctor.doctorId);

    if (!context.mounted) return;

    if (!success) {
      final controllerState = ref
          .read(bookAppointmentControllerProvider)
          .bookingStatus;
      final errorMsg =
          controllerState.error?.toString() ??
          "Booking Failed. Please try again.";

      AppSnackBar.show(message: errorMsg, type: AppSnackBarType.error);
      return;
    }

    final result = ref
        .read(bookAppointmentControllerProvider)
        .bookingStatus
        .value;
    final currentState = ref.read(bookAppointmentControllerProvider);

    showAppointmentQueueDialog(
      context: context,
      queueInfo: AppointmentQueueInfo(
        doctorName: doctor.doctorName,
        specialty: doctor.specialization,
        patientLabel: currentState.isSelf
            ? "Self"
            : currentState.selectedFamilyMember!.fullName,
        tokenNumber: "#${result?.token ?? ''}",
        nowServing: "-",
        estimatedWait: "Not Available",
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    // 🎯 Accessing global data cleanly
    final familyState = ref.watch(familyControllerProvider);
    final familyMembers = familyState.members;

    // 🎯 Watching the clean controller state
    final bookingCtrl = ref.watch(bookAppointmentControllerProvider);
    final isBookingLoading = bookingCtrl.bookingStatus is AsyncLoading;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,

      appBar: AppHeader(title: 'Book Appointment'),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 640),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 12),
                        DoctorInfoCard(doctor: doctor),
                        const SizedBox(height: 28),

                        _buildSectionHeader(
                          textTheme,
                          colorScheme,
                          '1. Patient Profile',
                        ),
                        const SizedBox(height: 12),
                        PatientSelectionSection(
                          isSelf: bookingCtrl.isSelf,
                          familyMembers: familyMembers,
                          selectedFamilyMember:
                              bookingCtrl.selectedFamilyMember,
                          onProfileTypeChanged: isBookingLoading
                              ? null
                              : (value) => ref
                                    .read(
                                      bookAppointmentControllerProvider
                                          .notifier,
                                    )
                                    .updateProfileType(value),
                          onMemberChanged: isBookingLoading
                              ? null
                              : (value) => ref
                                    .read(
                                      bookAppointmentControllerProvider
                                          .notifier,
                                    )
                                    .updateFamilyMember(value),
                          onAddFamilyPressed: isBookingLoading
                              ? null
                              : () => context.push(AppRoutes.addFamilyMember),
                        ),
                        const SizedBox(height: 28),

                        _buildSectionHeader(
                          textTheme,
                          colorScheme,
                          '2. Select Date',
                        ),
                        const SizedBox(height: 12),
                        DateTimelinePicker(
                          selectedDate: bookingCtrl.selectedDate,
                          onDateSelected: isBookingLoading
                              ? null
                              : (date) => ref
                                    .read(
                                      bookAppointmentControllerProvider
                                          .notifier,
                                    )
                                    .updateDate(date),
                          onCustomDatePick: isBookingLoading
                              ? null
                              : () => _pickCustomDate(
                                  context,
                                  ref,
                                  bookingCtrl.selectedDate,
                                ),
                        ),
                        const SizedBox(height: 28),

                        _buildSectionHeader(
                          textTheme,
                          colorScheme,
                          '3. Time Session',
                        ),
                        const SizedBox(height: 12),
                        SessionSelectionSection(
                          selectedSession: bookingCtrl.selectedSession,
                          onSessionChanged: isBookingLoading
                              ? null
                              : (session) => ref
                                    .read(
                                      bookAppointmentControllerProvider
                                          .notifier,
                                    )
                                    .updateSession(session),
                          morningTime: doctor.sessionTimings.morning,
                          eveningTime: doctor.sessionTimings.evening,
                        ),
                        const SizedBox(height: 32),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            AppointmentBottomBar(
              consultationFee: doctor.consultationFee.toDouble(),
              canConfirm:
                  ref
                      .read(bookAppointmentControllerProvider.notifier)
                      .canConfirm &&
                  !isBookingLoading,
              onConfirmPressed: isBookingLoading
                  ? null
                  : () => _confirmAppointment(context, ref),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(
    TextTheme textTheme,
    ColorScheme colorScheme,
    String title,
  ) {
    return Text(
      title,
      style: textTheme.titleMedium?.copyWith(
        fontWeight: FontWeight.w800,
        color: colorScheme.onSurface,
        letterSpacing: 0.2,
      ),
    );
  }
}
