import 'package:flutter/material.dart';
import 'package:yodoctor/core/models/family_member.dart';

class PatientSelectionSection extends StatelessWidget {
  const PatientSelectionSection({
    super.key,
    required this.isSelf,
    required this.familyMembers,
    required this.selectedFamilyMember,
    required this.onProfileTypeChanged,
    required this.onMemberChanged,
    required this.onAddFamilyPressed,
  });

  final bool isSelf;
  final List<FamilyMember> familyMembers;
  final FamilyMember? selectedFamilyMember;
  final ValueChanged<bool> onProfileTypeChanged;
  final ValueChanged<FamilyMember?> onMemberChanged;
  final VoidCallback onAddFamilyPressed;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _buildSegmentButton(
                label: 'For Self',
                icon: Icons.person_rounded,
                isSelected: isSelf,
                onTap: () => onProfileTypeChanged(true),
                colorScheme: colorScheme,
                textTheme: textTheme,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildSegmentButton(
                label: 'Family Member',
                icon: Icons.group_rounded,
                isSelected: !isSelf,
                onTap: () => onProfileTypeChanged(false),
                colorScheme: colorScheme,
                textTheme: textTheme,
              ),
            ),
          ],
        ),
        if (!isSelf) ...[
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: DropdownButtonFormField<FamilyMember>(
                  initialValue: selectedFamilyMember,
                  hint: const Text('Choose Member'),
                  decoration: InputDecoration(
                    fillColor: colorScheme.surfaceContainerLow,
                    filled: true,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide(color: colorScheme.outlineVariant),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide(color: colorScheme.outlineVariant.withValues(alpha: 0.6)),
                    ),
                  ),
                  items: familyMembers.map((member) {
                    return DropdownMenuItem<FamilyMember>(
                      value: member,
                      child: Text(member.name, style: textTheme.bodyLarge),
                    );
                  }).toList(),
                  onChanged: onMemberChanged,
                ),
              ),
              const SizedBox(width: 12),
              IconButton.filledTonal(
                onPressed: onAddFamilyPressed,
                style: IconButton.styleFrom(
                  padding: const EdgeInsets.all(14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                ),
                icon: const Icon(Icons.person_add_alt_1_rounded),
              ),
            ],
          ),
        ],
      ],
    );
  }

  Widget _buildSegmentButton({
    required String label,
    required IconData icon,
    required bool isSelected,
    required VoidCallback onTap,
    required ColorScheme colorScheme,
    required TextTheme textTheme,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
        decoration: BoxDecoration(
          color: isSelected ? colorScheme.primaryContainer : colorScheme.surfaceContainerLow,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? colorScheme.primary : colorScheme.outlineVariant.withValues(alpha: 0),
            width: 1.5,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 18,
              color: isSelected ? colorScheme.primary : colorScheme.onSurfaceVariant,
            ),
            const SizedBox(width: 8),
            Flexible(
              child: Text(
                label,
                overflow: TextOverflow.ellipsis,
                style: textTheme.labelLarge?.copyWith(
                  fontWeight: isSelected ? FontWeight.w900 : FontWeight.w600,
                  color: isSelected ? colorScheme.primary : colorScheme.onSurfaceVariant,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
