import 'package:flutter/material.dart';
import '../../../../core/utils/app_spacing.dart';
import 'widgets/booking_header.dart';
import 'widgets/manual_booking_form.dart';

class ManualBookingScreen extends StatefulWidget {
  const ManualBookingScreen({super.key});

  @override
  State<ManualBookingScreen> createState() => _ManualBookingScreenState();
}

class _ManualBookingScreenState extends State<ManualBookingScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _patientNameController = TextEditingController();
  final TextEditingController _mobileController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  String _selectedShift = 'Evening Shift';

  @override
  void dispose() {
    _patientNameController.dispose();
    _mobileController.dispose();
    _ageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        title: const Text(
          'Walk-in Registration',
          style: TextStyle(fontWeight: FontWeight.w900, fontSize: 18),
        ),
        centerTitle: true,
        backgroundColor: colorScheme.surface,
        foregroundColor: colorScheme.onSurface,
        elevation: 0,
        scrolledUnderElevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl, vertical: AppSpacing.lg),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 460),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const BookingHeader(),
                const SizedBox(height: AppSpacing.xxl),
                ManualBookingForm(
                  formKey: _formKey,
                  patientNameController: _patientNameController,
                  mobileController: _mobileController,
                  ageController: _ageController,
                  selectedShift: _selectedShift,
                  onShiftChanged: (value) {
                    if (value == null) return;
                    setState(() => _selectedShift = value);
                  },
                  onSubmit: _bookAppointment,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _bookAppointment() {
    if (!_formKey.currentState!.validate()) return;

    final primaryColor = Theme.of(context).colorScheme.primary;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle_rounded, color: Colors.white, size: 20),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                'Booked successfully for ${_patientNameController.text.trim()}',
                style: const TextStyle(fontWeight: FontWeight.w700),
              ),
            ),
          ],
        ),
        behavior: SnackBarBehavior.floating,
        backgroundColor: primaryColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      ),
    );

    _patientNameController.clear();
    _mobileController.clear();
    _ageController.clear();
    setState(() => _selectedShift = 'Evening Shift');
  }
}