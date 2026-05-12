import 'package:chroma_kit/chroma_kit.dart';
import 'package:flutter/material.dart';

class ProfileTextField extends StatelessWidget {
  final String label;
  final IconData icon;
  final TextEditingController controller;
  final bool isEditing;

  const ProfileTextField({
    super.key,
    required this.label,
    required this.icon,
    required this.controller,
    required this.isEditing,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Focus(
      canRequestFocus: isEditing,
      child: Container(
        width: double.infinity,
        color: isEditing ? colorScheme.surface : Colors.transparent,
        child: TextFormField(
          controller: controller,
          readOnly: !isEditing,
          showCursor: isEditing,
          decoration: InputDecoration(
            labelText: label,
            labelStyle: TextStyle(
              color: isEditing ? colorScheme.primary : colorScheme.outline,
              fontWeight: FontWeight.w800,
              fontSize: 12,
            ),
            prefixIcon: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Icon(
                icon,
                size: 22,
                color: isEditing ? colorScheme.primary : colorScheme.outline.transparency(0.6),
              ),
            ),
            border: InputBorder.none,
            enabledBorder: InputBorder.none,
            focusedBorder: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(vertical: 16),
          ),
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: colorScheme.onSurface.transparency(isEditing ? 1.0 : 0.9),
          ),
        ),
      ),
    );
  }
}
