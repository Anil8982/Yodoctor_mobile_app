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

    return Stack(
      alignment: Alignment.centerRight,
      children: [
        IgnorePointer(
          ignoring: !isEditing,
          child: DropdownButtonFormField<String>(
            initialValue: items.contains(value) ? value : null,
            onChanged: isEditing ? onChanged : null,
            dropdownColor: colorScheme.surface,
            icon: const SizedBox.shrink(),
            isExpanded: true,
            items: items.map((String item) {
              return DropdownMenuItem<String>(
                value: item,
                child: Text(item, style: const TextStyle(fontWeight: FontWeight.w700)),
              );
            }).toList(),
            decoration: InputDecoration(
              labelText: label,
              labelStyle: TextStyle(
                color: !isEditing ? colorScheme.primary : colorScheme.secondary,
                fontWeight: FontWeight.w800,
                fontSize: 12,
              ),
              prefixIcon: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Icon(
                  icon,
                  size: 22,
                  color: !isEditing ? colorScheme.primary : colorScheme.secondary.transparency(0.9),
                ),
              ),
              border: InputBorder.none,
              enabledBorder: InputBorder.none,
              focusedBorder: isEditing
                  ? UnderlineInputBorder(borderSide: BorderSide(color: colorScheme.primary, width: 2))
                  : InputBorder.none,
              contentPadding: const EdgeInsets.fromLTRB(50, 16, 30, 16),
            ),
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: colorScheme.onSurface.transparency(isEditing ? 1.0 : 0.9),
            ),
          ),
        ),

        if (isEditing)
          Padding(
            padding: const EdgeInsets.only(right: 22.0),
            child: Icon(
              Icons.edit_note_rounded,
              color: colorScheme.primary,
              size: 22,
            ),
          ),
      ],
    );
  }
}