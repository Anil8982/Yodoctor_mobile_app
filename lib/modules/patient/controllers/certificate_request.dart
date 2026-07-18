import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';
import 'package:yodoctor/core/debug/app_logger.dart';
import '../../../modules/patient/models/certificate/patient_certificate_request_model.dart';
import '../../../modules/patient/models/certificate/patient_certificate_detail_model.dart';
import '../../../modules/patient/models/certificate/patient_certificate_timeline_model.dart';
import '../../patient/models/certificate/patient_doctor_model.dart';
import '../../../core/constants/log_tags.dart';
import '../repositories/patient_certificate_repository.dart' show patientCertificateRepositoryProvider;
import 'dart:io';
import 'package:open_filex/open_filex.dart';

// 🎯 Immutable State Structure remains identical
class CertificateFormState {
  final List<PatientCertificateRequestModel> allCertificates;
  final bool isLoading;
  final String selectedFilter;
  final String searchQuery;
  final String? selectedType;
  final PatientDoctorModel? assignedDoctor;
  final String? purpose;
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
    this.selectedFilter = 'All',
    this.searchQuery = '',
    this.selectedType,
    this.assignedDoctor,
    this.purpose,
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
    String? selectedFilter,
    String? searchQuery,
    String? selectedType,
    PatientDoctorModel? assignedDoctor,
    String? purpose,
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
      selectedFilter: selectedFilter ?? this.selectedFilter,
      searchQuery: searchQuery ?? this.searchQuery,
      selectedType: selectedType ?? this.selectedType,
      assignedDoctor: assignedDoctor ?? this.assignedDoctor,
      purpose: purpose ?? this.purpose,
      doctors: doctors ?? this.doctors,
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

class CertificateNotifier extends Notifier<CertificateFormState> {
  final additionalNotesController = TextEditingController();
  final fullNameController = TextEditingController();
  final dobController = TextEditingController();
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
      dobController.dispose();
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

      final detail = PatientCertificateDetailModel.fromJson(response.data["request"]);
      final timelineList = (response.data["timeline"] as List)
          .map((e) => PatientCertificateTimelineModel.fromJson(e))
          .toList();

