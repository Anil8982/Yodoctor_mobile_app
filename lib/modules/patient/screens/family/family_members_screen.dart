import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/routes/app_routes.dart';
import '../../../../core/theme/app_theme.dart';
import '../../controllers/family_controller.dart';
import 'widgets/family_member_card.dart';
import 'widgets/family_header.dart';
import '../../models/family/family_member_model.dart';

class FamilyMembersScreen extends ConsumerStatefulWidget {
  const FamilyMembersScreen({super.key});

  @override
  ConsumerState<FamilyMembersScreen> createState() => _FamilyMembersScreenState();
}

class _FamilyMembersScreenState extends ConsumerState<FamilyMembersScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    final familyState = ref.watch(familyControllerProvider);
    final notifier = ref.read(familyControllerProvider.notifier);

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: theme.scaffoldBackgroundColor,

      appBar: AppBar(
        scrolledUnderElevation: 0,
        flexibleSpace: DecoratedBox(
          decoration: BoxDecoration(gradient: AppTheme.patientGradient),
        ),
        centerTitle: true,
        iconTheme: IconThemeData(color: colorScheme.onPrimary),
        title: Text(
          'Family Members',
          style: textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w700,
            color: colorScheme.onPrimary,
          ),
        ),
      ),

      body: familyState.members.isEmpty
          ? Column(
        children: [
          FamilyHeader(membersCount: familyState.members.length),
          Expanded(child: _buildEmptyState(context)),
        ],
      )
          : ListView.separated(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 120),
        itemCount: familyState.members.length + 1,
        physics: const BouncingScrollPhysics(),
        separatorBuilder: (context, index) {
          if (index == 0) return const SizedBox.shrink();
          return const SizedBox(height: 12);
        },
        itemBuilder: (context, index) {
          if (index == 0) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 16),
              child: FamilyHeader(membersCount: familyState.members.length),
            );
          }

          final member = familyState.members[index - 1];
          return FamilyMemberCard(
            member: member,
            onDelete: () async {
              await notifier.deleteMember(member.id);
            },
            onEdit: () => _openEditMemberScreen(context, member),
          );
        },
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
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: colorScheme.primaryContainer,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.group_add_rounded,
                color: colorScheme.onPrimaryContainer,
                size: 40,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'No family members yet',
              style: textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w900),
            ),
            const SizedBox(height: 8),
            Text(
              'Create profiles for your family members to manage their health records easily.',
              textAlign: TextAlign.center,
              style: textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}