import 'package:chroma_kit/chroma_kit.dart';
import 'package:flutter/material.dart';
import '../../../models/family/family_member_model.dart';

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
  final List<FamilyMemberModel> familyMembers;
  final FamilyMemberModel? selectedFamilyMember;
  final ValueChanged<bool>? onProfileTypeChanged;
  final ValueChanged<FamilyMemberModel?>? onMemberChanged;
  final VoidCallback? onAddFamilyPressed;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;
    final currentSelectedFamilyMember =
        familyMembers.any((member) => member.id == selectedFamilyMember?.id)
        ? familyMembers.firstWhere(
            (member) => member.id == selectedFamilyMember?.id,
          )
        : null;
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _buildSegmentButton(
                label: 'For Self',
                icon: Icons.person_rounded,
                isSelected: isSelf,
                // 🎯 जर वरून फंक्शन null आलं (Loading मुळे), तर क्लिक लॉक होईल
                onTap: onProfileTypeChanged != null
                    ? () => onProfileTypeChanged!(true)
                    : null,
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
                onTap: onProfileTypeChanged != null
                    ? () => onProfileTypeChanged!(false)
                    : null,
                colorScheme: colorScheme,
                textTheme: textTheme,
              ),
            ),
          ],
        ),
        if (!isSelf) ...[
          const SizedBox(height: 14),

          if (familyMembers.isEmpty)
            Center(
              child: FilledButton.icon(
                onPressed: onAddFamilyPressed,
                icon: const Icon(Icons.person_add),
                label: const Text("Add Family Member"),
              ),
            )
          else
            Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField<FamilyMemberModel>(
                    initialValue: currentSelectedFamilyMember,
                    hint: const Text("Choose Member"),
                    decoration: InputDecoration(
                      fillColor: onMemberChanged == null
                          ? colorScheme.surfaceContainerHighest.transparency(
                              0.3,
                            )
                          : colorScheme.surfaceContainerLow,
                      filled: true,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    items: familyMembers.map((member) {
                      return DropdownMenuItem<FamilyMemberModel>(
                        value: member,
                        child: Text(member.fullName),
                      );
                    }).toList(),
                    onChanged: onMemberChanged,
                  ),
                ),
                const SizedBox(width: 12),
                IconButton.filledTonal(
                  onPressed: onAddFamilyPressed,
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
    required VoidCallback? onTap,
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
          color: onTap == null
              ? colorScheme.surfaceContainerHighest.transparency(0.2)
              : (isSelected
                    ? colorScheme.primaryContainer
                    : colorScheme.surfaceContainerLow),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected && onTap != null
                ? colorScheme.primary
                : colorScheme.outlineVariant.transparency(0),
            width: 1.5,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 18,
              color: isSelected && onTap != null
                  ? colorScheme.primary
                  : colorScheme.onSurfaceVariant.transparency(
                      onTap == null ? 0.4 : 1.0,
                    ),
            ),
            const SizedBox(width: 8),
            Flexible(
              child: Text(
                label,
                overflow: TextOverflow.ellipsis,
                style: textTheme.labelLarge?.copyWith(
                  fontWeight: isSelected ? FontWeight.w900 : FontWeight.w600,
                  color: isSelected && onTap != null
                      ? colorScheme.primary
                      : colorScheme.onSurfaceVariant.transparency(
                          onTap == null ? 0.4 : 1.0,
                        ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
