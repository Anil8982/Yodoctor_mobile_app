import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/utils/dummy_data.dart';

// 🎯 Unified immutable state structure holding raw data list, filtered results, and criteria keys
class DoctorListingState {
  final List<DoctorProfile> allDoctors;
  final List<DoctorProfile> filteredDoctors;
  final String selectedSpecialty;
  final String activeQuery;

  DoctorListingState({
    this.allDoctors = const [],
    this.filteredDoctors = const [],
    this.selectedSpecialty = 'All',
    this.activeQuery = '',
  });

  DoctorListingState copyWith({
    List<DoctorProfile>? allDoctors,
    List<DoctorProfile>? filteredDoctors,
    String? selectedSpecialty,
    String? activeQuery,
  }) {
    return DoctorListingState(
      allDoctors: allDoctors ?? this.allDoctors,
      filteredDoctors: filteredDoctors ?? this.filteredDoctors,
      selectedSpecialty: selectedSpecialty ?? this.selectedSpecialty,
      activeQuery: activeQuery ?? this.activeQuery,
    );
  }
}

// 🎯 FIX: Extended manual AsyncNotifier base class to resolve inheritance bounds and undefined state errors
class DoctorListingNotifier extends AsyncNotifier<DoctorListingState> {

  @override
  Future<DoctorListingState> build() async {
    // Automatically triggers initial listing fetch query on setup initialization
    final results = await DummyData.searchDoctors(query: '');
    return DoctorListingState(
      allDoctors: results,
      filteredDoctors: results,
    );
  }

  // Fetch or query repository dataset based on dynamic user search inputs
  Future<void> loadDoctors({String query = ''}) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final results = await DummyData.searchDoctors(query: query);

      return DoctorListingState(
        allDoctors: results,
        activeQuery: query,
        selectedSpecialty: 'All', // Reset filter category on fresh search operations
        filteredDoctors: results,
      );
    });
  }

  // Set selected specialty channel criteria seamlessly
  void setSpecialty(String specialty) {
    final currentState = state.value;
    if (currentState == null || currentState.selectedSpecialty == specialty) return;

    List<DoctorProfile> computedResults;
    if (specialty == 'All') {
      computedResults = List.from(currentState.allDoctors);
    } else {
      computedResults = currentState.allDoctors
          .where((item) => item.specialty == specialty)
          .toList();
    }

    state = AsyncValue.data(currentState.copyWith(
      selectedSpecialty: specialty,
      filteredDoctors: computedResults,
    ));
  }

  // Dynamic utility mapping sync array options array cleanly
  List<String> getSpecialtiesList() {
    final currentState = state.value;
    if (currentState == null) return ['All'];

    final Set<String> values = {
      'All',
      ...currentState.allDoctors.map((item) => item.specialty),
    };
    return values.toList();
  }
}

// 🎯 FIX: Provider registration utilizing autoDispose modifier to safely track lifecycle bounds
final doctorListingProvider = AsyncNotifierProvider.autoDispose<DoctorListingNotifier, DoctorListingState>(
  DoctorListingNotifier.new,
);