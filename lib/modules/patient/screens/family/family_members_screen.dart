import 'package:chroma_kit/chroma_kit.dart';
import 'package:flutter/material.dart';
import '../../../../core/utils/dummy_data.dart';
import 'widgets/family_member_card.dart';

class FamilyMembersScreen extends StatefulWidget {
  const FamilyMembersScreen({super.key});

  @override
  State<FamilyMembersScreen> createState() => _FamilyMembersScreenState();
}

class _FamilyMembersScreenState extends State<FamilyMembersScreen> {
  final List<FamilyMember> _familyMembers = DummyData.familyMembers;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surfaceContainerLowest,
      appBar: AppBar(
        backgroundColor: colorScheme.primary,
        title: const Text(
          'Family Members',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          _buildMemberCountBadge(colorScheme),
          const SizedBox(width: 16),
        ],
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: _familyMembers.length,
        physics: const BouncingScrollPhysics(),
        separatorBuilder: (context, index) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          return FamilyMemberCard(member: _familyMembers[index]);
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {},
        icon: const Icon(Icons.person_add_rounded),
        label: const Text('Add Member'),
      ),
    );
  }

  Widget _buildMemberCountBadge(ColorScheme colorScheme) {
    return Center(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: colorScheme.onPrimary.transparency(0.2),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          '${_familyMembers.length} Members',
          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12),
        ),
      ),
    );
  }
}