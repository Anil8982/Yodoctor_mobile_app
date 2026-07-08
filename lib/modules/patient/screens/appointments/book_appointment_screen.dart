import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../models/search/doctor_detail_model.dart';
import '../../../../core/routes/app_routes.dart';
import '../../../../core/theme/app_theme.dart';
import '../../controllers/family_controller.dart';
import 'widgets/appointment_queue_dialog.dart';
import 'models/appointment_queue_info.dart';
import 'widgets/appointment_bottom_bar.dart';
import 'widgets/date_timeline_picker.dart';
import 'widgets/doctor_info_card.dart';
import 'widgets/patient_selection_section.dart';
import 'widgets/session_selection_section.dart';
import 'package:intl/intl.dart';

import '../../controllers/book_appointment_controller.dart';
import '../../models/appointment/book_appointment_request.dart';
import '../../models/family/family_member_model.dart';

class BookAppointmentScreen extends StatefulWidget {
  const BookAppointmentScreen({super.key, required this.doctor});

  final DoctorDetailModel doctor;

  Widget build(BuildContext context) => const SizedBox();

  @override
  State<BookAppointmentScreen> createState() => _BookAppointmentScreenState();
}

class _BookAppointmentScreenState extends State<BookAppointmentScreen> {
  bool _isSelf = true;
  FamilyMemberModel? _selectedFamilyMember;
  DateTime _selectedDate = DateTime.now();
  String _selectedSession = 'Morning';

  Future<void> _pickCustomDate() async {
    final DateTime now = DateTime.now();
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: now,
      lastDate: now.add(const Duration(days: 60)),
    );

    if (picked == null) return;
    setState(() => _selectedDate = picked);
  }

  void _openAddFamily() {
    context.push(AppRoutes.addFamilyMember);
  }

  Future<void> _confirmAppointment() async {
    print("Confirm Clicked");
    final controller = context.read<BookAppointmentController>();

    final request = BookAppointmentRequest(
      doctorId: widget.doctor.doctorId,
      appointmentType: "CLINIC",
      appointmentDate: DateFormat("yyyy-MM-dd").format(_selectedDate),
      slot: _selectedSession == "Morning" ? "MORNING" : "EVENING",
      familyMemberIds: _isSelf ? [] : [_selectedFamilyMember!.id],
    );

    final success = await controller.book(request);

    if (!mounted) return;

    if (!success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(controller.error ?? "Booking Failed")),
      );
      return;
    }

    final result = controller.response!;

    showAppointmentQueueDialog(
      context: context,
      queueInfo: AppointmentQueueInfo(
        doctorName: widget.doctor.doctorName,
        specialty: widget.doctor.specialization,
        patientLabel: _isSelf ? "Self" : _selectedFamilyMember!.fullName,
        tokenNumber: "#${result.token}",
        nowServing: "-",
        estimatedWait: "Not Available",
      ),
    );
  }

  bool get _canConfirm {
    if (_isSelf) return true;
    return _selectedFamilyMember != null;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    final familyController = context.watch<FamilyController>();

    print("========== FAMILY ==========");
    print(familyController.members.length);

    for (final m in familyController.members) {
      print("${m.id} ${m.fullName}");
    }
    final List<FamilyMemberModel> familyMembers = context
        .watch<FamilyController>()
        .members;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        scrolledUnderElevation: 0,
        flexibleSpace: DecoratedBox(
          decoration: BoxDecoration(gradient: AppTheme.patientGradient),
        ),
        title: Text(
          'Book Appointment',
          style: textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w900,
            color: colorScheme.onPrimary,
          ),
        ),
      ),
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
                        DoctorInfoCard(doctor: widget.doctor),
                        const SizedBox(height: 28),

                        _buildSectionHeader(
                          textTheme,
                          colorScheme,
                          '1. Patient Profile',
                        ),
                        const SizedBox(height: 12),
                        PatientSelectionSection(
                          isSelf: _isSelf,
                          familyMembers: familyMembers,
                          selectedFamilyMember: _selectedFamilyMember,
                          onProfileTypeChanged: (value) =>
                              setState(() => _isSelf = value),
                          onMemberChanged: (value) =>
                              setState(() => _selectedFamilyMember = value),
                          onAddFamilyPressed: _openAddFamily,
                        ),
                        const SizedBox(height: 28),

                        _buildSectionHeader(
                          textTheme,
                          colorScheme,
                          '2. Select Date',
                        ),
                        const SizedBox(height: 12),
                        DateTimelinePicker(
                          selectedDate: _selectedDate,
                          onDateSelected: (date) =>
                              setState(() => _selectedDate = date),
                          onCustomDatePick: _pickCustomDate,
                        ),
                        const SizedBox(height: 28),

                        _buildSectionHeader(
                          textTheme,
                          colorScheme,
                          '3. Time Session',
                        ),
                        const SizedBox(height: 12),
                        SessionSelectionSection(
                          selectedSession: _selectedSession,
                          onSessionChanged: (session) {
                            setState(() => _selectedSession = session);
                          },
                          morningTime: widget.doctor.sessionTimings.morning,
                          eveningTime: widget.doctor.sessionTimings.evening,
                        ),
                        const SizedBox(height: 32),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            AppointmentBottomBar(
              consultationFee: widget.doctor.consultationFee.toDouble(),
              canConfirm: _canConfirm,
              onConfirmPressed: _confirmAppointment,
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
