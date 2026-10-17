import 'package:chroma_kit/chroma_kit.dart';
import 'package:flutter/material.dart';

import 'app_field_wrapper.dart';
import 'app_input_style.dart';

class AppMultiSelectField extends StatefulWidget {
  final String label;
  final bool isRequired;
  final String hint;
  final IconData icon;
  final List<String> selectedItems;
  final List<String> options;
  final bool enabled;
  final bool isInvalid;
  final String? errorText;
  final String? Function(List<String>?)? validator;
  final ValueChanged<List<String>> onChanged;
  final AutovalidateMode? autovalidateMode;

  const AppMultiSelectField({
    super.key,
    required this.label,
    this.isRequired = false,
    required this.hint,
    required this.icon,
    required this.selectedItems,
    required this.options,
    this.enabled = true,
    this.isInvalid = false,
    this.errorText,
    this.validator,
    required this.onChanged,
    this.autovalidateMode,
  });

  @override
  State<AppMultiSelectField> createState() => _AppMultiSelectFieldState();
}

class _AppMultiSelectFieldState extends State<AppMultiSelectField> {
  void _openPicker(BuildContext context, FormFieldState<List<String>> state) {
    if (!widget.enabled) return;

    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: colorScheme.surface,
      elevation: 0,
      sheetAnimationStyle: AnimationStyle(
        duration: const Duration(milliseconds: 350),
        reverseDuration: const Duration(milliseconds: 250),
        curve: Curves.easeOutCubic,
        reverseCurve: Curves.easeInCubic,
      ),
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.75,
      ),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Padding(
              padding: EdgeInsets.only(
                top: 16,
                left: 20,
                right: 20,
                bottom:
                    MediaQuery.of(context).viewInsets.bottom +
                    MediaQuery.of(context).padding.bottom +
                    8,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Top Drag Handle Indicator
                  Center(
                    child: Container(
                      width: 36,
                      height: 4,
                      decoration: BoxDecoration(
                        color: colorScheme.outlineVariant.transparency(0.6),
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Sheet Title & Subtitle
                  Text(
                    'Select ${widget.label}',
                    style: textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: colorScheme.onSurface,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'Choose all applicable options',
                    style: textTheme.bodySmall?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 12),

                  Flexible(
                    child: ListView.builder(
                      shrinkWrap: true,
                      physics: const ClampingScrollPhysics(),
                      itemCount: widget.options.length,
                      itemBuilder: (context, index) {
                        final item = widget.options[index];
                        final isSelected = widget.selectedItems.contains(item);

                        return CheckboxListTile(
                          activeColor: colorScheme.primary,
                          contentPadding: EdgeInsets.zero,
                          dense: true,
                          title: Text(
                            item,
                            style: textTheme.bodyMedium?.copyWith(
                              fontWeight: isSelected
                                  ? FontWeight.w700
                                  : FontWeight.normal,
                              color: colorScheme.onSurface,
                            ),
                          ),
                          value: isSelected,
                          onChanged: (bool? value) {
                            setModalState(() {
                              if (value == true) {
                                widget.selectedItems.add(item);
                              } else {
                                widget.selectedItems.remove(item);
                              }
                            });
                            state.didChange(widget.selectedItems);
                            widget.onChanged(widget.selectedItems);
                          },
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 16),

                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: FilledButton(
                      style: FilledButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: () => Navigator.pop(context),
                      child: const Text(
                        'Done',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return FormField<List<String>>(
      initialValue: widget.selectedItems,
      autovalidateMode: widget.autovalidateMode,
      validator: widget.validator,
      builder: (state) {
        final activeError = widget.isInvalid
            ? (widget.errorText ?? 'Invalid selection')
            : state.errorText;
        final hasError = activeError != null && activeError.isNotEmpty;

        return AppFieldWrapper(
          label: widget.label,
          isRequired: widget.isRequired,
          enabled: widget.enabled,
          hasError: hasError,
          activeError: activeError,
          child: InkWell(
            onTap: () => _openPicker(context, state),
            borderRadius: BorderRadius.circular(14),
            child: InputDecorator(
              decoration: AppInputStyle.decoration(
                context: context,
                hint: widget.hint,
                icon: widget.icon,
                hasError: hasError,
                suffixIcon: Icon(
                  Icons.keyboard_arrow_down_rounded,
                  color: colorScheme.onSurfaceVariant,
                  size: 20,
                ),
              ),
              isEmpty: widget.selectedItems.isEmpty,
              child: Text(
                widget.selectedItems.join(', '),
                style: textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurface,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
        );
      },
    );
  }
}
