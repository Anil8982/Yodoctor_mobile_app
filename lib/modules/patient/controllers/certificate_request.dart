import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';
import 'package:yodoctor/core/constants/log_tags.dart';
import 'package:yodoctor/core/debug/app_logger.dart';
import 'package:yodoctor/core/routes/app_router.dart';
import 'package:yodoctor/core/routes/app_routes.dart';
import 'package:yodoctor/modules/payment/controllers/razorpay_controller.dart';
import 'package:yodoctor/modules/payment/providers.dart';
import '../../../modules/patient/models/certificate/patient_certificate_detail_model.dart';
import '../../../modules/patient/models/certificate/patient_certificate_request_model.dart';
import '../../../modules/patient/models/certificate/patient_certificate_timeline_model.dart';
import '../../patient/models/certificate/patient_doctor_model.dart';
import '../repositories/patient_certificate_repository.dart'
    show patientCertificateRepositoryProvider;

// 🎯 Immutable State Structure
class CertificateFormState {
  final List<PatientCertificateRequestModel> allCertificates;
  final bool isLoading;
  final bool isDoctorsLoading; // Added separate flag for doctors loading state
  final String selectedFilter;
  final String searchQuery;
  final String? selectedType;
  final PatientDoctorModel? assignedDoctor;
  final String? purpose;
  final DateTime? dateOfBirth;
  final String? gender;
  final String bloodGroup;
  final bool showValidationError;
  final Map<String, String?> uploadedDocs;
  final Map<String, double?> uploadProgress;
  final List<PatientDoctorModel> doctors;
  final PatientCertificateDetailModel? selectedCertificate;
  final List<PatientCertificateTimelineModel> timeline;

  CertificateFormState({
    this.allCertificates = const [],
    this.isLoading = false,
    this.isDoctorsLoading = false, // Initial state set to false or true depending on preference
    this.selectedFilter = 'All',
    this.searchQuery = '',
    this.selectedType,
    this.assignedDoctor,
    this.purpose,
    this.dateOfBirth,
    this.gender,
    this.bloodGroup = 'A+',
    this.showValidationError = false,
    this.selectedCertificate,
    this.doctors = const [],
    this.timeline = const [],
    this.uploadedDocs = const {
      'Profile Photo': null,
      'Government ID Proof': null,
      'Medical Reports': null,
      'Prescription': null,
    },
    this.uploadProgress = const {
      'Profile Photo': null,
      'Government ID Proof': null,
      'Medical Reports': null,
      'Prescription': null,
    },
  });

  CertificateFormState copyWith({
    List<PatientCertificateRequestModel>? allCertificates,
    bool? isLoading,
    bool? isDoctorsLoading,
    String? selectedFilter,
    String? searchQuery,
    String? selectedType,
    PatientDoctorModel? assignedDoctor,
    String? purpose,
    DateTime? dateOfBirth,
    String? gender,
    String? bloodGroup,
    bool? showValidationError,
    Map<String, String?>? uploadedDocs,
    Map<String, double?>? uploadProgress,
    PatientCertificateDetailModel? selectedCertificate,
    List<PatientDoctorModel>? doctors,
    List<PatientCertificateTimelineModel>? timeline,
  }) {
    return CertificateFormState(
      allCertificates: allCertificates ?? this.allCertificates,
      isLoading: isLoading ?? this.isLoading,
      isDoctorsLoading: isDoctorsLoading ?? this.isDoctorsLoading,
      selectedFilter: selectedFilter ?? this.selectedFilter,
      searchQuery: searchQuery ?? this.searchQuery,
      selectedType: selectedType ?? this.selectedType,
      assignedDoctor: assignedDoctor ?? this.assignedDoctor,
      purpose: purpose ?? this.purpose,
      doctors: doctors ?? this.doctors,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      gender: gender ?? this.gender,
      bloodGroup: bloodGroup ?? this.bloodGroup,
      showValidationError: showValidationError ?? this.showValidationError,
      uploadedDocs: uploadedDocs ?? this.uploadedDocs,
      uploadProgress: uploadProgress ?? this.uploadProgress,
      selectedCertificate: selectedCertificate ?? this.selectedCertificate,
      timeline: timeline ?? this.timeline,
    );
  }
}

final certificateProvider =
NotifierProvider<CertificateNotifier, CertificateFormState>(
  CertificateNotifier.new,
);

class CertificateNotifier extends Notifier<CertificateFormState> {
  final additionalNotesController = TextEditingController();
  final fullNameController = TextEditingController();
  final heightController = TextEditingController();
  final weightController = TextEditingController();
  final medicalConditionsController = TextEditingController();
  final medicationsController = TextEditingController();

