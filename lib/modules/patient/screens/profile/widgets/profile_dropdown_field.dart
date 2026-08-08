import 'package:chroma_kit/chroma_kit.dart';
import 'package:flutter/material.dart';

class ProfileDropdownField extends StatelessWidget {
  final String label;
  final IconData icon;
  final String value;
  final List<String> items;
  final bool isEditing;
  final ValueChanged<String?> onChanged;

  const ProfileDropdownField({
    super.key,
    required this.label,
    required this.icon,
    required this.value,
    required this.items,
    required this.isEditing,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final activeColor = !isEditing
        ? colorScheme.primary
        : colorScheme.secondary;

    return IgnorePointer(
      ignoring: !isEditing,
      child: DropdownButtonFormField<String>(
        initialValue: items.contains(value) ? value : null,
        hint: Text(
          isEditing ? 'Select ${label.toLowerCase()}' : 'Not provided',
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w500,
            color: colorScheme.onSurfaceVariant.transparency(0.5),
          ),
        ),
        onChanged: isEditing ? onChanged : null,
        dropdownColor: colorScheme.surface,
        icon: isEditing
            ? Icon(
                Icons.edit_note_rounded,
                color: colorScheme.primary,
                size: 22,
              )
            : const SizedBox.shrink(),
        isExpanded: true,
        items: items.map((String item) {
          return DropdownMenuItem<String>(
            value: item,
            child: Text(
              item,
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w700,
                color: colorScheme.onSurface.transparency(
                  isEditing ? 1.0 : 0.85,
                ),
              ),
            ),
          );
        }).toList(),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(
            color: activeColor,
            fontWeight: FontWeight.w800,
            fontSize: 12,
          ),

          prefixIcon: Padding(
            padding: const EdgeInsets.only(right: 12.0),
            child: Container(
              height: 38,
              width: 38,
              decoration: BoxDecoration(
                color: activeColor.transparency(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: activeColor, size: 20),
            ),
          ),
          prefixIconConstraints: const BoxConstraints(
            minWidth: 40,
            minHeight: 40,
          ),

          isDense: true,
          contentPadding: const EdgeInsets.symmetric(vertical: 12),

          border: InputBorder.none,
          enabledBorder: InputBorder.none,
          focusedBorder: isEditing
              ? UnderlineInputBorder(
                  borderSide: BorderSide(color: colorScheme.primary, width: 2),
                )
              : InputBorder.none,
        ),
        style: TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w700,
          color: colorScheme.onSurface.transparency(isEditing ? 1.0 : 0.85),
        ),
      ),
    );
  }
}
