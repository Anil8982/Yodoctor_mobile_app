import 'package:flutter/material.dart';

import 'app_field_wrapper.dart';
import 'app_input_style.dart';

class AppDropdownField<T> extends StatefulWidget {
  final String label;
  final bool isRequired;
  final IconData icon;
  final T? value;
  final String hint;
  final List<T> items;
  final String Function(T item)? itemLabel;
  final void Function(T?) onChanged;
  final String? Function(T?)? validator;
  final bool enabled;
  final AutovalidateMode? autovalidateMode;

  const AppDropdownField({
    super.key,
    required this.label,
    this.isRequired = false,
    required this.icon,
    required this.value,
    required this.items,
    this.itemLabel,
    required this.onChanged,
    this.hint = 'Select...',
    this.validator,
    this.enabled = true,
    this.autovalidateMode,
  });

  @override
  State<AppDropdownField<T>> createState() => _AppDropdownFieldState<T>();
}

class _AppDropdownFieldState<T> extends State<AppDropdownField<T>> {
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
      child: DropdownButtonFormField<T>(
        initialValue: widget.value,
        isExpanded: true,
        menuMaxHeight: 300,
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

        items: widget.items.map((item) {
          return DropdownMenuItem<T>(
            value: item,
            child: Text(
              widget.itemLabel?.call(item) ?? item.toString(),
              overflow: TextOverflow.ellipsis,
              style: textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurface,
              ),
            ),
          );
        }).toList(),

        onChanged: widget.enabled ? widget.onChanged : null,
      ),
    );
  }
}