  static const String _subTag = 'CertificateNotifier';

  @override
  CertificateFormState build() {
    ref.onDispose(() {
      additionalNotesController.dispose();
      fullNameController.dispose();
      heightController.dispose();
      weightController.dispose();
      medicalConditionsController.dispose();
      medicationsController.dispose();
    });
    return CertificateFormState();
  }

  Future<void> loadCertificateDetail(int id) async {
    state = state.copyWith(isLoading: true);
    try {
      final repo = ref.read(patientCertificateRepositoryProvider);
      final response = await repo.getRequestDetail(id);

      final detail = PatientCertificateDetailModel.fromJson(
        response.data["request"],
      );
      final timelineList = (response.data["timeline"] as List)
          .map((e) => PatientCertificateTimelineModel.fromJson(e))
          .toList();

      state = state.copyWith(
        selectedCertificate: detail,
        timeline: timelineList,
        isLoading: false,
      );
    } catch (e, st) {
      state = state.copyWith(isLoading: false);
      AppLogger.exception(
        e,
        st,
        message: 'Failed to load certificate detailed track matrix',
        tag: LogTags.patient,
        subTag: _subTag,
      );
    }
  }

  Future<void> loadDoctors() async {
    // Set explicit loading flag for doctors to prevent empty-state flashing
    state = state.copyWith(isDoctorsLoading: true);
    try {
      final repo = ref.read(patientCertificateRepositoryProvider);
      final response = await repo.getDoctors();

      if (response.statusCode == 200 && response.data["success"] == true) {
        final list = (response.data["doctors"] as List)
            .map((e) => PatientDoctorModel.fromJson(e))
            .toList();
        state = state.copyWith(doctors: list, isDoctorsLoading: false);
      } else {
        state = state.copyWith(isDoctorsLoading: false);
      }
    } catch (e, st) {
      state = state.copyWith(isDoctorsLoading: false);
      AppLogger.exception(
        e,
        st,
        message: 'Failed fetching secure repositories doctor list',
        tag: LogTags.patient,
        subTag: _subTag,
      );
    }
  }

  void selectDateOfBirth(DateTime? date) {
    state = state.copyWith(dateOfBirth: date);
  }

  Future<void> downloadCertificate(int id) async {
    try {
      final repo = ref.read(patientCertificateRepositoryProvider);
      final response = await repo.downloadCertificate(id);

      final directory = await getApplicationDocumentsDirectory();
      final file = File("${directory.path}/certificate_$id.pdf");

      await file.writeAsBytes(List<int>.from(response.data));
      await OpenFilex.open(file.path);
    } catch (e, st) {
      AppLogger.exception(
        e,
        st,
        message: 'PDF binary write system failure',
        tag: LogTags.patient,
        subTag: _subTag,
      );
    }
  }

  Future<void> loadMyRequests() async {
    state = state.copyWith(isLoading: true);
    try {
      final repo = ref.read(patientCertificateRepositoryProvider);
      final response = await repo.getMyRequests();

      final list = (response.data as List)
          .map((e) => PatientCertificateRequestModel.fromJson(e))
          .toList();

      state = state.copyWith(allCertificates: list, isLoading: false);
    } catch (e, st) {
      state = state.copyWith(isLoading: false);
      AppLogger.exception(
        e,
        st,
        message: 'Wallet requests sync engine faulted',
        tag: LogTags.patient,
        subTag: _subTag,
      );
    }
  }

