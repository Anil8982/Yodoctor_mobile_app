import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'app_field_wrapper.dart';
import 'app_input_style.dart';


class AppTextField extends StatefulWidget {
  final String label;
  final bool isRequired;
  final String hint;
  final IconData icon;
  final TextEditingController? controller;
  final bool isPassword;
  final TextInputType keyboardType;
  final String? Function(String?)? validator;
  final int? maxLength;
  final int? maxLines;
  final int? minLines;
  final List<TextInputFormatter>? inputFormatters;
  final TextCapitalization textCapitalization;
  final bool readOnly;
  final VoidCallback? onTap;
  final bool enabled;
  final bool isInvalid;
  final String? errorText;
  final AutovalidateMode? autovalidateMode;

  const AppTextField({
    super.key,
    required this.label,
    this.isRequired = false,
    required this.hint,
    required this.icon,
    this.controller,
    this.isPassword = false,
    this.keyboardType = TextInputType.text,
    this.validator,
    this.maxLength,
    this.maxLines = 1,
    this.minLines,
    this.inputFormatters,
    this.textCapitalization = TextCapitalization.none,
    this.readOnly = false,
    this.onTap,
    this.enabled = true,
    this.isInvalid = false,
    this.errorText,
    this.autovalidateMode,
  });

  @override
  State<AppTextField> createState() => _AppTextFieldState();
}

class _AppTextFieldState extends State<AppTextField> {
  bool _obscure = true;
  String? _internalErrorMessage;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    // Active error check
    final activeError = widget.isInvalid
        ? (widget.errorText ?? 'Invalid input')
        : _internalErrorMessage;
    final hasError = activeError != null && activeError.isNotEmpty;

    return AppFieldWrapper(
      label: widget.label,
      isRequired: widget.isRequired,
      enabled: widget.enabled,
      hasError: hasError,
      activeError: activeError,
      child: TextFormField(
        controller: widget.controller,
        obscureText: widget.isPassword && _obscure,
        keyboardType: widget.keyboardType,
        maxLength: widget.maxLength,
        maxLines: widget.isPassword ? 1 : widget.maxLines,
        minLines: widget.minLines,
        inputFormatters: widget.inputFormatters,
        textCapitalization: widget.textCapitalization,
        readOnly: widget.readOnly,
        enabled: widget.enabled,
        onTap: widget.onTap,
        autovalidateMode: widget.autovalidateMode,
        style: textTheme.bodyMedium?.copyWith(color: colorScheme.onSurface),

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

        decoration: AppInputStyle.decoration(
          context: context,
          hint: widget.hint,
          icon: widget.icon,
          hasError: hasError,
          suffixIcon: widget.isPassword
              ? IconButton(
            tooltip: _obscure ? 'Show password' : 'Hide password',
            icon: Icon(
              _obscure
                  ? Icons.visibility_off_rounded
                  : Icons.visibility_rounded,
              color: colorScheme.onSurfaceVariant,
              size: 20,
            ),
            onPressed: () => setState(() => _obscure = !_obscure),
          )
              : null,
        ),
      ),
    );
  }
}