import 'package:flutter/material.dart';
import 'app_field_wrapper.dart';
import 'app_input_style.dart';

class AppTimePickerField extends StatefulWidget {
  final String label;
  final bool isRequired;
  final String hint;
  final IconData icon;
  final TimeOfDay? value;
  final ValueChanged<TimeOfDay?> onChanged;
  final String? Function(TimeOfDay?)? validator;
  final bool enabled;
  final bool isInvalid;
  final String? errorText;
  final AutovalidateMode? autovalidateMode;

  const AppTimePickerField({
    super.key,
    required this.label,
    this.isRequired = false,
    this.hint = 'Select time...',
    this.icon = Icons.access_time_rounded,
    required this.value,
    required this.onChanged,
    this.validator,
    this.enabled = true,
    this.isInvalid = false,
    this.errorText,
    this.autovalidateMode,
  });

  @override
  State<AppTimePickerField> createState() => _AppTimePickerFieldState();
}

class _AppTimePickerFieldState extends State<AppTimePickerField> {
  Future<void> _selectTime(
      BuildContext context,
      FormFieldState<TimeOfDay> state,
      ) async {
    if (!widget.enabled) return;

    final pickedTime = await showTimePicker(
      context: context,
      initialTime: widget.value ?? TimeOfDay.now(),
      builder: (context, child) {
        final colorScheme = Theme.of(context).colorScheme;
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: colorScheme.copyWith(
              surface: colorScheme.surface,
            ),
          ),
          child: child!,
        );
      },
    );

    if (pickedTime != null && pickedTime != widget.value) {
      state.didChange(pickedTime);
      widget.onChanged(pickedTime);
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return FormField<TimeOfDay>(
      initialValue: widget.value,
      autovalidateMode: widget.autovalidateMode,
      validator: widget.validator,
      builder: (state) {
        final activeError = widget.isInvalid
            ? (widget.errorText ?? 'Invalid time')
            : state.errorText;
        final hasError = activeError != null && activeError.isNotEmpty;

        return AppFieldWrapper(
          label: widget.label,
          isRequired: widget.isRequired,
          enabled: widget.enabled,
          hasError: hasError,
          activeError: activeError,
          child: InkWell(
            onTap: () => _selectTime(context, state),
            borderRadius: BorderRadius.circular(14),
            child: InputDecorator(
              decoration: AppInputStyle.decoration(
                context: context,
                hint: widget.hint,
                icon: widget.icon,
                hasError: hasError,
                suffixIcon: Icon(
                  Icons.access_time_rounded,
                  color: colorScheme.onSurfaceVariant,
                  size: 22,
                ),
              ),
              isEmpty: widget.value == null,
              child: Text(
                widget.value != null
                    ? widget.value!.format(context)
                    : '',
                style: textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurface,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
        );
      },
    );
  }
}