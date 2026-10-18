import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yodoctor/core/constants/log_tags.dart';
import 'package:yodoctor/core/debug/app_logger.dart';
import '../models/search/city_model.dart';
import '../models/search/doctor_name_model.dart';
import '../models/search/search_mode.dart';
import '../models/search/search_params.dart';
import '../models/search/suggestion_model.dart';
import '../models/search/specialty_model.dart';
import '../repositories/patient_search_repository.dart';

class PatientSearchState {
  final bool isLoading;
  final String? error;
  final String searchQuery;
  final String locationQuery;
  final SearchMode mode;
  final List<SuggestionModel> searchSuggestions;
  final List<SuggestionModel> citySuggestions;
  final List<String> specialties;
  final String? selectedSpecialty;
  final String? selectedCity;

  PatientSearchState({
    this.isLoading = false,
    this.error,
    this.searchQuery = "",
    this.locationQuery = "",
    this.mode = SearchMode.doctor,
    this.searchSuggestions = const [],
    this.citySuggestions = const [],
    this.specialties = const [],
    this.selectedSpecialty,
    this.selectedCity,
  });

  PatientSearchState copyWith({
    bool? isLoading,
    String? error,
    bool clearError = false,
    String? searchQuery,
    String? locationQuery,
    SearchMode? mode,
    List<SuggestionModel>? searchSuggestions,
    List<SuggestionModel>? citySuggestions,
    List<String>? specialties,
    String? selectedSpecialty,
    String? selectedCity,
    bool clearSpecialty = false,
    bool clearCity = false,
  }) {
    return PatientSearchState(
      isLoading: isLoading ?? this.isLoading,
      error: clearError ? null : (error ?? this.error),
      searchQuery: searchQuery ?? this.searchQuery,
      locationQuery: locationQuery ?? this.locationQuery,
      mode: mode ?? this.mode,
      searchSuggestions: searchSuggestions ?? this.searchSuggestions,
      citySuggestions: citySuggestions ?? this.citySuggestions,
      specialties: specialties ?? this.specialties,
      selectedSpecialty: clearSpecialty ? null : (selectedSpecialty ?? this.selectedSpecialty),
      selectedCity: clearCity ? null : (selectedCity ?? this.selectedCity),
    );
  }
}

final patientSearchControllerProvider =
NotifierProvider<PatientSearchController, PatientSearchState>(
  PatientSearchController.new,
);

class PatientSearchController extends Notifier<PatientSearchState> {
  static const String _subTag = 'PatientSearchController';
  Timer? _searchDebounce;
  Timer? _locationDebounce;
  List<DoctorNameModel>? _cachedDoctorNames;
  List<DoctorNameModel>? _cachedClinicNames;
  DateTime? _doctorCacheTime;
  DateTime? _clinicCacheTime;
  static const _cacheDuration = Duration(minutes: 15);

  @override
  PatientSearchState build() {
    ref.onDispose(() {
      _searchDebounce?.cancel();
      _locationDebounce?.cancel();
    });
    return PatientSearchState();
  }

  Future<void> initialize() async {
    if (state.specialties.isNotEmpty) return;
    await _loadSpecialties();
  }

  void clearAll() {
    state = PatientSearchState(specialties: state.specialties);
  }

  void changeMode(SearchMode mode) {
    if (state.mode == mode) return;
    state = state.copyWith(
      mode: mode,
      searchQuery: "",
      searchSuggestions: const [],
      clearSpecialty: true,
    );
  }

  void updateSearch(String value) {
    state = state.copyWith(
      searchQuery: value,
      searchSuggestions: const [],
      clearSpecialty: true, // User typing manual search resets selected specialty
    );
    _searchDebounce?.cancel();
    if (value.trim().isEmpty) {
      state = state.copyWith(searchSuggestions: const []);
      return;
    }
    _searchDebounce = Timer(const Duration(milliseconds: 300), () {
      unawaited(_fetchSearchSuggestions(value));
    });
  }

  void updateLocation(String value) {
    state = state.copyWith(
      locationQuery: value,
      citySuggestions: const [],
      clearCity: true,
    );
    _locationDebounce?.cancel();
    if (value.trim().isEmpty) {
      state = state.copyWith(citySuggestions: const []);
      return;
    }
    _locationDebounce = Timer(const Duration(milliseconds: 300), () {
      unawaited(_fetchLocationSuggestions(value));
    });
  }

  void selectSuggestion(SuggestionModel suggestion) {
    state = state.copyWith(
      searchQuery: suggestion.title,
      searchSuggestions: const [],
      clearSpecialty: true,
    );
  }

  void selectCity(SuggestionModel suggestion) {
    state = state.copyWith(
      locationQuery: suggestion.title,
      citySuggestions: const [],
      selectedCity: suggestion.title,
    );
  }

  void selectSpecialty(String specialty) {
    state = state.copyWith(
      selectedSpecialty: specialty,
      searchQuery: specialty, // Align search query with selected specialty
      searchSuggestions: const [],
    );
  }

  void clearSearch() {
    state = state.copyWith(
      searchQuery: "",
      searchSuggestions: const [],
      clearSpecialty: true,
    );
  }

  void clearLocation() {
    state = state.copyWith(
      locationQuery: "",
      citySuggestions: const [],
      clearCity: true,
    );
  }

  void restoreState(String? search, String? city) {
    state = state.copyWith(
      searchQuery: search ?? "",
      locationQuery: city ?? "",
      selectedSpecialty: null,
      selectedCity: city,
    );
  }

