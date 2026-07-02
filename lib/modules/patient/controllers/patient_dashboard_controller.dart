import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/utils/dummy_data.dart';

// 🎯 Unified immutable state structure holding dashboard data payload and dynamic criteria keys
class PatientDashboardState {
  final PatientDashboardData? dashboardData;
  final String selectedFilter;

  PatientDashboardState({
    this.dashboardData,
    this.selectedFilter = 'All',
  });

  PatientDashboardState copyWith({
    PatientDashboardData? dashboardData,
    String? selectedFilter,
  }) {
    return PatientDashboardState(
      dashboardData: dashboardData ?? this.dashboardData,
      selectedFilter: selectedFilter ?? this.selectedFilter,
    );
  }
}

// 🎯 FIX: Extended manual AsyncNotifier base class to handle asynchronous state pipelines safely
class PatientDashboardNotifier extends AsyncNotifier<PatientDashboardState> {

  static const List<String> availableFilters = <String>[
    'All',
    'Today',
    'Next 7 Days',
  ];

  @override
  Future<PatientDashboardState> build() async {
    // Automatically triggers initial dashboard data query on build cycle setup
    final data = await DummyData.getDashboardData(filter: 'All');
    return PatientDashboardState(dashboardData: data, selectedFilter: 'All');
  }

  // Explicitly fetch or reload repository dashboard data items
  Future<void> loadDashboard({String? filter}) async {
    final currentFilter = filter ?? state.value?.selectedFilter ?? 'All';

    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final data = await DummyData.getDashboardData(filter: currentFilter);
      return PatientDashboardState(
        dashboardData: data,
        selectedFilter: currentFilter,
      );
    });
  }

  // Set active filter criteria and trigger background reload loop
  Future<void> setFilter(String filter) async {
    if (state.value?.selectedFilter == filter) return;
    await loadDashboard(filter: filter);
  }
}

// 🎯 Provider registration mapping clean manual notifier architecture setup
final patientDashboardProvider = AsyncNotifierProvider.autoDispose<PatientDashboardNotifier, PatientDashboardState>(
  PatientDashboardNotifier.new,
);