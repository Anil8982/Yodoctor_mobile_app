import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yodoctor/core/constants/log_tags.dart';
import 'package:yodoctor/core/debug/app_logger.dart';
import '../models/search/doctor_search_model.dart';
import '../repositories/patient_search_repository.dart';

class DoctorListingState {
  final bool isLoading;
  final String? errorMessage;
  final List<DoctorSearchModel> allDoctors;
  final List<DoctorSearchModel> doctors;
  final String selectedSpecialty;
  final String activeQuery;

  DoctorListingState({
    this.isLoading = false,
    this.errorMessage,
    this.allDoctors = const [],
    this.doctors = const [],
    this.selectedSpecialty = "All",
    this.activeQuery = "",
  });

  int get foundCount => doctors.length;

  List<String> get specialties {
    final values = <String>{"All", ...allDoctors.map((e) => e.specialty)};
    return values.toList();
  }

  DoctorListingState copyWith({
    bool? isLoading,
    String? errorMessage,
    List<DoctorSearchModel>? allDoctors,
    List<DoctorSearchModel>? doctors,
    String? selectedSpecialty,
    String? activeQuery,
  }) {
    return DoctorListingState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
      allDoctors: allDoctors ?? this.allDoctors,
      doctors: doctors ?? this.doctors,
      selectedSpecialty: selectedSpecialty ?? this.selectedSpecialty,
      activeQuery: activeQuery ?? this.activeQuery,
    );
  }
}

final doctorListingControllerProvider =
NotifierProvider<DoctorListingController, DoctorListingState>(
  DoctorListingController.new,
);

class DoctorListingController extends Notifier<DoctorListingState> {
  static const String _subTag = 'DoctorListingController';

  @override
  DoctorListingState build() {
    return DoctorListingState(); // Initial State Lock
  }

  Future<void> loadDoctors({
    String query = "",
    String city = "",
    int page = 1,
  }) async {
    // 🎯 Loading Guard
    if (state.isLoading) return;

    state = state.copyWith(
      isLoading: true,
      errorMessage: null,
      activeQuery: query,
    );

    AppLogger.info('Loading doctors list matrix', tag: LogTags.patient, subTag: _subTag);

    try {
      final repository = ref.read(patientSearchRepositoryProvider);
      final response = await repository.searchDoctors(
        search: query,
        city: city,
        page: page,
      );

      if (response.statusCode == 200) {
        final rawDoctorsList = response.data["data"]["doctors"] as List;
        final parsedAllDoctors = rawDoctorsList.map((e) => DoctorSearchModel.fromJson(e)).toList();

        // Safe evaluation filtering pipeline
        final filteredDoctors = _computeSpecialtyFilter(parsedAllDoctors, state.selectedSpecialty);

        state = state.copyWith(
          allDoctors: parsedAllDoctors,
          doctors: filteredDoctors,
          isLoading: false,
        );
      } else {
        final errorMsg = response.data["message"] ?? "Failed to load doctors";
        state = state.copyWith(
          errorMessage: errorMsg,
          allDoctors: const [],
          doctors: const [],
          isLoading: false,
        );
        AppLogger.warning('Failed to load doctors: $errorMsg', tag: LogTags.patient, subTag: _subTag);
      }
    } catch (e, stackTrace) {
      state = state.copyWith(
        errorMessage: "Failed to load doctors",
        allDoctors: const [],
        doctors: const [],
        isLoading: false,
      );
      AppLogger.exception(e, stackTrace, message: 'Failed to load doctors', tag: LogTags.patient, subTag: _subTag);
    }
  }

  void setSpecialty(String specialty) {
    if (state.selectedSpecialty == specialty) return;

    final filteredDoctors = _computeSpecialtyFilter(state.allDoctors, specialty);

    state = state.copyWith(
      selectedSpecialty: specialty,
      doctors: filteredDoctors,
    );
  }

  List<DoctorSearchModel> _computeSpecialtyFilter(List<DoctorSearchModel> targetList, String specialty) {
    if (specialty == "All") {
      return List.from(targetList);
    }
    return targetList.where((e) => e.specialty == specialty).toList();
  }
}