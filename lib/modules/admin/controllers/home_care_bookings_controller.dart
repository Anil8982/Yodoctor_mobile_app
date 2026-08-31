import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yodoctor/core/models/admin/home_care_booking_model.dart';
import 'package:yodoctor/core/utils/dummy_data.dart';

class HomeCareBookingsState {
  final List<HomeCareBookingModel> allBookings;
  final List<HomeCareBookingModel> filteredBookings;
  final String searchQuery;
  final Set<int> deletedIds;

  HomeCareBookingsState({
    required this.allBookings,
    required this.filteredBookings,
    required this.searchQuery,
    required this.deletedIds,
  });

  HomeCareBookingsState copyWith({
    List<HomeCareBookingModel>? allBookings,
    List<HomeCareBookingModel>? filteredBookings,
    String? searchQuery,
    Set<int>? deletedIds,
  }) {
    return HomeCareBookingsState(
      allBookings: allBookings ?? this.allBookings,
      filteredBookings: filteredBookings ?? this.filteredBookings,
      searchQuery: searchQuery ?? this.searchQuery,
      deletedIds: deletedIds ?? this.deletedIds,
    );
  }
}

class HomeCareBookingsNotifier extends AsyncNotifier<HomeCareBookingsState> {
  @override
  Future<HomeCareBookingsState> build() async {
    final rawList = await DummyData.getHomeCareBookings();

    return HomeCareBookingsState(
      allBookings: rawList,
      filteredBookings: rawList,
      searchQuery: '',
      deletedIds: {},
    );
  }

  void searchBookings(String query) {
    final previousState = state;
    if (!previousState.hasValue) return;

    final current = previousState.value!;
    final search = query.trim().toLowerCase();

    final filtered = current.allBookings.where((booking) {
      return booking.patientName.toLowerCase().contains(search) ||
          booking.service.toLowerCase().contains(search);
    }).toList();

    state = AsyncValue.data(current.copyWith(
      searchQuery: query,
      filteredBookings: filtered,
    ));
  }

  void deleteBooking(int id) {
    final previousState = state;
    if (!previousState.hasValue) return;

    final current = previousState.value!;
    final updatedDeletedIds = Set<int>.from(current.deletedIds)..add(id);
    final updatedAll = current.allBookings.where((b) => b.id != id).toList();

    final search = current.searchQuery.toLowerCase();
    final updatedFiltered = updatedAll.where((booking) {
      return booking.patientName.toLowerCase().contains(search) ||
          booking.service.toLowerCase().contains(search);
    }).toList();

    state = AsyncValue.data(current.copyWith(
      allBookings: updatedAll,
      filteredBookings: updatedFiltered,
      deletedIds: updatedDeletedIds,
    ));
  }

  Future<void> refreshBookings() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final rawList = await DummyData.refreshHomeCareBookings();
      return HomeCareBookingsState(
        allBookings: rawList,
        filteredBookings: rawList,
        searchQuery: '',
        deletedIds: {},
      );
    });
  }
}

final homeCareBookingsProvider = AsyncNotifierProvider.autoDispose<HomeCareBookingsNotifier, HomeCareBookingsState>(
  HomeCareBookingsNotifier.new,
);