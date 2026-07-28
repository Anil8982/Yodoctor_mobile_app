import 'package:flutter/material.dart';
import 'package:yodoctor/core/utils/app_spacing.dart';

class ManualBookingForm extends StatelessWidget {
  const ManualBookingForm({
    super.key,
    required this.formKey,
    required this.patientNameController,
    required this.mobileController,
    required this.ageController,
    required this.selectedShift,
    required this.onShiftChanged,
    required this.onSubmit,
    required this.loading,
  });

  final GlobalKey<FormState> formKey;
  final TextEditingController patientNameController;
  final TextEditingController mobileController;
  final TextEditingController ageController;
  final String selectedShift;
  final ValueChanged<String?> onShiftChanged;
  final VoidCallback onSubmit;
  final bool loading;
  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Form(
      key: formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildInputField(
            context,
            controller: patientNameController,
            label: 'PATIENT NAME',
            hint: 'Enter full name',
            icon: Icons.person_rounded,
            requiredField: true,
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Patient name is required';
              }
              if (value.trim().length < 2) {
                return 'Name should have at least 2 characters';
              }

              if (!RegExp(r'^[A-Za-z]+(?: [A-Za-z]+)*$').hasMatch(value)) {
                return 'Only alphabets are allowed';
              }

              return null;
            },
          ),
          const SizedBox(height: AppSpacing.xl),
          _buildInputField(
            context,
            controller: mobileController,
            label: 'MOBILE NUMBER',
            hint: 'Enter 10-digit mobile number',
            icon: Icons.phone_android_rounded,
            maxLength: 10,
            keyboardType: TextInputType.phone,
            requiredField: true,
            validator: (value) {
              final normalized = value?.trim() ?? '';
              if (normalized.isEmpty) return 'Mobile number is required';
              if (!RegExp(r'^[6-9]\d{9}$').hasMatch(normalized)) {
                return 'Enter a valid 10-digit number';
              }
              return null;
            },
          ),
          const SizedBox(height: AppSpacing.xl),
          _buildInputField(
            context,
            controller: ageController,
            label: 'AGE',
            hint: 'Enter patient age (Years)',
            icon: Icons.cake_rounded,
            keyboardType: TextInputType.number,
            validator: (value) {
              final normalized = value?.trim() ?? '';
              if (normalized.isEmpty) return null;
              final age = int.tryParse(normalized);
              if (age == null || age < 1 || age > 120) {
                return 'Enter age between 1 and 120';
              }
              return null;
            },
          ),
          const SizedBox(height: AppSpacing.xl),
          _buildShiftSelector(context),
          const SizedBox(height: AppSpacing.xxxl),
          SizedBox(
            width: double.infinity,
            height: 54,
            child: FilledButton(
              onPressed: loading ? null : onSubmit,
              style: FilledButton.styleFrom(
                backgroundColor: colorScheme.primary,
                foregroundColor: colorScheme.onPrimary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 0,
              ),
              child: loading
                  ? const SizedBox(
                      width: 22,
                      height: 22,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : const Text(
                      "Confirm Booking",
                      style: TextStyle(
                        fontWeight: FontWeight.w900,
                        fontSize: 16,
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInputField(
    BuildContext context, {
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    bool requiredField = false,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
    int? maxLength,
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildFieldLabel(context, label, requiredField),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          validator: validator,
          maxLength: maxLength,
          style: theme.textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w700,
            color: colorScheme.onSurface,
          ),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: theme.textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurfaceVariant.withValues(alpha: 0.45),
            ),
            prefixIcon: Icon(icon, size: 20, color: colorScheme.primary),
            filled: true,
            fillColor: colorScheme.surfaceContainerHighest.withValues(
              alpha: 0.3,
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.md,
              vertical: 16,
            ),
            counterText: '',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide(color: colorScheme.primary, width: 1.5),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide(
                color: colorScheme.error.withValues(alpha: 0.5),
                width: 1,
              ),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide(color: colorScheme.error, width: 1.5),
            ),
            errorStyle: theme.textTheme.labelSmall?.copyWith(
              color: colorScheme.error,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildShiftSelector(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final shifts = ['Morning Shift', 'Evening Shift'];
    final now = DateTime.now();
    final morningOpen = now.hour < 12;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildFieldLabel(context, 'SELECT SHIFT', true),
        const SizedBox(height: 10),
        Row(
          children: shifts.map((shift) {
            final isSelected = selectedShift == shift;
            final isMorning = shift == 'Morning Shift';

            return Expanded(
              child: Padding(
                padding: EdgeInsets.only(
                  right: isMorning ? 6 : 0,
                  left: isMorning ? 0 : 6,
                ),
                child: InkWell(
                  onTap: () => morningOpen
                      ? () => onShiftChanged("Morning Shift")
                      : null,
                  borderRadius: BorderRadius.circular(14),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 180),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? colorScheme.primaryContainer.withValues(alpha: 0.6)
                          : colorScheme.surfaceContainerHighest.withValues(
                              alpha: 0.3,
                            ),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: isSelected
                            ? colorScheme.primary
                            : Colors.transparent,
                        width: isSelected ? 1.5 : 0,
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          isMorning
                              ? Icons.wb_sunny_rounded
                              : Icons.nights_stay_rounded,
                          size: 16,
                          color: isSelected
                              ? colorScheme.primary
                              : colorScheme.onSurfaceVariant,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          isMorning ? 'Morning' : 'Evening',
                          style: theme.textTheme.labelLarge?.copyWith(
                            fontWeight: FontWeight.w900,
                            color: isSelected
                                ? colorScheme.primary
                                : colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildFieldLabel(
    BuildContext context,
    String label,
    bool requiredField,
  ) {
    final colorScheme = Theme.of(context).colorScheme;

    return RichText(
      text: TextSpan(
        text: label,
        style: Theme.of(context).textTheme.labelMedium?.copyWith(
          color: colorScheme.onSurfaceVariant.withValues(alpha: 0.8),
          fontWeight: FontWeight.w900,
          letterSpacing: 0.8,
          fontSize: 11,
        ),
        children: [
          if (requiredField)
            TextSpan(
              text: ' *',
              style: TextStyle(
                color: colorScheme.error,
                fontWeight: FontWeight.w900,
              ),
            )
          else
            TextSpan(
              text: ' (Optional)',
              style: TextStyle(
                color: colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
                fontWeight: FontWeight.w700,
                fontSize: 10,
              ),
            ),
        ],
      ),
    );
  }
}
