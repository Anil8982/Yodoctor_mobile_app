import 'package:flutter/foundation.dart';

import '../../../core/utils/dummy_data.dart';

class FamilyController extends ChangeNotifier {
  FamilyController()
    : _members = List<FamilyMember>.from(DummyData.familyMembers);

  final List<FamilyMember> _members;

  List<FamilyMember> get members => List<FamilyMember>.unmodifiable(_members);

  void addMember(FamilyMember member) {
    _members.insert(0, member);
    notifyListeners();
  }

  void removeMember(FamilyMember member) {
    _members.remove(member);
    notifyListeners();
  }

  void updateMember({
    required FamilyMember oldMember,
    required FamilyMember updatedMember,
  }) {
    final int index = _members.indexOf(oldMember);
    if (index == -1) {
      return;
    }

    _members[index] = updatedMember;
    notifyListeners();
  }
}
