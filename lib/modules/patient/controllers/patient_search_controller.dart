import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yodoctor/core/constants/log_tags.dart';
import 'package:yodoctor/core/debug/app_logger.dart';
import '../models/search/city_model.dart';
import '../models/search/doctor_name_model.dart';
import '../models/search/doctor_search_model.dart';
import '../models/search/specialty_model.dart';
import '../repositories/patient_search_repository.dart';

class PatientSearchState {
  final bool isLoading;
  final String? errorMessage;
  final List<String> trendingSpecialties;
  final List<DoctorSearchModel> doctorSuggestions;
  final List<CityModel> cities;
  final List<DoctorNameModel> doctorNames;
  final String selectedTrending;
  final String location;
  final String query;

  PatientSearchState({
    this.isLoading = false,
    this.errorMessage,
    this.trendingSpecialties = const [],
    this.doctorSuggestions = const [],
    this.cities = const [],
    this.doctorNames = const [],
    this.selectedTrending = "",
    this.location = "",
    this.query = "",
  });

  PatientSearchState copyWith({
    bool? isLoading,
    String? errorMessage,
    bool clearError = false,
    List<String>? trendingSpecialties,
    List<DoctorSearchModel>? doctorSuggestions,
    List<CityModel>? cities,
    List<DoctorNameModel>? doctorNames,
    String? selectedTrending,
    String? location,
    String? query,
  }) {
    return PatientSearchState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      trendingSpecialties: trendingSpecialties ?? this.trendingSpecialties,
      doctorSuggestions: doctorSuggestions ?? this.doctorSuggestions,
      cities: cities ?? this.cities,
      doctorNames: doctorNames ?? this.doctorNames,
      selectedTrending: selectedTrending ?? this.selectedTrending,
      location: location ?? this.location,
      query: query ?? this.query,
    );
  }
}

final patientSearchControllerProvider =
    NotifierProvider<PatientSearchController, PatientSearchState>(
      PatientSearchController.new,
    );

class PatientSearchController extends Notifier<PatientSearchState> {
  static const String _subTag = 'PatientSearchController';
  Timer? _debounce;

  @override
  PatientSearchState build() {
    ref.onDispose(() => _debounce?.cancel());
    return PatientSearchState();
  }

  Future<void> loadTrendingSpecialties() async {
    if (state.isLoading) return;

    state = state.copyWith(isLoading: true, clearError: true);
    try {
      final repository = ref.read(patientSearchRepositoryProvider);
      final response = await repository.getSpecialties();

      if (response.statusCode == 200) {
        final rawList = response.data["data"] as List;

        final list = rawList
            .map((e) => SpecialtyModel.fromJson(e).name)
            .toList();

        state = state.copyWith(trendingSpecialties: list, isLoading: false);
      } else {
        state = state.copyWith(
          errorMessage: response.data["message"],
          isLoading: false,
        );
      }
    } catch (e, st) {
      state = state.copyWith(
        errorMessage: "Failed to load specialties",
        isLoading: false,
      );
      AppLogger.exception(
        e,
        st,
        message: 'Trending specialties fetch failed',
        tag: LogTags.patient,
        subTag: _subTag,
      );
    }
  }

  void updateQuery(String value) {
    state = state.copyWith(query: value);
    _debounce?.cancel();

    if (value.isEmpty) {
      state = state.copyWith(doctorSuggestions: const []);
      return;
    }

    _debounce = Timer(const Duration(milliseconds: 400), () {
      unawaited(_loadDoctorSuggestions());
    });
  }

  Future<void> _loadDoctorSuggestions() async {
    try {
      final repository = ref.read(patientSearchRepositoryProvider);
      final response = await repository.searchDoctors(
        search: state.query,
        city: state.location,
      );

      if (response.statusCode == 200) {
        final list = (response.data["data"]["doctors"] as List)
            .map((e) => DoctorSearchModel.fromJson(e))
            .toList();
        state = state.copyWith(doctorSuggestions: list);
      }
    } catch (e, st) {
      AppLogger.exception(
        e,
        st,
        message: 'Suggestions fetch stream failed',
        tag: LogTags.patient,
        subTag: _subTag,
      );
    }
  }

  Future<void> updateLocation(String value) async {
    state = state.copyWith(location: value);
    try {
      final repository = ref.read(patientSearchRepositoryProvider);
      final response = await repository.getCities(search: value);

      if (response.statusCode == 200) {
        final list = (response.data["data"] as List)
            .map((e) => CityModel.fromJson(e))
            .toList();
        state = state.copyWith(cities: list);
      }
    } catch (e, st) {
      AppLogger.exception(
        e,
        st,
        message: 'City repositories query failed',
        tag: LogTags.patient,
        subTag: _subTag,
      );
    }
  }

  Future<void> loadDoctorNames() async {
    try {
      final repository = ref.read(patientSearchRepositoryProvider);
      final response = await repository.getDoctorNames();

      if (response.statusCode == 200) {
        final list = (response.data["data"] as List)
            .map((e) => DoctorNameModel.fromJson(e))
            .toList();
        state = state.copyWith(doctorNames: list);
      }
    } catch (e, st) {
      AppLogger.exception(
        e,
        st,
        message: 'Names mapping runtime fault',
        tag: LogTags.patient,
        subTag: _subTag,
      );
    }
  }
  Future<void> selectTrending(String specialty) async {
    state = state.copyWith(selectedTrending: specialty, query: specialty);
    await _loadDoctorSuggestions();
  }

  void clearSuggestions() {
    state = state.copyWith(doctorSuggestions: const []);
  }
}