      state = state.copyWith(selectedCertificate: detail, timeline: timelineList, isLoading: false);
    } catch (e, st) {
      state = state.copyWith(isLoading: false);
      AppLogger.exception(e, st, message: 'Failed to load certificate detailed track matrix', tag: LogTags.patient, subTag: _subTag);
    }
  }

  Future<void> loadDoctors() async {
    try {
      final repo = ref.read(patientCertificateRepositoryProvider);
      final response = await repo.getDoctors();

      if (response.statusCode == 200 && response.data["success"] == true) {
        final list = (response.data["doctors"] as List)
            .map((e) => PatientDoctorModel.fromJson(e))
            .toList();
        state = state.copyWith(doctors: list);
      }
    } catch (e, st) {
      AppLogger.exception(e, st, message: 'Failed fetching secure repositories doctor list', tag: LogTags.patient, subTag: _subTag);
    }
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
      AppLogger.exception(e, st, message: 'PDF binary write system failure', tag: LogTags.patient, subTag: _subTag);
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
      AppLogger.exception(e, st, message: 'Wallet requests sync engine faulted', tag: LogTags.patient, subTag: _subTag);
    }
  }

  Future<bool> submitRequest() async {
    if (!validateDocuments() || state.selectedType == null || state.assignedDoctor == null) {
      AppLogger.warning("Validation failed for certificate request submission", tag: LogTags.patient, subTag: _subTag);
      return false;
    }

    state = state.copyWith(isLoading: true);

    final payload = {
      "doctor_id": state.assignedDoctor!.id,
      "certificate_type": state.selectedType,
      "purpose": state.purpose,
      "notes": additionalNotesController.text,
      "full_name": fullNameController.text,
      "dob": dobController.text,
      "gender": state.gender,
      "blood_group": state.bloodGroup,
      "height": double.tryParse(heightController.text),
      "weight": double.tryParse(weightController.text),
      "medical_conditions": medicalConditionsController.text,
      "medications": medicationsController.text,
    };

    AppLogger.info("Submitting certificate request", tag: LogTags.patient, subTag: _subTag);
    AppLogger.json(payload, tag: LogTags.patient, subTag: "$_subTag/Payload");

    try {
      final repo = ref.read(patientCertificateRepositoryProvider);
      final create = await repo.createRequest(payload);

      dynamic resId;
      if (create.data is Map) {
        if (create.data["data"] != null && create.data["data"]["requestId"] != null) {
          resId = create.data["data"]["requestId"];
        } else {
          resId = create.data["requestId"];
        }
      }

      if (resId == null) {
        throw Exception("Backend failed to return valid response hash map identifier for requestId.");
      }

      final int requestId = int.parse(resId.toString());
      AppLogger.success("Request created. Starting document streams upload...", tag: LogTags.patient, subTag: _subTag);

      await repo.uploadDocuments(
        requestId: requestId,
        profilePhoto: state.uploadedDocs["Profile Photo"],
        idProof: state.uploadedDocs["Government ID Proof"],
        medicalReports: state.uploadedDocs["Medical Reports"],
        prescription: state.uploadedDocs["Prescription"],
      );

      AppLogger.success("Certificate workflows synchronization complete", tag: LogTags.patient, subTag: _subTag);

      await loadMyRequests();
      resetForm();
      return true;
    } catch (e, st) {
      state = state.copyWith(isLoading: false);
      AppLogger.exception(e, st, message: 'Certificate creation workflow halted', tag: LogTags.patient, subTag: _subTag);
      return false;
    }
  }

  // 🎯 Restored synchronization data computations
  List<PatientCertificateRequestModel> getFilteredCertificates() {
    return state.allCertificates.where((cert) {
      final matchesStatus = state.selectedFilter == "All" ||
          cert.status.toLowerCase() == state.selectedFilter.toLowerCase();

      final matchesSearch = state.searchQuery.isEmpty ||
          cert.certificateType.toLowerCase().contains(state.searchQuery) ||
          cert.doctorName.toLowerCase().contains(state.searchQuery);

      return matchesStatus && matchesSearch;
    }).toList();
  }

  // 🎯 Restored Form Actions
  void setFilter(String filter) => state = state.copyWith(selectedFilter: filter);
  void setSearchQuery(String query) => state = state.copyWith(searchQuery: query.toLowerCase());
  void setSelectedType(String type) => state = state.copyWith(selectedType: type);
  void setAssignedDoctor(PatientDoctorModel doctor) => state = state.copyWith(assignedDoctor: doctor);
  void setPurpose(String purpose) => state = state.copyWith(purpose: purpose);
  void setGender(String gender) => state = state.copyWith(gender: gender);
  void setBloodGroup(String bg) => state = state.copyWith(bloodGroup: bg);
  void clearValidationError() => state = state.copyWith(showValidationError: false);

  // 🎯 Restored Mandatory Identity Document Validations
  bool validateDocuments() {
    if (state.uploadedDocs["Profile Photo"] == null || state.uploadedDocs["Government ID Proof"] == null) {
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
    final updatedDocs = Map<String, String?>.from(state.uploadedDocs)..[documentKey] = null;
    final updatedProgress = Map<String, double?>.from(state.uploadProgress)..[documentKey] = null;
    state = state.copyWith(uploadedDocs: updatedDocs, uploadProgress: updatedProgress);
  }

  void resetForm() {
    additionalNotesController.clear();
    fullNameController.clear();
    dobController.clear();
    heightController.clear();
    weightController.clear();
    medicalConditionsController.clear();
    medicationsController.clear();

    state = state.copyWith(
      selectedType: null,
      assignedDoctor: null,
      purpose: null,
      showValidationError: false,
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

final certificateProvider = NotifierProvider<CertificateNotifier, CertificateFormState>(CertificateNotifier.new);