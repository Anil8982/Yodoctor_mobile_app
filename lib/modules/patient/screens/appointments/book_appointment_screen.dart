import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../../core/routes/app_routes.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/dummy_data.dart';
import '../../controllers/family_controller.dart';
import 'widgets/appointment_queue_dialog.dart';
import 'models/appointment_queue_info.dart';
import 'widgets/appointment_bottom_bar.dart';
import 'widgets/date_timeline_picker.dart';
import 'widgets/doctor_info_card.dart';
import 'widgets/patient_selection_section.dart';
import 'widgets/session_selection_section.dart';

class BookAppointmentScreen extends StatefulWidget {
  const BookAppointmentScreen({super.key, required this.doctor});

  final DoctorProfile doctor;

  Widget build(BuildContext context) => const SizedBox();

  @override
  State<BookAppointmentScreen> createState() => _BookAppointmentScreenState();
}

class _BookAppointmentScreenState extends State<BookAppointmentScreen> {
  bool _isSelf = true;
  FamilyMember? _selectedFamilyMember;
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

  void _confirmAppointment() {
    final int tokenValue = (DateTime.now().millisecond % 12) + 1;
    final int waitMinutes = (tokenValue - 1) * 5;

    final AppointmentQueueInfo queueInfo = AppointmentQueueInfo(
      doctorName: widget.doctor.name,
      specialty: widget.doctor.specialty,
      patientLabel: _isSelf ? 'Self' : _selectedFamilyMember!.name,
      tokenNumber: '#$tokenValue',
      nowServing: tokenValue > 1 ? '#${tokenValue - 1}' : '-',
      estimatedWait: '$waitMinutes mins',
    );

    showAppointmentQueueDialog(context: context, queueInfo: queueInfo);
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
    final List<FamilyMember> familyMembers = context.watch<FamilyController>().members;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        scrolledUnderElevation: 0,
        backgroundColor: colorScheme.surface.withValues(alpha: 0),
        foregroundColor: colorScheme.onPrimary,
        surfaceTintColor: colorScheme.surface.withValues(alpha: 0),
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

                        _buildSectionHeader(textTheme, colorScheme, '1. Patient Profile'),
                        const SizedBox(height: 12),
                        PatientSelectionSection(
                          isSelf: _isSelf,
                          familyMembers: familyMembers,
                          selectedFamilyMember: _selectedFamilyMember,
                          onProfileTypeChanged: (value) => setState(() => _isSelf = value),
                          onMemberChanged: (value) => setState(() => _selectedFamilyMember = value),
                          onAddFamilyPressed: _openAddFamily,
                        ),
                        const SizedBox(height: 28),

                        _buildSectionHeader(textTheme, colorScheme, '2. Select Date'),
                        const SizedBox(height: 12),
                        DateTimelinePicker(
                          selectedDate: _selectedDate,
                          onDateSelected: (date) => setState(() => _selectedDate = date),
                          onCustomDatePick: _pickCustomDate,
                        ),
                        const SizedBox(height: 28),

                        _buildSectionHeader(textTheme, colorScheme, '3. Time Session'),
                        const SizedBox(height: 12),
                        SessionSelectionSection(
                          selectedSession: _selectedSession,
                          onSessionChanged: (session) => setState(() => _selectedSession = session),
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

  Widget _buildSectionHeader(TextTheme textTheme, ColorScheme colorScheme, String title) {
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
