import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:yodoctor/modules/widgets/app_header.dart';

import '../../../../core/routes/app_routes.dart';
import '../../controllers/family_controller.dart';
import '../../models/family/family_member_model.dart';
import 'widgets/family_header.dart';
import 'widgets/family_member_card.dart';

class FamilyMembersScreen extends ConsumerStatefulWidget {
  const FamilyMembersScreen({super.key});

  @override
  ConsumerState<FamilyMembersScreen> createState() =>
      _FamilyMembersScreenState();
}

class _FamilyMembersScreenState extends ConsumerState<FamilyMembersScreen> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final familyState = ref.watch(familyControllerProvider);
    final notifier = ref.read(familyControllerProvider.notifier);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: const AppHeader(title: 'Family Members'),
      body: familyState.members.isEmpty
          ? Column(
        children: [
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: FamilyHeader(membersCount: 0),
          ),
          Expanded(child: _buildEmptyState(context)),
        ],
      )
          : ListView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
        physics: const BouncingScrollPhysics(),
        children: [
          FamilyHeader(membersCount: familyState.members.length),
          const SizedBox(height: 16),
          ...familyState.members.map((member) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: FamilyMemberCard(
                member: member,
                onDelete: () async {
                  await notifier.deleteMember(member.id);
                },
                onEdit: () => _openEditMemberScreen(context, member),
              ),
            );
          }),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: FloatingActionButton.extended(
        heroTag: 'family_members_screen_fab_tag',
        onPressed: () => _openAddMemberScreen(context),
        icon: const Icon(Icons.person_add_rounded),
        label: const Text('Add Member'),
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.onPrimary,
      ),
    );
  }

  Future<void> _openAddMemberScreen(BuildContext context) async {
    final messenger = ScaffoldMessenger.of(context);
    final colorScheme = Theme.of(context).colorScheme;

    final bool? wasAdded = await context.push<bool>(AppRoutes.addFamilyMember);

    if (!mounted || wasAdded != true) return;

    messenger.showSnackBar(
      SnackBar(
        content: const Text('Member added successfully.'),
        behavior: SnackBarBehavior.floating,
        backgroundColor: colorScheme.secondary,
      ),
    );
  }

  Future<void> _openEditMemberScreen(
      BuildContext context,
      FamilyMemberModel member,
      ) async {
    final messenger = ScaffoldMessenger.of(context);
    final colorScheme = Theme.of(context).colorScheme;

    final bool? wasUpdated = await context.push<bool>(
      AppRoutes.addFamilyMember,
      extra: member,
    );

    if (!mounted || wasUpdated != true) return;

    messenger.showSnackBar(
      SnackBar(
        content: const Text('Member updated successfully.'),
        behavior: SnackBarBehavior.floating,
        backgroundColor: colorScheme.secondary,
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: colorScheme.primaryContainer.withAlpha(120),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.group_add_rounded,
                color: colorScheme.primary,
                size: 44,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'No family members yet',
              style: textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Create profiles for your family members to manage their health records easily.',
              textAlign: TextAlign.center,
              style: textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
                height: 1.4,
              ),
            ),
          ],
        ),
      ),
    );
  }
}