  SearchParams prepareSearch() {
    final rawSearch = (state.selectedSpecialty ?? state.searchQuery).trim();
    final rawCity = (state.selectedCity ?? state.locationQuery).trim();

    return SearchParams(
      search: rawSearch,
      city: rawCity,
    );
  }

  bool canSearch() => true;

  String? getSearchError() => null;

  Future<void> _loadSpecialties() async {
    state = state.copyWith(isLoading: true, clearError: true);
    try {
      final repository = ref.read(patientSearchRepositoryProvider);
      final response = await repository.getSpecialties();
      if (response.statusCode == 200) {
        final rawList = response.data["data"] as List;
        final list = rawList
            .map((e) => SpecialtyModel.fromJson(e).name)
            .toList();
        state = state.copyWith(specialties: list, isLoading: false);
      } else {
        state = state.copyWith(
          error: response.data["message"] ?? "Failed to load specialties",
          isLoading: false,
        );
      }
    } catch (e, st) {
      state = state.copyWith(
        error: "Failed to load specialties",
        isLoading: false,
      );
      AppLogger.exception(
        e,
        st,
        message: 'Load specialties failed',
        tag: LogTags.patient,
        subTag: _subTag,
      );
    }
  }

  Future<void> _fetchSearchSuggestions(String query) async {
    try {
      final repository = ref.read(patientSearchRepositoryProvider);
      final allSuggestions = <SuggestionModel>[];

      if (state.mode == SearchMode.doctor) {
        final names = await _getDoctorNames(repository);
        final doctorSuggestions = names
            .where((e) => e.name.toLowerCase().contains(query.toLowerCase()))
            .map((e) => SuggestionModel(
          id: 'doctor_${e.name.hashCode}',
          title: e.name,
          subtitle: '👨‍⚕️ Doctor',
        ))
            .toList();
        allSuggestions.addAll(doctorSuggestions);
      }

      final clinicNames = await _getClinicNames(repository);
      final clinicSuggestions = clinicNames
          .where((e) => e.name.toLowerCase().contains(query.toLowerCase()))
          .map((e) => SuggestionModel(
        id: 'clinic_${e.name.hashCode}',
        title: e.name,
        subtitle: '🏥 Clinic',
      ))
          .toList();
      allSuggestions.addAll(clinicSuggestions);

      final specialtiesResponse = await repository.getSpecialties();
      if (specialtiesResponse.statusCode == 200) {
        final rawList = specialtiesResponse.data["data"] as List;
        final diseaseSuggestions = rawList
            .map((e) => SpecialtyModel.fromJson(e).name)
            .where((e) => e.toLowerCase().contains(query.toLowerCase()))
            .map((e) => SuggestionModel(
          id: 'disease_$e',
          title: e,
          subtitle: '🩺 Specialty',
        ))
            .toList();
        allSuggestions.addAll(diseaseSuggestions);
      }

      final cityResponse = await repository.getCities(search: query);
      if (cityResponse.statusCode == 200) {
        final citySuggestions = (cityResponse.data["data"] as List)
            .map((e) => CityModel.fromJson(e))
            .map((e) => SuggestionModel(
          id: 'city_${e.city.hashCode}',
          title: e.city,
          subtitle: '📍 ${e.label}',
        ))
            .toList();
        allSuggestions.addAll(citySuggestions);
      }

      state = state.copyWith(searchSuggestions: allSuggestions);
    } catch (e, st) {
      AppLogger.exception(
        e,
        st,
        message: 'Search suggestions failed',
        tag: LogTags.patient,
        subTag: _subTag,
      );
    }
  }

  Future<List<DoctorNameModel>> _getDoctorNames(
      PatientSearchRepository repository,
      ) async {
    if (_cachedDoctorNames != null &&
        _doctorCacheTime != null &&
        DateTime.now().difference(_doctorCacheTime!) < _cacheDuration) {
      return _cachedDoctorNames!;
    }
    final response = await repository.getDoctorNames();
    if (response.statusCode == 200) {
      _cachedDoctorNames = (response.data["data"] as List)
          .map((e) => DoctorNameModel.fromJson(e))
          .toList();
      _doctorCacheTime = DateTime.now();
      return _cachedDoctorNames!;
    }
    return [];
  }

  Future<List<DoctorNameModel>> _getClinicNames(
      PatientSearchRepository repository,
      ) async {
    if (_cachedClinicNames != null &&
        _clinicCacheTime != null &&
        DateTime.now().difference(_clinicCacheTime!) < _cacheDuration) {
      return _cachedClinicNames!;
    }
    final response = await repository.getClinicNames();
    if (response.statusCode == 200) {
      _cachedClinicNames = (response.data["data"] as List)
          .map((e) => DoctorNameModel.fromJson(e))
          .toList();
      _clinicCacheTime = DateTime.now();
      return _cachedClinicNames!;
    }
    return [];
  }

  Future<void> _fetchLocationSuggestions(String query) async {
    try {
      final repository = ref.read(patientSearchRepositoryProvider);
      final response = await repository.getCities(search: query);
      if (response.statusCode == 200) {
        final list = (response.data["data"] as List)
            .map((e) => CityModel.fromJson(e))
            .map((e) => SuggestionModel.fromCity(e))
            .toList();
        state = state.copyWith(citySuggestions: list);
      }
    } catch (e, st) {
      AppLogger.exception(
        e,
        st,
        message: 'Location suggestions failed',
        tag: LogTags.patient,
        subTag: _subTag,
      );
    }
  }
}