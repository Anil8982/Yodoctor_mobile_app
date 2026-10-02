// lib/models/search/search_mode.dart
enum SearchMode {
  doctor,
  clinic,
}

extension SearchModeExtension on SearchMode {
  String get label {
    switch (this) {
      case SearchMode.doctor:
        return 'Doctor';
      case SearchMode.clinic:
        return 'Clinic';
    }
  }

  String get hintText {
    switch (this) {
      case SearchMode.doctor:
        return 'Search doctor by name...';
      case SearchMode.clinic:
        return 'Search clinic by name...';
    }
  }
}