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
    final activeColor = !widget.isEditing
        ? colorScheme.primary
        : colorScheme.secondary;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      width: double.infinity,
      decoration: const BoxDecoration(color: Colors.transparent),

      child: InkWell(
        onTap: widget.isEditing
            ? () async {
                setState(() => _isFocused = true);
                await widget.onTap?.call();
                if (mounted) {
                  setState(() => _isFocused = false);
                }
              }
            : null,
        borderRadius: BorderRadius.circular(10),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            border: _isFocused
                ? Border(
                    bottom: BorderSide(color: colorScheme.primary, width: 2),
                  )
                : null,
          ),
          child: Row(
            children: [
              Container(
                height: 38,
                width: 38,
                decoration: BoxDecoration(
                  color: activeColor.transparency(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(widget.icon, color: activeColor, size: 20),
              ),

              const SizedBox(width: 12),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      widget.label,
                      style: TextStyle(
                        color: activeColor,
                        fontWeight: FontWeight.w800,
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      widget.value.trim().isEmpty
                          ? 'Select Date'
                          : widget.value,
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: widget.value.trim().isEmpty
                            ? colorScheme.onSurfaceVariant.transparency(0.5)
                            : colorScheme.onSurface.transparency(
                                widget.isEditing ? 1.0 : 0.85,
                              ),
                      ),
                    ),
                  ],
                ),
              ),

              if (widget.isEditing)
                Padding(
                  padding: const EdgeInsets.only(right: 16.0),
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
