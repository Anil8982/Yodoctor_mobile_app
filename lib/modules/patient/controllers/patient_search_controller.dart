import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/utils/dummy_data.dart';

class PatientSearchState {
  final bool isLoading;
  final String? errorMessage;
  final List<String> trendingSpecialties;
  final List<DoctorProfile> doctorSuggestions;
  final String selectedTrending;
  final String location;
  final String query;

  PatientSearchState({
    this.isLoading = false,
    this.errorMessage,
    this.trendingSpecialties = const [],
    this.doctorSuggestions = const [],
    this.selectedTrending = '',
    this.location = 'Chhatrapati Sambhajinagar',
    this.query = '',
  });

  PatientSearchState copyWith({
    bool? isLoading,
    String? errorMessage,
    List<String>? trendingSpecialties,
    List<DoctorProfile>? doctorSuggestions,
    String? selectedTrending,
    String? location,
    String? query,
  }) {
    return PatientSearchState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
      trendingSpecialties: trendingSpecialties ?? this.trendingSpecialties,
      doctorSuggestions: doctorSuggestions ?? this.doctorSuggestions,
      selectedTrending: selectedTrending ?? this.selectedTrending,
      location: location ?? this.location,
      query: query ?? this.query,
    );
  }
}

class PatientSearchNotifier extends Notifier<PatientSearchState> {
  Timer? _hideTimer;

  @override
  PatientSearchState build() {
    // Register structural background listener cleanup callbacks on lifecycle end
    ref.onDispose(() {
      _hideTimer?.cancel();
    });

    Future.microtask(() => loadTrendingSpecialties());

    // Secure baseline initialization boundary cleanly without raising uninitialized lookup exceptions
    return PatientSearchState(isLoading: true);
  }

  void _resetHideTimer() {
    _hideTimer?.cancel();
    _hideTimer = Timer(const Duration(seconds: 7), () {
      state = state.copyWith(doctorSuggestions: const []);
    });
  }

  Future<void> loadTrendingSpecialties() async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      final List<String> results = await DummyData.getTrendingSpecialties();
      state = state.copyWith(
        trendingSpecialties: results,
        isLoading: false,
      );
    } catch (_) {
      state = state.copyWith(
        errorMessage: 'Unable to load specialties. Please try again.',
        isLoading: false,
      );
    }
  }

  // Evaluate query strings over mock collections reactively
  void updateQuery(String value) {
    if (value.isEmpty) {
      _hideTimer?.cancel();
      state = state.copyWith(query: value, doctorSuggestions: const []);
      return;
    }

    final input = value.toLowerCase();
    final suggestions = DummyData.allDoctors.where((doc) {
      return doc.name.toLowerCase().contains(input) ||
          doc.specialty.toLowerCase().contains(input) ||
          doc.hospital.toLowerCase().contains(input);
    }).toList();

    state = state.copyWith(query: value, doctorSuggestions: suggestions);

    if (suggestions.isNotEmpty) {
      _resetHideTimer();
    } else {
      _hideTimer?.cancel();
    }
  }

  void updateLocation(String value) {
    state = state.copyWith(location: value);
  }

  void selectTrending(String specialty) {
    _hideTimer?.cancel();
    state = state.copyWith(
      selectedTrending: specialty,
      query: specialty,
      doctorSuggestions: const [],
    );
  }

  void clearSuggestions() {
    _hideTimer?.cancel();
    state = state.copyWith(doctorSuggestions: const []);
  }
}

final patientSearchProvider = NotifierProvider.autoDispose<PatientSearchNotifier, PatientSearchState>(
  PatientSearchNotifier.new,
);