  Future<bool> submitRequest() async {
    if (!validateDocuments() ||
        state.selectedType == null ||
        state.assignedDoctor == null) {
      AppLogger.warning(
        "Validation failed for certificate request submission",
        tag: LogTags.patient,
        subTag: _subTag,
      );
      return false;
    }

    state = state.copyWith(isLoading: true);

    final payload = {
      "doctor_id": state.assignedDoctor!.id,
      "certificate_type": state.selectedType,
      "purpose": state.purpose,
      "notes": additionalNotesController.text,
      "full_name": fullNameController.text,
      "dob": state.dateOfBirth == null
          ? null
          : '${state.dateOfBirth!.year}-'
          '${state.dateOfBirth!.month.toString().padLeft(2, '0')}-'
          '${state.dateOfBirth!.day.toString().padLeft(2, '0')}',
      "gender": state.gender,
      "blood_group": state.bloodGroup,
      "height": double.tryParse(heightController.text),
      "weight": double.tryParse(weightController.text),
      "medical_conditions": medicalConditionsController.text,
      "medications": medicationsController.text,
    };

    AppLogger.info(
      "Submitting certificate request and creating payment order",
      tag: LogTags.patient,
      subTag: _subTag,
    );
    AppLogger.json(payload, tag: LogTags.patient, subTag: _subTag);

    try {
      final repo = ref.read(patientCertificateRepositoryProvider);
      final orderResponse = await repo.createPaymentOrder(payload);

      final responseData = orderResponse.data is Map
          ? (orderResponse.data["data"] ?? orderResponse.data)
          : {};

      final String razorpayKeyId =
          responseData["razorpayKeyId"] ?? responseData["razorpay_key"] ?? '';
      final String orderId =
          responseData["orderId"] ?? responseData["order_id"] ?? '';
      final double totalAmount =
          double.tryParse(
            (responseData["totalAmount"] ?? responseData["amount"] ?? 0)
                .toString(),
          ) ??
              0.0;
      final String certificateType =
          responseData["certificateType"] ??
              state.selectedType ??
              'Certificate Payment';

      if (razorpayKeyId.isEmpty || orderId.isEmpty) {
        throw Exception(
          "Backend failed to return valid payment order identifiers.",
        );
      }

      final context = AppRouter.rootNavigatorKey.currentContext;
      if (context != null && context.mounted) {
        context.push(AppRoutes.paymentProcessing);
      }

      final razorpayController = ref.read(razorpayControllerProvider);

      final completer = Completer<bool>();
      late final StreamSubscription subscription;

      subscription = razorpayController.events.listen((event) async {
        if (event is RazorpaySuccess) {
          subscription.cancel();
          if (!completer.isCompleted) {
            try {
              AppLogger.info(
                "Payment successful. Verifying certificate payment...",
                tag: LogTags.patient,
                subTag: _subTag,
              );

              final verifyResponse = await repo.verifyPayment(
                razorpayOrderId: event.orderId ?? orderId,
                razorpayPaymentId: event.paymentId ?? '',
                razorpaySignature: event.signature ?? '',
              );

              final verifyData = verifyResponse.data is Map
                  ? (verifyResponse.data["data"] ?? verifyResponse.data)
                  : {};

              dynamic resId =
                  verifyData["requestId"] ?? verifyData["request_id"];
              if (resId == null && verifyResponse.data is Map) {
                resId = verifyResponse.data["requestId"];
              }

              if (resId == null) {
                throw Exception(
                  "Backend failed to return valid response hash map identifier for requestId after verification.",
                );
              }

              final int requestId = int.parse(resId.toString());
              AppLogger.success(
                "Payment verified. Starting document streams upload...",
                tag: LogTags.patient,
                subTag: _subTag,
              );

              await repo.uploadDocuments(
                requestId: requestId,
                profilePhoto: state.uploadedDocs["Profile Photo"],
                idProof: state.uploadedDocs["Government ID Proof"],
                medicalReports: state.uploadedDocs["Medical Reports"],
                prescription: state.uploadedDocs["Prescription"],
              );

              AppLogger.success(
                "Certificate workflows synchronization complete",
                tag: LogTags.patient,
                subTag: _subTag,
              );

              await loadMyRequests();
              resetForm();

              final navContext = AppRouter.rootNavigatorKey.currentContext;
              if (navContext != null && navContext.mounted) {
                navContext.go(
                  AppRoutes.paymentSuccess,
                  extra: {
                    'paymentId': event.paymentId,
                    'planName': certificateType,
                    'nextRoute': '/',
                  },
                );
              }

              completer.complete(true);
            } catch (e, st) {
              state = state.copyWith(isLoading: false);
              final navContext = AppRouter.rootNavigatorKey.currentContext;
              if (navContext != null && navContext.mounted) {
                if (navContext.canPop()) {
                  navContext.pop();
                }
              }
              AppLogger.exception(
                e,
                st,
                message:
                'Certificate payment verification or document upload faulted',
                tag: LogTags.patient,
                subTag: _subTag,
              );
              if (!completer.isCompleted) completer.complete(false);
            }
          }
        } else if (event is RazorpayFailure) {
          subscription.cancel();
          state = state.copyWith(isLoading: false);
          final navContext = AppRouter.rootNavigatorKey.currentContext;
          if (navContext != null && navContext.mounted) {
            if (navContext.canPop()) {
              navContext.pop();
            }
          }
          AppLogger.error(
            "Razorpay payment failed: ${event.message}",
            tag: LogTags.patient,
            subTag: _subTag,
          );
          if (!completer.isCompleted) completer.complete(false);
        } else if (event is RazorpayCancelled) {
          subscription.cancel();
          state = state.copyWith(isLoading: false);
          final navContext = AppRouter.rootNavigatorKey.currentContext;
          if (navContext != null && navContext.mounted) {
            if (navContext.canPop()) {
              navContext.pop();
            }
          }
          AppLogger.warning(
            "Razorpay payment cancelled by user",
            tag: LogTags.patient,
            subTag: _subTag,
          );
          if (!completer.isCompleted) completer.complete(false);
        } else if (event is RazorpayExternalWallet) {
          subscription.cancel();
          state = state.copyWith(isLoading: false);
          final navContext = AppRouter.rootNavigatorKey.currentContext;
          if (navContext != null && navContext.mounted) {
            if (navContext.canPop()) {
              navContext.pop();
            }
          }
          AppLogger.info(
            "Razorpay external wallet selected: ${event.walletName}",
            tag: LogTags.patient,
            subTag: _subTag,
          );
          if (!completer.isCompleted) completer.complete(false);
        }
      });

      razorpayController.openOrderCheckout(
        key: razorpayKeyId,
        orderId: orderId,
        amount: totalAmount,
        description: certificateType,
      );

      return await completer.future;
    } catch (e, st) {
      state = state.copyWith(isLoading: false);
      final navContext = AppRouter.rootNavigatorKey.currentContext;
      if (navContext != null && navContext.mounted) {
        if (navContext.canPop()) {
          navContext.pop();
        }
      }
      AppLogger.exception(
        e,
        st,
        message: 'Certificate creation workflow halted',
        tag: LogTags.patient,
        subTag: _subTag,
      );
      return false;
    }
  }

