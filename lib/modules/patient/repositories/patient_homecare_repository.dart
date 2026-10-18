import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yodoctor/core/constants/api_constants.dart';
import 'package:yodoctor/core/network/dio_provider.dart';
import 'package:yodoctor/modules/patient/models/home_care/home_service_booking_model.dart';

final patientHomeCareRepositoryProvider = Provider<PatientHomeCareRepository>((ref) {
  return PatientHomeCareRepository(ref.read(dioProvider));
});

class PatientHomeCareRepository {
  PatientHomeCareRepository(this._dio);

  final Dio _dio;

  /// Book Home Care
  /// POST /patient/bookhomecare
  Future<Response> createBooking(HomeServiceBookingModel booking) {
    return _dio.post(
      ApiConstants.bookHomeCare,
      data: booking.toJson(),
    );
  }

  /// Get Home Care History
  /// GET /patient/homecarehistory
  Future<Response> getBookings() {
    return _dio.get(
      ApiConstants.getHomeCareHistory,
    );
  }

  /// Get Home Care Booking Details
  /// GET /patient/homecarehistory/:id
  Future<Response> getBookingDetails(int bookingId) {
    return _dio.get(
      ApiConstants.getHomeCareBookingDetails(bookingId),
    );
  }

  /// Cancel Home Care Booking
  /// PUT /patient/homecarehistory/:id/cancel
  Future<Response> cancelBooking(int bookingId) {
    return _dio.put(
      ApiConstants.cancelHomeCareBooking(bookingId),
    );
  }
}