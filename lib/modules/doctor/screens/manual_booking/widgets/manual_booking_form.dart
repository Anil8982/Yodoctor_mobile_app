import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:yodoctor/core/utils/app_spacing.dart';
import 'package:yodoctor/modules/widgets/app_field_wrapper.dart';
import 'package:yodoctor/modules/widgets/app_text_field.dart';

class ManualBookingForm extends StatelessWidget {
  const ManualBookingForm({
    super.key,
    required this.formKey,
    required this.autovalidateMode,
    required this.patientNameController,
    required this.mobileController,
    required this.ageController,
    required this.selectedShift,
    required this.onShiftChanged,
    required this.onSubmit,
    required this.loading,
  });

  final GlobalKey<FormState> formKey;
  final AutovalidateMode autovalidateMode;
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
      autovalidateMode: autovalidateMode,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppTextField(
            label: 'PATIENT NAME',
            isRequired: true,
            hint: 'Enter full name',
            icon: Icons.person_outline_rounded,
            controller: patientNameController,
            textCapitalization: TextCapitalization.words,
            validator: (v) {
              if (v == null || v.trim().isEmpty) return 'Full name required';
              if (v.trim().length < 3) return 'Enter a valid name';
              return null;
            },
          ),
          const SizedBox(height: AppSpacing.xl),
          AppTextField(
            label: 'MOBILE NUMBER',
            isRequired: true,
            hint: 'Enter 10-digit mobile number',
            icon: Icons.phone_android_rounded,
            controller: mobileController,
            keyboardType: TextInputType.phone,
            maxLength: 10,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            validator: (v) {
              if (v == null || v.trim().isEmpty) return 'Mobile required';
              final indianPhoneRegExp = RegExp(r'^[6-9]\d{9}$');
              if (!indianPhoneRegExp.hasMatch(v.trim())) {
                return 'Enter a valid 10-digit mobile number';
              }
              return null;
            },
          ),

          const SizedBox(height: AppSpacing.xl),
          AppTextField(
            isOptional: true,
            label: 'AGE',
            hint: 'Enter patient age (Years)',
            icon: Icons.cake_rounded,
            controller: ageController,
            keyboardType: TextInputType.number,
            validator: (v) {
              final normalized = v?.trim() ?? '';
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

  Widget _buildShiftSelector(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final shifts = ['Morning Shift', 'Evening Shift'];

    return AppFieldWrapper(
      label: 'SELECT SHIFT',
      isRequired: true,
      hasError: false,
      child: Row(
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
                onTap: () => onShiftChanged(shift),
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
    );
  }
}
