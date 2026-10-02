import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yodoctor/core/models/admin/enquiry_model.dart';
import 'package:yodoctor/core/utils/dummy_data.dart';

class EnquiryState {
  final List<EnquiryModel> allEnquiries;
  final int? expandedIndex;
  final Set<int> deletedIds;

  EnquiryState({
    required this.allEnquiries,
    this.expandedIndex,
    required this.deletedIds,
  });

  EnquiryState copyWith({
    List<EnquiryModel>? allEnquiries,
    int? expandedIndex,
    bool resetExpansion = false,
    Set<int>? deletedIds,
  }) {
    return EnquiryState(
      allEnquiries: allEnquiries ?? this.allEnquiries,
      expandedIndex: resetExpansion ? null : (expandedIndex ?? this.expandedIndex),
      deletedIds: deletedIds ?? this.deletedIds,
    );
  }
}

class EnquiryNotifier extends AsyncNotifier<EnquiryState> {
  @override
  Future<EnquiryState> build() async {
    final data = await DummyData.getEnquiries();
    return EnquiryState(
      allEnquiries: data,
      expandedIndex: null,
      deletedIds: {},
    );
  }

  void toggleExpansion(int index) {
    final previousState = state;
    if (!previousState.hasValue) return;

    final current = previousState.value!;
    final newExpandedIndex = current.expandedIndex == index ? null : index;

    state = AsyncValue.data(current.copyWith(expandedIndex: newExpandedIndex));
  }

  void deleteEnquiry(int id) {
    final previousState = state;
    if (!previousState.hasValue) return;

    final current = previousState.value!;
    final updatedDeletedIds = Set<int>.from(current.deletedIds)..add(id);
    final updatedEnquiries = current.allEnquiries.where((item) => item.id != id).toList();

    state = AsyncValue.data(current.copyWith(
      allEnquiries: updatedEnquiries,
      deletedIds: updatedDeletedIds,
      resetExpansion: true,
    ));
  }

  void resolveEnquiry(int id) {
    final previousState = state;
    if (!previousState.hasValue) return;

    final current = previousState.value!;
    final updatedEnquiries = current.allEnquiries.map((enquiry) {
      if (enquiry.id == id) {
        return enquiry.copyWith(status: 'Resolved');
      }
      return enquiry;
    }).toList();

    state = AsyncValue.data(current.copyWith(allEnquiries: updatedEnquiries));
  }

  Future<void> refreshEnquiries() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final data = await DummyData.getEnquiries();
      return EnquiryState(
        allEnquiries: data,
        expandedIndex: null,
        deletedIds: {},
      );
    });
  }
}

final enquiryProvider = AsyncNotifierProvider.autoDispose<EnquiryNotifier, EnquiryState>(
  EnquiryNotifier.new,
);