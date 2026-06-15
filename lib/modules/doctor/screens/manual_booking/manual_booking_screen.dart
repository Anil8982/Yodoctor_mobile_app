import 'package:flutter/material.dart';
import '../../../../core/utils/app_spacing.dart';

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
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surfaceContainer,
      appBar: AppBar(
        title: const Text('Manual Booking'),
        backgroundColor: colorScheme.surface,
        foregroundColor: colorScheme.onSurface,
        elevation: 0,
        scrolledUnderElevation: 0,
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(AppSpacing.xl, AppSpacing.xl, AppSpacing.xl, AppSpacing.xxxl),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 500),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'New Registration',
                    style: theme.textTheme.headlineMedium?.copyWith(
                      color: colorScheme.onSurface,
                      fontWeight: FontWeight.w900,
                      letterSpacing: -0.7,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xxs),
                  Text(
                    'Register a walk-in patient appointment manually.',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xl),
                  _ManualBookingCard(
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
      ),
    );
  }

  void _bookAppointment() {
    if (!_formKey.currentState!.validate()) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Appointment booked for ${_patientNameController.text.trim()}')),
    );

    _patientNameController.clear();
    _mobileController.clear();
    _ageController.clear();
    setState(() => _selectedShift = 'Evening Shift');
  }
}

class _ManualBookingCard extends StatelessWidget {
  const _ManualBookingCard({
    required this.formKey,
    required this.patientNameController,
    required this.mobileController,
    required this.ageController,
    required this.selectedShift,
    required this.onShiftChanged,
    required this.onSubmit,
  });

  final GlobalKey<FormState> formKey;
  final TextEditingController patientNameController;
  final TextEditingController mobileController;
  final TextEditingController ageController;
  final String selectedShift;
  final ValueChanged<String?> onShiftChanged;
  final VoidCallback onSubmit;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.all(AppSpacing.xl),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: colorScheme.outlineVariant.withValues(alpha: 0.22)),
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.withValues(alpha: 0.08),
            blurRadius: 32,
            offset: const Offset(0, 18),
          ),
        ],
      ),
      child: Form(
        key: formKey,
        child: Column(
          children: [
            _BookingTextField(
              controller: patientNameController,
              label: 'PATIENT NAME',
              hint: 'Enter patient name',
              icon: Icons.person_rounded,
              requiredField: true,
              validator: (value) {
                if (value == null || value.trim().isEmpty) return 'Patient name is required';
                return null;
              },
            ),
            const SizedBox(height: AppSpacing.md),
            _BookingTextField(
              controller: mobileController,
              label: 'MOBILE NUMBER',
              hint: '10-digit mobile number',
              icon: Icons.phone_rounded,
              keyboardType: TextInputType.phone,
              requiredField: true,
              validator: (value) {
                final normalized = value?.trim() ?? '';
                if (normalized.isEmpty) return 'Mobile number is required';
                if (!RegExp(r'^[0-9]{10}$').hasMatch(normalized)) return 'Enter a valid 10-digit mobile number';
                return null;
              },
            ),
            const SizedBox(height: AppSpacing.md),
            _BookingTextField(
              controller: ageController,
              label: 'AGE',
              hint: '1 – 120',
              icon: Icons.cake_rounded,
              keyboardType: TextInputType.number,
              validator: (value) {
                final normalized = value?.trim() ?? '';
                if (normalized.isEmpty) return null;
                final age = int.tryParse(normalized);
                if (age == null || age < 1 || age > 120) return 'Enter age between 1 and 120';
                return null;
              },
            ),
            const SizedBox(height: AppSpacing.md),
            _BookingShiftField(
              value: selectedShift,
              onChanged: onShiftChanged,
            ),
            const SizedBox(height: AppSpacing.xl),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: onSubmit,
                style: FilledButton.styleFrom(
                  backgroundColor: colorScheme.primary,
                  foregroundColor: colorScheme.onPrimary,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(99)),
                  elevation: 6,
                  shadowColor: colorScheme.primary.withValues(alpha: 0.28),
                ),
                child: const Text(
                  'Book Appointment',
                  style: TextStyle(fontWeight: FontWeight.w900),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _BookingTextField extends StatelessWidget {
  const _BookingTextField({
    required this.controller,
    required this.label,
    required this.hint,
    required this.icon,
    this.requiredField = false,
    this.keyboardType,
    this.validator,
  });

  final TextEditingController controller;
  final String label;
  final String hint;
  final IconData icon;
  final bool requiredField;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _FieldLabel(label: label, requiredField: requiredField),
        const SizedBox(height: AppSpacing.xs),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          validator: validator,
          decoration: _bookingInputDecoration(context, hint: hint, icon: icon),
        ),
      ],
    );
  }
}

class _BookingShiftField extends StatelessWidget {
  const _BookingShiftField({
    required this.value,
    required this.onChanged,
  });

  final String value;
  final ValueChanged<String?> onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _FieldLabel(label: 'SHIFT', requiredField: true),
        const SizedBox(height: AppSpacing.xs),
        DropdownButtonFormField<String>(
          initialValue: value,
          decoration: _bookingInputDecoration(context, hint: 'Select shift', icon: Icons.schedule_rounded),
          items: const [
            DropdownMenuItem(value: 'Morning Shift', child: Text('🌤️ Morning Shift')),
            DropdownMenuItem(value: 'Evening Shift', child: Text('🌙 Evening Shift')),
          ],
          onChanged: onChanged,
        ),
      ],
    );
  }
}

class _FieldLabel extends StatelessWidget {
  const _FieldLabel({
    required this.label,
    this.requiredField = false,
  });

  final String label;
  final bool requiredField;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return RichText(
      text: TextSpan(
        text: label,
        style: Theme.of(context).textTheme.labelMedium?.copyWith(
          color: colorScheme.onSurfaceVariant,
          fontWeight: FontWeight.w900,
          letterSpacing: 0.45,
        ),
        children: [
          if (requiredField)
            TextSpan(
              text: ' *',
              style: TextStyle(color: colorScheme.error, fontWeight: FontWeight.w900),
            )
          else
            TextSpan(
              text: ' (Optional)',
              style: TextStyle(
                color: colorScheme.onSurfaceVariant.withValues(alpha: 0.75),
                fontWeight: FontWeight.w600,
                letterSpacing: 0,
              ),
            ),
        ],
      ),
    );
  }
}

InputDecoration _bookingInputDecoration(
    BuildContext context, {
      required String hint,
      required IconData icon,
    }) {
  final colorScheme = Theme.of(context).colorScheme;

  return InputDecoration(
    hintText: hint,
    prefixIcon: Icon(icon, size: 18, color: colorScheme.primary.withValues(alpha: 0.72)),
    filled: true,
    fillColor: colorScheme.surfaceContainerLow,
    contentPadding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.sm),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(14),
      borderSide: BorderSide(color: colorScheme.outlineVariant.withValues(alpha: 0.5)),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(14),
      borderSide: BorderSide(color: colorScheme.outlineVariant.withValues(alpha: 0.5)),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(14),
      borderSide: BorderSide(color: colorScheme.primary, width: 1.4),
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(14),
      borderSide: BorderSide(color: colorScheme.error),
    ),
  );
}