import 'package:chroma_kit/chroma_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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
          labelText: label,
          labelStyle: TextStyle(
            color: !isEditing ? colorScheme.primary : colorScheme.secondary,
            fontWeight: FontWeight.w800,
            fontSize: 12,
          ),
          errorStyle: const TextStyle(fontSize: 12, color: Colors.red),
          prefixIcon: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Icon(
              icon,
              size: 22,
              color: !isEditing
                  ? colorScheme.primary
                  : colorScheme.secondary.transparency(0.9),
            ),
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

          contentPadding: const EdgeInsets.fromLTRB(50, 16, 30, 16),
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