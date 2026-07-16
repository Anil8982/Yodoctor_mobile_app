import 'package:chroma_kit/chroma_kit.dart';
import 'package:flutter/material.dart';

class ProfileDatePickerField extends StatefulWidget {
  final String label;
  final IconData icon;
  final String value;
  final bool isEditing;
  final String? Function(String?)? validator;
  final Future<void> Function()? onTap;

  const ProfileDatePickerField({
    super.key,
    required this.label,
    required this.icon,
    required this.value,
    required this.isEditing,
    this.validator,
    this.onTap,
  });

  @override
  State<ProfileDatePickerField> createState() => _ProfileDatePickerFieldState();
}

class _ProfileDatePickerFieldState extends State<ProfileDatePickerField> {
  bool _isFocused = false;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: widget.isEditing
            ? () async {
          setState(() => _isFocused = true);

          await widget.onTap?.call();

          setState(() => _isFocused = false);
        }
            : null,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            border: _isFocused
                ? Border(
              bottom: BorderSide(color: colorScheme.primary, width: 2),
            )
                : null,
          ),
          child: Row(
            children: [
              Icon(
                widget.icon,
                size: 22,
                color: !widget.isEditing
                    ? colorScheme.primary
                    : colorScheme.secondary.transparency(0.9),
              ),

              const SizedBox(width: 18),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.label,
                      style: TextStyle(
                        color: !widget.isEditing
                            ? colorScheme.primary
                            : colorScheme.secondary,
                        fontWeight: FontWeight.w800,
                        fontSize: 10,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      widget.value,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: colorScheme.onSurface.transparency(
                          widget.isEditing ? 1 : .9,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              if (widget.isEditing)
                Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: Icon(
                    Icons.edit_note_rounded,
                    color: colorScheme.primary,
                    size: 22,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