  // 🎯 Restored synchronization data computations
  List<PatientCertificateRequestModel> getFilteredCertificates() {
    return state.allCertificates.where((cert) {
      final matchesStatus =
          state.selectedFilter == "All" ||
              cert.status.toLowerCase() == state.selectedFilter.toLowerCase();

      final matchesSearch =
          state.searchQuery.isEmpty ||
              cert.certificateType.toLowerCase().contains(state.searchQuery) ||
              cert.doctorName.toLowerCase().contains(state.searchQuery);

      return matchesStatus && matchesSearch;
    }).toList();
  }

  // 🎯 Restored Form Actions
  void setFilter(String filter) =>
      state = state.copyWith(selectedFilter: filter);
  void setSearchQuery(String query) =>
      state = state.copyWith(searchQuery: query.toLowerCase());
  void setSelectedType(String type) =>
      state = state.copyWith(selectedType: type);
  void setAssignedDoctor(PatientDoctorModel doctor) =>
      state = state.copyWith(assignedDoctor: doctor);
  void setPurpose(String purpose) => state = state.copyWith(purpose: purpose);
  void setDateOfBirth(DateTime? date) =>
      state = state.copyWith(dateOfBirth: date);
  void setGender(String gender) => state = state.copyWith(gender: gender);
  void setBloodGroup(String bg) => state = state.copyWith(bloodGroup: bg);
  void clearValidationError() =>
      state = state.copyWith(showValidationError: false);

  // 🎯 Restored Mandatory Identity Document Validations
  bool validateDocuments() {
    if (state.uploadedDocs["Profile Photo"] == null ||
        state.uploadedDocs["Government ID Proof"] == null) {
      state = state.copyWith(showValidationError: true);
      return false;
    }
    state = state.copyWith(showValidationError: false);
    return true;
  }

  Future<void> uploadDocument(String key, String path) async {
    final docs = Map<String, String?>.from(state.uploadedDocs)..[key] = path;
    state = state.copyWith(uploadedDocs: docs);
  }

  void removeDocument(String documentKey) {
    final updatedDocs = Map<String, String?>.from(state.uploadedDocs)
      ..[documentKey] = null;
    final updatedProgress = Map<String, double?>.from(state.uploadProgress)
      ..[documentKey] = null;
    state = state.copyWith(
      uploadedDocs: updatedDocs,
      uploadProgress: updatedProgress,
    );
  }

  void resetForm() {
    additionalNotesController.clear();
    fullNameController.clear();
    heightController.clear();
    weightController.clear();
    medicalConditionsController.clear();
    medicationsController.clear();

    state = state.copyWith(
      selectedType: null,
      assignedDoctor: null,
      purpose: null,
      showValidationError: false,
      dateOfBirth: null,
      gender: null,
      bloodGroup: 'A+',
      uploadedDocs: {
        'Profile Photo': null,
        'Government ID Proof': null,
        'Medical Reports': null,
        'Prescription': null,
      },
      uploadProgress: {
        'Profile Photo': null,
        'Government ID Proof': null,
        'Medical Reports': null,
        'Prescription': null,
      },
    );
  }
}