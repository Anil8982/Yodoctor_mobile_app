import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yodoctor/core/models/patient/doctor_profile.dart';
import 'package:yodoctor/core/utils/dummy_data.dart';

class DoctorsManagementState {
  final List<DoctorProfile> allDoctors;
  final List<DoctorProfile> filteredDoctors;
  final String searchQuery;
  final String selectedFilter;
  final Map<String, String> doctorStatuses; // Doctor ID -> Status ('Pending', 'Approved', 'Rejected')

  DoctorsManagementState({
    required this.allDoctors,
    required this.filteredDoctors,
    required this.searchQuery,
    required this.selectedFilter,
    required this.doctorStatuses,
  });

  DoctorsManagementState copyWith({
    List<DoctorProfile>? allDoctors,
    List<DoctorProfile>? filteredDoctors,
    String? searchQuery,
    String? selectedFilter,
    Map<String, String>? doctorStatuses,
  }) {
    return DoctorsManagementState(
      allDoctors: allDoctors ?? this.allDoctors,
      filteredDoctors: filteredDoctors ?? this.filteredDoctors,
      searchQuery: searchQuery ?? this.searchQuery,
      selectedFilter: selectedFilter ?? this.selectedFilter,
      doctorStatuses: doctorStatuses ?? this.doctorStatuses,
    );
  }
}

class DoctorsManagementNotifier extends AsyncNotifier<DoctorsManagementState> {
  @override
  Future<DoctorsManagementState> build() async {
    final initialDoctors = List<DoctorProfile>.from(DummyData.allDoctors);

    final initialStatuses = <String, String>{};
    for (var doc in initialDoctors) {
      initialStatuses[doc.id] = 'Approved';
    }

    return DoctorsManagementState(
      allDoctors: initialDoctors,
      filteredDoctors: initialDoctors,
      searchQuery: '',
      selectedFilter: 'All',
      doctorStatuses: initialStatuses,
    );
  }

  void searchDoctors(String query) {
    final previousState = state;
    if (!previousState.hasValue) return;

    final current = previousState.value!;
    final updatedQuery = query.trim().toLowerCase();

    _applyFilters(current.allDoctors, updatedQuery, current.selectedFilter, current.doctorStatuses);
  }

  void setFilter(String filter) {
    final previousState = state;
    if (!previousState.hasValue) return;

    final current = previousState.value!;
    _applyFilters(current.allDoctors, current.searchQuery, filter, current.doctorStatuses);
  }

  void updateDoctorStatus(String doctorId, String newStatus) {
    final previousState = state;
    if (!previousState.hasValue) return;

    final current = previousState.value!;
    final updatedStatuses = Map<String, String>.from(current.doctorStatuses);
    updatedStatuses[doctorId] = newStatus;

    _applyFilters(current.allDoctors, current.searchQuery, current.selectedFilter, updatedStatuses);
  }

  void deleteDoctor(String doctorId) {
    final previousState = state;
    if (!previousState.hasValue) return;

    final current = previousState.value!;
    final updatedAllDoctors = current.allDoctors.where((doc) => doc.id != doctorId).toList();

    final updatedStatuses = Map<String, String>.from(current.doctorStatuses);
    updatedStatuses.remove(doctorId);

    _applyFilters(updatedAllDoctors, current.searchQuery, current.selectedFilter, updatedStatuses);
  }

  Future<void> refreshDoctors() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final initialDoctors = List<DoctorProfile>.from(DummyData.allDoctors);
      final initialStatuses = <String, String>{};
      for (var doc in initialDoctors) {
        initialStatuses[doc.id] = 'Approved';
      }
      return DoctorsManagementState(
        allDoctors: initialDoctors,
        filteredDoctors: initialDoctors,
        searchQuery: '',
        selectedFilter: 'All',
        doctorStatuses: initialStatuses,
      );
    });
  }

  void _applyFilters(List<DoctorProfile> all, String search, String filter, Map<String, String> statuses) {
    final filtered = all.where((doctor) {
      final matchesSearch = doctor.name.toLowerCase().contains(search) ||
          doctor.specialty.toLowerCase().contains(search) ||
          doctor.location.toLowerCase().contains(search) ||
          doctor.hospital.toLowerCase().contains(search);

      final currentStatus = statuses[doctor.id] ?? 'Pending';
      final matchesFilter = filter == 'All' || currentStatus.toLowerCase() == filter.toLowerCase();

      return matchesSearch && matchesFilter;
    }).toList();

    state = AsyncValue.data(DoctorsManagementState(
      allDoctors: all,
      filteredDoctors: filtered,
      searchQuery: search,
      selectedFilter: filter,
      doctorStatuses: statuses,
    ));
  }
}

final doctorsManagementProvider = AsyncNotifierProvider.autoDispose<DoctorsManagementNotifier, DoctorsManagementState>(
  DoctorsManagementNotifier.new,
);