import 'package:flutter/material.dart';

import 'member_form_field.dart';

class MemberFormDropdownField extends StatelessWidget {
  const MemberFormDropdownField({
    super.key,
    required this.label,
    required this.hintText,
    required this.prefixIcon,
    required this.value,
    required this.options,
    required this.onChanged,
    required this.validator,
  });

  final String label;
  final String hintText;
  final IconData prefixIcon;
  final String? value;
  final List<String> options;
  final ValueChanged<String?> onChanged;
  final String? Function(String?) validator;

  @override
  Widget build(BuildContext context) {
    return MemberFormField(
      label: label,
      child: DropdownButtonFormField<String>(
        initialValue: value,
        items: options
            .map(
              (String option) => DropdownMenuItem<String>(
                value: option,
                child: Text(option),
              ),
            )
            .toList(),
        decoration: InputDecoration(
          hintText: hintText,
          prefixIcon: Icon(prefixIcon),
        ),
        onChanged: onChanged,
        validator: validator,
      ),
    );
  }
}
