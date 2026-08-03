import 'package:flutter/material.dart';

import 'app_field_wrapper.dart';
import 'app_input_style.dart';

class AppDropdownField extends StatefulWidget {
  final String label;
  final bool isRequired;
  final IconData icon;
  final String? value;
  final String hint;
  final List<String> items;
  final void Function(String?) onChanged;
  final String? Function(String?)? validator;
  final bool enabled;
  final AutovalidateMode? autovalidateMode;

  const AppDropdownField({
    super.key,
    required this.label,
    this.isRequired = false,
    required this.icon,
    required this.value,
    required this.items,
    required this.onChanged,
    this.hint = 'Select...',
    this.validator,
    this.enabled = true,
    this.autovalidateMode,
  });

  @override
  State<AppDropdownField> createState() => _AppDropdownFieldState();
}

class _AppDropdownFieldState extends State<AppDropdownField> {
  String? _errorMessage;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    final hasError = _errorMessage != null && _errorMessage!.isNotEmpty;

    return AppFieldWrapper(
      label: widget.label,
      isRequired: widget.isRequired,
      enabled: widget.enabled,
      hasError: hasError,
      activeError: _errorMessage,
      child: DropdownButtonFormField<String>(
        initialValue: widget.value,
        validator: (value) {
          final error = widget.validator?.call(value);
          if (_errorMessage != error) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (mounted) {
                setState(() {
                  _errorMessage = error;
                });
              }
            });
          }
          return error;
        },
        autovalidateMode: widget.autovalidateMode,
        style: textTheme.bodyMedium?.copyWith(color: colorScheme.onSurface),
        dropdownColor: colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        icon: Icon(
          Icons.keyboard_arrow_down_rounded,
          color: colorScheme.onSurfaceVariant,
        ),
        decoration: AppInputStyle.decoration(
          context: context,
          hint: widget.hint,
          icon: widget.icon,
          hasError: hasError,
        ),
        items: widget.items
            .map(
              (s) => DropdownMenuItem(
            value: s,
            child: Text(
              s,
              style: textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurface,
              ),
            ),
          ),
        )
            .toList(),
        onChanged: widget.enabled ? widget.onChanged : null,
      ),
    );
  }
}