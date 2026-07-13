import 'package:flutter/material.dart';
import 'member_info_tag.dart';
import '../../../models/family/family_member_model.dart';

class FamilyMemberCard extends StatelessWidget {
  const FamilyMemberCard({
    super.key,
    required this.member,
    this.onDelete,
    this.onEdit,
  });

  final FamilyMemberModel member;
  final VoidCallback? onDelete;
  final VoidCallback? onEdit;

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    final TextTheme textTheme = Theme.of(context).textTheme;

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(
          color: colorScheme.outlineVariant.withValues(alpha: 0.5),
        ),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: () => _showMemberDetails(context),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                children: <Widget>[
                  CircleAvatar(
                    radius: 24,
                    backgroundColor: colorScheme.primary,
                    child: Text(
                      member.fullName.isEmpty
                          ? "?"
                          : member.fullName.substring(0, 1).toUpperCase(),
                      style: TextStyle(
                        color: colorScheme.onPrimary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          member.fullName,
                          style: textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: colorScheme.secondaryContainer,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      member.relation,
                      style: textTheme.labelSmall?.copyWith(
                        color: colorScheme.onSecondaryContainer,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: <Widget>[
                  MemberInfoTag(icon: Icons.face_rounded, value: member.gender),
                  MemberInfoTag(
                    icon: Icons.cake_rounded,
                    value: "${member.age} Years",
                  ),
                  MemberInfoTag(
                    icon: Icons.bloodtype_rounded,
                    value: member.bloodGroup,
                    iconColor: colorScheme.error,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showMemberDetails(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Theme.of(
        context,
      ).colorScheme.surface.withValues(alpha: 0),
      builder: (BuildContext modalContext) {
        final ColorScheme colorScheme = Theme.of(modalContext).colorScheme;
        final TextTheme textTheme = Theme.of(modalContext).textTheme;
        final double screenWidth = MediaQuery.sizeOf(modalContext).width;
        final double itemWidth = (screenWidth - 52) / 2;

        return Container(
          decoration: BoxDecoration(
            color: colorScheme.surface,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              const SizedBox(height: 12),
              Container(
                width: 36,
                height: 4,
                decoration: BoxDecoration(
                  color: colorScheme.outlineVariant,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 24),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Row(
                  children: <Widget>[
                    CircleAvatar(
                      radius: 32,
                      backgroundColor: colorScheme.primaryContainer,
                      child: Text(
                        member.initials,
                        style: textTheme.headlineSmall?.copyWith(
                          color: colorScheme.onPrimaryContainer,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            member.fullName,
                            style: textTheme.headlineSmall?.copyWith(
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          Text(
                            member.relation,
                            style: textTheme.titleMedium?.copyWith(
                              color: colorScheme.primary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  children: <Widget>[
                    _buildInfoBox(
                      modalContext,
                      Icons.face_rounded,
                      'Gender',
                      member.gender,
                      itemWidth,
                    ),
                    _buildInfoBox(
                      modalContext,
                      Icons.cake_rounded,
                      'Age',
                      "${member.age} Years",
                      itemWidth,
                    ),
                    _buildInfoBox(
                      modalContext,
                      Icons.bloodtype_rounded,
                      'Blood Group',
                      member.bloodGroup,
                      itemWidth,
                      isError: true,
                    ),
                    _buildInfoBox(
                      modalContext,
                      Icons.height_rounded,
                      'Height',
                      "${member.heightCm} cm",
                      itemWidth,
                    ),
                    _buildInfoBox(
                      modalContext,
                      Icons.monitor_weight_outlined,
                      'Weight',
                      "${member.weightKg} kg",
                      itemWidth,
                    ),
                    _buildInfoBox(
                      modalContext,
                      Icons.calendar_month_rounded,
                      'Date of Birth',
                      member.dob,
                      itemWidth,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 100),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: FilledButton.tonalIcon(
                        onPressed: onDelete == null
                            ? null
                            : () {
                                Navigator.pop(modalContext);
                                onDelete?.call();
                              },
                        icon: const Icon(Icons.delete_outline_rounded),
                        label: const Text('Remove'),
                        style: FilledButton.styleFrom(
                          foregroundColor: colorScheme.error,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: FilledButton.icon(
                        onPressed: onEdit == null
                            ? null
                            : () {
                                Navigator.pop(modalContext);
                                onEdit?.call();
                              },
                        icon: const Icon(Icons.edit_rounded),
                        label: const Text('Update'),
                        style: FilledButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildInfoBox(
    BuildContext context,
    IconData icon,
    String label,
    String value,
    double width, {
    bool isError = false,
  }) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Container(
      width: width,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: colorScheme.outlineVariant.withValues(alpha: 0.3),
        ),
      ),
      child: Row(
        children: [
          Icon(
            icon,
            size: 20,
            color: isError ? colorScheme.error : colorScheme.primary,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: textTheme.labelSmall?.copyWith(
                    color: colorScheme.outline,
                  ),
                ),
                Text(
                  value,
                  style: textTheme.labelLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatNumber(double value, String unit) {
    final bool isWhole = value == value.roundToDouble();
    return '${isWhole ? value.toStringAsFixed(0) : value.toStringAsFixed(1)} $unit';
  }
}
