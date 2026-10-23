import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:yodoctor/l10n/app_localizations.dart';
import 'package:yodoctor/modules/patient/models/family/family_member_model.dart';
import 'member_info_tag.dart';

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

  String _getRelationLabel(AppLocalizations? l10n, String relation) {
    switch (relation.toUpperCase()) {
      case 'FATHER':
        return l10n?.relationFather ?? 'Father';
      case 'MOTHER':
        return l10n?.relationMother ?? 'Mother';
      case 'SPOUSE':
        return l10n?.relationSpouse ?? 'Spouse';
      case 'SON':
        return l10n?.relationSon ?? 'Son';
      case 'DAUGHTER':
        return l10n?.relationDaughter ?? 'Daughter';
      case 'BROTHER':
        return l10n?.relationBrother ?? 'Brother';
      case 'SISTER':
        return l10n?.relationSister ?? 'Sister';
      case 'OTHER':
        return l10n?.relationOther ?? 'Other';
      default:
        return relation;
    }
  }

  String _getGenderLabel(AppLocalizations? l10n, String gender) {
    switch (gender.toUpperCase()) {
      case 'MALE':
        return l10n?.genderMale ?? 'Male';
      case 'FEMALE':
        return l10n?.genderFemale ?? 'Female';
      case 'OTHER':
        return l10n?.genderOther ?? 'Other';
      default:
        return gender;
    }
  }

  String _formatNumber(double val) =>
      val % 1 == 0 ? val.toInt().toString() : val.toString();

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    final TextTheme textTheme = Theme.of(context).textTheme;
    final l10n = AppLocalizations.of(context);

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
                      _getRelationLabel(l10n, member.relation),
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
                  MemberInfoTag(
                    icon: Icons.face_rounded,
                    value: _getGenderLabel(l10n, member.gender),
                  ),
                  MemberInfoTag(
                    icon: Icons.cake_rounded,
                    value: l10n?.yearsOld(member.age) ?? "${member.age} Years",
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
        final l10n = AppLocalizations.of(modalContext);

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
                            _getRelationLabel(l10n, member.relation),
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
                      l10n?.gender ?? 'Gender',
                      _getGenderLabel(l10n, member.gender),
                      itemWidth,
                    ),
                    _buildInfoBox(
                      modalContext,
                      Icons.cake_rounded,
                      l10n?.age ?? 'Age',
                      l10n?.yearsOld(member.age) ?? "${member.age} Years",
                      itemWidth,
                    ),
                    _buildInfoBox(
                      modalContext,
                      Icons.bloodtype_rounded,
                      l10n?.bloodGroup ?? 'Blood Group',
                      member.bloodGroup,
                      itemWidth,
                      isError: true,
                    ),
                    _buildInfoBox(
                      modalContext,
                      Icons.height_rounded,
                      l10n?.height ?? 'Height',
                      l10n?.heightInCm(_formatNumber(member.heightCm)) ??
                          "${_formatNumber(member.heightCm)} cm",
                      itemWidth,
                    ),
                    _buildInfoBox(
                      modalContext,
                      Icons.monitor_weight_outlined,
                      l10n?.weight ?? 'Weight',
                      l10n?.weightInKg(_formatNumber(member.weightKg)) ??
                          "${_formatNumber(member.weightKg)} kg",
                      itemWidth,
                    ),
                    _buildInfoBox(
                      modalContext,
                      Icons.calendar_month_rounded,
                      l10n?.dateOfBirth ?? 'Date of Birth',
                      DateFormat(
                        'dd MMM yyyy',
                      ).format(DateTime.parse(member.dob)),
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
                        label: Text(l10n?.remove ?? 'Remove'),
                        style: FilledButton.styleFrom(
                          backgroundColor: colorScheme.errorContainer,
                          foregroundColor: colorScheme.onErrorContainer,
                          disabledBackgroundColor:
                              colorScheme.surfaceContainerHighest,
                          disabledForegroundColor: colorScheme.onSurfaceVariant,
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
                        label: Text(l10n?.update ?? 'Update'),
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
        color: colorScheme.surfaceContainer,
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
                    color: colorScheme.onSurfaceVariant,
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
}
