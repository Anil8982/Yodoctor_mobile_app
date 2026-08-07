import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:yodoctor/core/routes/app_routes.dart';
import '../../../../core/utils/app_spacing.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../controllers/doctor_profile_controller.dart';
import '../../widgets/doctor_sliver_app_bar.dart';
import 'widgets/profile_header_section.dart';

class DoctorProfileScreen extends ConsumerStatefulWidget {
  const DoctorProfileScreen({super.key});

  @override
  ConsumerState<DoctorProfileScreen> createState() =>
      _DoctorProfileScreenState();
}

class _DoctorProfileScreenState extends ConsumerState<DoctorProfileScreen> {
  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      ref.read(doctorProfileProvider.notifier).loadProfile();
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final profileState = ref.watch(doctorProfileProvider);
    final doctor = profileState.profile;

    if (profileState.isLoading || doctor == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      backgroundColor: colorScheme.surfaceContainerLow,
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            DoctorSliverAppBar(
              expandedHeight: 200,
              isNavBar: false,
              background: ProfileHeaderSection(doctor: doctor),
            ),
          ];
        },
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.sm,
              vertical: AppSpacing.md,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 🎯 Action Card to Edit Profile
                _buildActionCard(
                  context,
                  title: 'Edit Professional Profile',
                  subtitle: 'Update setup, timings, and documents',
                  icon: Icons.edit_note_rounded,
                  onTap: () => context.push(AppRoutes.doctorProfileEdit),
                ),
                const SizedBox(height: AppSpacing.xl),

                // 🎯 About / Bio Section (If available)
                if (doctor.bio.isNotEmpty) ...[
                  Text(
                    'About Doctor',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Text(
                    doctor.bio,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                      height: 1.4,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xl),
                ],

                Text(
                  'Profile Overview',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: AppSpacing.md),

                // 🎯 Quick Stats Row
                Row(
                  children: [
                    Expanded(
                      child: _buildStatCard(
                        context,
                        label: 'Experience',
                        value: '${doctor.experienceYears} Years',
                        icon: Icons.hourglass_empty_rounded,
                        cardColor: colorScheme.surface,
                      ),
                    ),
                    const SizedBox(width: AppSpacing.xxs),
                    Expanded(
                      child: _buildStatCard(
                        context,
                        label: 'Consultation Fee',
                        value: '₹${doctor.consultationFee}',
                        icon: Icons.payments_outlined,
                        cardColor: colorScheme.surface,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.sm),

                // 🎯 1. Professional & Council Compliance Card
                _buildSectionCard(
                  context,
                  title: 'Professional Registration',
                  icon: Icons.gavel_rounded,
                  children: [
                    _buildInfoRow(context, 'Reg. No', doctor.licenseNumber),
                    _buildInfoRow(context, 'Council', doctor.stateCouncil),
                    _buildInfoRow(context, 'Valid Till', doctor.validTill),
                  ],
                ),
                const SizedBox(height: AppSpacing.sm),

                // 🎯 2. Clinic Information Card
                _buildSectionCard(
                  context,
                  title: 'Clinic Information',
                  icon: Icons.gite_outlined,
                  children: [
                    _buildInfoRow(context, 'Name', doctor.clinicName),
                    _buildInfoRow(context, 'Type', doctor.practiceType),
                    _buildInfoRow(context, 'City', doctor.city),
                    _buildInfoRow(
                      context,
                      'Address',
                      doctor.address,
                      maxLines: 3,
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.sm),

                // 🎯 3. Availability & Consultation Card
                _buildSectionCard(
                  context,
                  title: 'Consultation & Timings',
                  icon: Icons.access_time_rounded,
                  children: [
                    _buildInfoRow(
                      context,
                      'Slot Time',
                      '${doctor.consultationDuration} Mins',
                    ),
                    _buildInfoRow(
                      context,
                      'Days',
                      doctor.availableDays.isNotEmpty
                          ? doctor.availableDays.join(', ')
                          : 'Not Configured',
                      maxLines: 2,
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.sm),

                // 🎯 4. Documents Verification Status Summary
                _buildSectionCard(
                  context,
                  title: 'KYC / Documents Status',
                  icon: Icons.folder_shared_outlined,
                  children: doctor.documents.isEmpty
                      ? [
                          Text(
                            'No documents uploaded.',
                            style: theme.textTheme.bodySmall,
                          ),
                        ]
                      : doctor.documents.entries.map<Widget>((entry) {
                          final key = entry.key;
                          // final value = entry.value;

                          return Padding(
                            padding: const EdgeInsets.only(
                              bottom: AppSpacing.sm,
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.description_outlined,
                                  size: 16,
                                  color: colorScheme.onSurfaceVariant,
                                ),
                                const SizedBox(width: AppSpacing.xs),
                                Expanded(
                                  child: Text(
                                    key,
                                    style: theme.textTheme.bodySmall?.copyWith(
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ),
                                Icon(
                                  Icons.check_circle,
                                  color: Colors.green,
                                  size: 18,
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                ),
                // const SizedBox(height: AppSpacing.sm),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionCard(
    BuildContext context, {
    required String title,
    required IconData icon,
    required List<Widget> children,
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Card(
      elevation: 0,
      color: colorScheme.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
        side: BorderSide(
          color: colorScheme.outlineVariant.withValues(alpha: 0.4),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: colorScheme.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(icon, color: colorScheme.primary, size: 20),
                ),
                const SizedBox(width: AppSpacing.sm),
                Text(
                  title,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w800,
                    color: colorScheme.onSurface,
                  ),
                ),
              ],
            ),
            const Divider(height: AppSpacing.xxl, thickness: 0.8),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _buildActionCard(
    BuildContext context, {
    required String title,
    required String subtitle,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Card(
      elevation: 0,
      color: colorScheme.primaryContainer.withValues(alpha: 0.2),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
        side: BorderSide(color: colorScheme.primary.withValues(alpha: 0.12)),
      ),
      child: ListTile(
        onTap: onTap,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: 4,
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        leading: CircleAvatar(
          backgroundColor: colorScheme.primary,
          foregroundColor: colorScheme.onPrimary,
          radius: 20,
          child: Icon(icon, size: 20),
        ),
        title: Text(
          title,
          style: theme.textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w800,
            color: colorScheme.primary,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: theme.textTheme.bodySmall?.copyWith(
            color: colorScheme.onSurfaceVariant.withValues(alpha: 0.8),
          ),
        ),
        trailing: Icon(
          Icons.arrow_forward_ios_rounded,
          color: colorScheme.primary,
          size: 14,
        ),
      ),
    );
  }

  Widget _buildStatCard(
    BuildContext context, {
    required String label,
    required String value,
    required IconData icon,
    required Color cardColor,
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Card(
      elevation: 0,
      color: cardColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(
          color: colorScheme.outlineVariant.withValues(alpha: 0.4),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: colorScheme.secondary, size: 20),
            const SizedBox(height: AppSpacing.md),
            Text(
              value,
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w900,
                color: colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: theme.textTheme.bodySmall?.copyWith(
                color: colorScheme.onSurfaceVariant,
                fontSize: 11,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(
    BuildContext context,
    String label,
    String value, {
    int maxLines = 1,
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.md),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80,
            child: Text(
              label,
              style: theme.textTheme.bodySmall?.copyWith(
                color: colorScheme.onSurfaceVariant,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Text(
              value,
              maxLines: maxLines,
              overflow: TextOverflow.ellipsis,
              style: theme.textTheme.bodySmall?.copyWith(
                fontWeight: FontWeight.w700,
                color: colorScheme.onSurface,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
