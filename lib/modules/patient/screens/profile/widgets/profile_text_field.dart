import 'package:chroma_kit/chroma_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:yodoctor/core/theme/app_theme.dart';

class ProfileTextField extends StatelessWidget {
  final String label;
  final IconData icon;
  final TextEditingController controller;
  final bool isEditing;
  final List<TextInputFormatter>? inputFormatters;
  final String? Function(String?)? validator;

  const ProfileTextField({
    super.key,
    required this.label,
    required this.icon,
    required this.controller,
    required this.isEditing,
    this.inputFormatters,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Focus(
      canRequestFocus: isEditing,
      child: TextFormField(
        controller: controller,
        readOnly: !isEditing,
        showCursor: isEditing,
        inputFormatters: inputFormatters,
        validator: validator,
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.transparent,

          labelText: label,
          hintText: controller.text.trim().isEmpty
              ? (isEditing ? 'Enter $label' : 'Not provided')
              : null,
          labelStyle: TextStyle(
            color: !isEditing ? colorScheme.primary : colorScheme.secondary,
            fontWeight: FontWeight.w800,
            fontSize: 12,
          ),
          errorStyle: TextStyle(fontSize: 12, color: AppTheme.error(context)),

          prefixIcon: Padding(
            padding: const EdgeInsets.only(right: 12.0),
            child: Container(
              height: 38,
              width: 38,
              decoration: BoxDecoration(
                color: !isEditing
                    ? colorScheme.primary.transparency(0.1)
                    : colorScheme.secondary.transparency(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                icon,
                color: !isEditing ? colorScheme.primary : colorScheme.secondary,
                size: 20,
              ),
            ),
          ),
          prefixIconConstraints: const BoxConstraints(
            minWidth: 40,
            minHeight: 40,
          ),

          suffixIcon: isEditing
              ? Padding(
                  padding: const EdgeInsets.only(right: 16.0),
                  child: Icon(
                    Icons.edit_note_rounded,
                    color: colorScheme.primary,
                    size: 22,
                  ),
                )
              : null,

          border: InputBorder.none,
          enabledBorder: InputBorder.none,
          focusedBorder: isEditing
              ? UnderlineInputBorder(
                  borderSide: BorderSide(color: colorScheme.primary, width: 2),
                )
              : InputBorder.none,

          contentPadding: const EdgeInsets.symmetric(vertical: 12),
        ),
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w700,
          color: colorScheme.onSurface.transparency(isEditing ? 1.0 : 0.9),
        ),
      ),
    );
  }
}
