import 'package:flutter/material.dart';

import 'app_field_wrapper.dart';
import 'app_input_style.dart';

class AppDropdownField<T> extends StatefulWidget {
  final String? label;
  final TextStyle? labelStyle;
  final bool isRequired;
  final bool isOptional;
  final IconData icon;
  final T? value;
  final String hint;
  final List<T> items;
  final String Function(T)? itemLabelBuilder;
  final void Function(T?) onChanged;
  final String? Function(T?)? validator;
  final bool enabled;
  final bool isInvalid;
  final String? errorText;
  final AutovalidateMode? autovalidateMode;

  const AppDropdownField({
    super.key,
    this.label,
    this.labelStyle,
    this.isRequired = false,
    this.isOptional = false,
    required this.icon,
    required this.value,
    required this.items,
    this.itemLabelBuilder,
    required this.onChanged,
    this.hint = 'Select...',
    this.validator,
    this.enabled = true,
    this.isInvalid = false,
    this.errorText,
    this.autovalidateMode,
  });

  @override
  State<AppDropdownField<T>> createState() => _AppDropdownFieldState<T>();
}

class _AppDropdownFieldState<T> extends State<AppDropdownField<T>> {
  String? _internalErrorMessage;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    final activeError = widget.isInvalid
        ? (widget.errorText ?? 'Invalid selection')
        : _internalErrorMessage;
    final hasError = activeError != null && activeError.isNotEmpty;

    return AppFieldWrapper(
      label: widget.label,
      labelStyle: widget.labelStyle,
      isRequired: widget.isRequired,
      isOptional: widget.isOptional,
      enabled: widget.enabled,
      hasError: hasError,
      activeError: activeError,
      child: DropdownButtonFormField<T>(
        initialValue: widget.value,
        validator: (value) {
          final error = widget.validator?.call(value);
          if (_internalErrorMessage != error) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (mounted) {
                setState(() {
                  _internalErrorMessage = error;
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
        isDense: true,
        isExpanded: true,
        icon: Icon(
          Icons.keyboard_arrow_down_rounded,
          color: colorScheme.onSurfaceVariant,
          size: 20,
        ),
        decoration: AppInputStyle.decoration(
          context: context,
          hint: widget.hint,
          icon: widget.icon,
          hasError: hasError,
          isDropdown: true,
        ),
        items: widget.items
            .map(
              (item) => DropdownMenuItem<T>(
            value: item,
            child: Text(
              widget.itemLabelBuilder != null
                  ? widget.itemLabelBuilder!(item)
                  : item.toString(),
              style: textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurface,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        )
            .toList(),
        onChanged: widget.enabled ? widget.onChanged : null,
      ),
    );
  }
}