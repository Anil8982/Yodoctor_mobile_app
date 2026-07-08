import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/models/doctor/doctor_qr_model.dart';
import '../../../services/doctor_qr_service.dart';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';

class DoctorQrState {
  final bool loading;
  final DoctorQrModel? qr;

  const DoctorQrState({this.loading = false, this.qr});

  DoctorQrState copyWith({bool? loading, DoctorQrModel? qr}) {
    return DoctorQrState(loading: loading ?? this.loading, qr: qr ?? this.qr);
  }
}

class DoctorQrNotifier extends Notifier<DoctorQrState> {
  final _service = DoctorQrService();

  @override
  DoctorQrState build() {
    Future.microtask(loadQr);
    return const DoctorQrState();
  }

  Future<void> downloadQr() async {
    if (state.qr == null) return;

    final response = await _service.downloadQr(
      doctorName: state.qr!.doctorName,
      specialization: state.qr!.specialization,
      qrValue: state.qr!.qrUrl,
    );

    final dir = await getTemporaryDirectory();

    final file = File("${dir.path}/doctor_qr.pdf");

    await file.writeAsBytes(response.data);

    await OpenFilex.open(file.path);
  }

  Future<void> loadQr() async {
    try {
      state = state.copyWith(loading: true);

      final response = await _service.getMyQr();

      print("STATUS : ${response.statusCode}");
      print("BODY : ${response.data}");

      final qr = DoctorQrModel.fromJson(
        Map<String, dynamic>.from(response.data),
      );

      state = state.copyWith(loading: false, qr: qr);
    } catch (e, st) {
      print("QR ERROR => $e");
      print(st);

      state = state.copyWith(loading: false, qr: null);
    }
  }
}

final doctorQrProvider = NotifierProvider<DoctorQrNotifier, DoctorQrState>(
  DoctorQrNotifier.new,
);
