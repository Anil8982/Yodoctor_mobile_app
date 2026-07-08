import 'package:flutter/foundation.dart';
import 'package:dio/dio.dart';

import '../../../services/patient_appointment_service.dart';
import '../models/appointment/book_appointment_request.dart';
import '../models/appointment/book_appointment_response.dart';

class BookAppointmentController extends ChangeNotifier {
  final PatientAppointmentService _service = PatientAppointmentService();

  bool isLoading = false;
  String? error;
  BookAppointmentResponse? response;

  Future<bool> book(BookAppointmentRequest request) async {
    try {
      isLoading = true;
      error = null;
      notifyListeners();

      print("REQUEST => ${request.toJson()}");

      final res = await _service.bookAppointment(request);

      print("STATUS => ${res.statusCode}");
      print("RESPONSE => ${res.data}");

      response = BookAppointmentResponse.fromJson(res.data["data"]);

      return true;
    } on DioException catch (e) {
      print("DIO ERROR => ${e.response?.data}");

      error = e.response?.data["message"] ?? "Booking Failed";
      return false;
    } catch (e, s) {
      print("ERROR => $e");
      print(s);

      error = e.toString();
      return false;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
