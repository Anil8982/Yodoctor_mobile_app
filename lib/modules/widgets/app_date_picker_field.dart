import 'package:flutter/material.dart';
import 'app_field_wrapper.dart';
import 'app_input_style.dart';

class AppDatePickerField extends StatefulWidget {
  final String label;
  final bool isRequired;
  final String hint;
  final IconData icon;
  final DateTime? value;
  final DateTime? firstDate;
  final DateTime? lastDate;
  final ValueChanged<DateTime?> onChanged;
  final String? Function(DateTime?)? validator;
  final bool enabled;
  final bool isInvalid;
  final String? errorText;
  final AutovalidateMode? autovalidateMode;

  const AppDatePickerField({
    super.key,
    required this.label,
    this.isRequired = false,
    this.hint = 'Select date...',
    this.icon = Icons.calendar_today_rounded,
    required this.value,
    this.firstDate,
    this.lastDate,
    required this.onChanged,
    this.validator,
    this.enabled = true,
    this.isInvalid = false,
    this.errorText,
    this.autovalidateMode,
  });

  @override
  State<AppDatePickerField> createState() => _AppDatePickerFieldState();
}

class _AppDatePickerFieldState extends State<AppDatePickerField> {
  final GlobalKey<FormFieldState<DateTime>> _fieldKey =
  GlobalKey<FormFieldState<DateTime>>();

  @override
  @override
  void didUpdateWidget(covariant AppDatePickerField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.value != widget.value) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          _fieldKey.currentState?.didChange(widget.value);
        }
      });
    }
  }

  Future<void> _selectDate(
      BuildContext context,
      FormFieldState<DateTime> state,
      ) async {
    if (!widget.enabled) return;

    final now = DateTime.now();
    final firstDate = widget.firstDate ?? DateTime(1900);
    final lastDate = widget.lastDate ?? DateTime(2100);

    DateTime initialPickerDate = widget.value ?? now;
    if (initialPickerDate.isBefore(firstDate)) {
      initialPickerDate = firstDate;
    } else if (initialPickerDate.isAfter(lastDate)) {
      initialPickerDate = lastDate;
    }

    final pickedDate = await showDatePicker(
      context: context,
      initialDate: initialPickerDate,
      firstDate: firstDate,
      lastDate: lastDate,
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

    if (pickedDate != null) {
      state.didChange(pickedDate); // 1. Local state update
      widget.onChanged(pickedDate); // 2. Parent callback
      state.validate(); // 3. Re-validate after picking date
    }
  }

  String _formatDate(DateTime date) {
    final day = date.day.toString().padLeft(2, '0');
    final month = date.month.toString().padLeft(2, '0');
    return '$day/$month/${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return FormField<DateTime>(
      key: _fieldKey,
      initialValue: widget.value,
      autovalidateMode: widget.autovalidateMode ?? AutovalidateMode.onUserInteraction,
      validator: widget.validator ??
              (val) {
            if (widget.isRequired && val == null) {
              return 'Please select a date';
            }
            return null;
          },
      builder: (FormFieldState<DateTime> state) {
        final String? activeError = widget.isInvalid
            ? (widget.errorText ?? 'Invalid date')
            : state.errorText;

        final bool hasError = activeError != null && activeError.isNotEmpty;

        return AppFieldWrapper(
          label: widget.label,
          isRequired: widget.isRequired,
          enabled: widget.enabled,
          hasError: hasError,
          activeError: activeError,
          child: InkWell(
            onTap: () => _selectDate(context, state),
            borderRadius: BorderRadius.circular(14),
            child: InputDecorator(
              decoration: AppInputStyle.decoration(
                context: context,
                hint: widget.hint,
                icon: widget.icon,
                hasError: hasError,
                suffixIcon: Icon(
                  Icons.arrow_drop_down_outlined,
                  color: colorScheme.onSurfaceVariant,
                  size: 22,
                ),
              ),
              isEmpty: state.value == null,
              child: Text(
                state.value != null ? _formatDate(state.value!) : '',
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