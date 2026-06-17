import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/utils/dummy_data.dart';

class FamilyNotifier extends Notifier<List<FamilyMember>> {

  @override
  List<FamilyMember> build() {
    return List<FamilyMember>.from(DummyData.familyMembers);
  }

  void addMember(FamilyMember member) {
    state = [member, ...state];
  }

  void removeMember(FamilyMember member) {
    state = state.where((item) => item != member).toList();
  }

  void updateMember({
    required FamilyMember oldMember,
    required FamilyMember updatedMember,
  }) {
    final int index = state.indexOf(oldMember);
    if (index == -1) return;

    final updatedList = List<FamilyMember>.from(state);
    updatedList[index] = updatedMember;
    state = updatedList;
  }
}

final familyProvider = NotifierProvider.autoDispose<FamilyNotifier, List<FamilyMember>>(
  FamilyNotifier.new,
);