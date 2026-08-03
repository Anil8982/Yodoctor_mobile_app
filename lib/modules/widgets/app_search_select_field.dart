import 'package:chroma_kit/chroma_kit.dart';
import 'package:flutter/material.dart';

import 'app_field_wrapper.dart';
import 'app_input_style.dart';

class AppSearchSelectField extends StatelessWidget {
  final String label;
  final bool isRequired;
  final String hint;
  final IconData icon;
  final String? value;
  final List<String> items;
  final bool isInvalid;
  final String? errorText;
  final ValueChanged<String?> onChanged;
  final String? Function(String?)? validator;
  final AutovalidateMode? autovalidateMode;
  final bool enabled;

  const AppSearchSelectField({
    super.key,
    required this.label,
    this.isRequired = false,
    this.hint = 'Select item...',
    required this.icon,
    required this.value,
    required this.items,
    this.isInvalid = false,
    this.errorText,
    required this.onChanged,
    this.validator,
    this.autovalidateMode,
    this.enabled = true,
  });

  void _openSearchPicker(
      BuildContext context,
      FormFieldState<String> state,
      ) {
    if (!enabled) return;

    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: colorScheme.surface,
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.75,
      ),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) {
        String searchQuery = '';
        return StatefulBuilder(
          builder: (context, setModalState) {
            final filteredItems = items
                .where((item) =>
                item.toLowerCase().contains(searchQuery.toLowerCase()))
                .toList();

            return Padding(
              padding: EdgeInsets.only(
                top: 20,
                left: 20,
                right: 20,
                bottom: MediaQuery.of(context).viewInsets.bottom + 20,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: colorScheme.outlineVariant.transparency(0.6),
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Select $label',
                    style: textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: colorScheme.onSurface,
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Search Input Box
                  TextField(
                    autofocus: true,
                    onChanged: (val) {
                      setModalState(() {
                        searchQuery = val;
                      });
                    },
                    style: textTheme.bodyMedium,
                    decoration: InputDecoration(
                      hintText: 'Search $label...',
                      prefixIcon: Icon(
                        Icons.search_rounded,
                        color: colorScheme.primary,
                        size: 20,
                      ),
                      filled: true,
                      fillColor: colorScheme.surfaceContainerLow,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Results List View
                  Flexible(
                    child: filteredItems.isEmpty
                        ? Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Center(
                        child: Text(
                          'No matching results found',
                          style: textTheme.bodyMedium?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ),
                    )
                        : ListView.separated(
                      shrinkWrap: true,
                      itemCount: filteredItems.length,
                      separatorBuilder: (_, _) => const Divider(
                        height: 1,
                        thickness: 0.5,
                      ),
                      itemBuilder: (context, index) {
                        final item = filteredItems[index];
                        final isSelected = item == value;

                        return ListTile(
                          contentPadding: EdgeInsets.zero,
                          title: Text(
                            item,
                            style: textTheme.bodyMedium?.copyWith(
                              fontWeight: isSelected
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                              color: isSelected
                                  ? colorScheme.primary
                                  : colorScheme.onSurface,
                            ),
                          ),
                          trailing: isSelected
                              ? Icon(
                            Icons.check_circle_rounded,
                            color: colorScheme.primary,
                          )
                              : null,
                          onTap: () {
                            state.didChange(item);
                            onChanged(item);
                            Navigator.pop(context);
                          },
                        );
                      },
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

    return FormField<String>(
      initialValue: value,
      autovalidateMode: autovalidateMode,
      validator: validator,
      builder: (state) {
        final activeError =
        isInvalid ? (errorText ?? 'Selection required') : state.errorText;
        final hasError = activeError != null && activeError.isNotEmpty;

        return AppFieldWrapper(
          label: label,
          isRequired: isRequired,
          enabled: enabled,
          hasError: hasError,
          activeError: activeError,
          child: InkWell(
            onTap: () => _openSearchPicker(context, state),
            borderRadius: BorderRadius.circular(14),
            child: InputDecorator(
              decoration: AppInputStyle.decoration(
                context: context,
                hint: hint,
                icon: icon,
                hasError: hasError,
                suffixIcon: Icon(
                  Icons.search_rounded,
                  color: colorScheme.onSurfaceVariant,
                  size: 20,
                ),
              ),
              isEmpty: value == null || value!.isEmpty,
              child: Text(
                value ?? '',
                style: textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurface,
                  fontWeight: FontWeight.w500,
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