import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../services/patient_certificate_service.dart';
import '../../../core/models/patient/doctor_profile.dart';
import '../../../modules/patient/models/certificate/patient_certificate_request_model.dart';
import '../../../modules/patient/models/certificate/patient_certificate_detail_model.dart';
import '../../../modules/patient/models/certificate/patient_certificate_timeline_model.dart';
import '../../../core/models/doctor/doctor_profile_model.dart';
import 'dart:io';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';

// 🎯 Immutable state structure for tracking certificates data and dynamic form fields
class CertificateFormState {
  final List<PatientCertificateRequestModel> allCertificates;
  final bool isLoading;
  final String selectedFilter;
  final String searchQuery;
  final String? selectedType;
  final DoctorProfileModel? assignedDoctor;
  final String? purpose;
  final String? gender;
  final String bloodGroup;
  final bool showValidationError;
  final Map<String, String?> uploadedDocs;
  final Map<String, double?> uploadProgress;
  final List<DoctorProfileModel> doctors;
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
    DoctorProfileModel? assignedDoctor,
    String? purpose,
    String? gender,
    String? bloodGroup,
    bool? showValidationError,
    Map<String, String?>? uploadedDocs,
    Map<String, double?>? uploadProgress,
    PatientCertificateDetailModel? selectedCertificate,
    List<DoctorProfileModel>? doctors,
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

// 🎯 Manual Riverpod Notifier implementation managing certificate workflow
class CertificateNotifier extends Notifier<CertificateFormState> {
  // Permanent text editing controllers
  final additionalNotesController = TextEditingController();
  final fullNameController = TextEditingController();
  final dobController = TextEditingController();
  final heightController = TextEditingController();
  final weightController = TextEditingController();
  final medicalConditionsController = TextEditingController();
  final medicationsController = TextEditingController();
  final PatientCertificateService _service = PatientCertificateService();
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

    Future.microtask(() async {
      await loadDoctors();
      await loadMyRequests();
    });

    return CertificateFormState();
  }

  Future<void> loadCertificateDetail(int id) async {
    state = state.copyWith(isLoading: true);

    try {
      final response = await _service.getRequestDetail(id);

      final detail = PatientCertificateDetailModel.fromJson(
        response.data["request"],
      );

      final timeline = (response.data["timeline"] as List)
          .map((e) => PatientCertificateTimelineModel.fromJson(e))
          .toList();

      state = state.copyWith(
        selectedCertificate: detail,
        timeline: timeline,
        isLoading: false,
      );
    } catch (e) {
      debugPrint(e.toString());

      state = state.copyWith(isLoading: false);
    }
  }

  Future<void> loadDoctors() async {
    try {
      final response = await _service.getDoctors();

      debugPrint(response.data.toString());

      final list = (response.data["doctors"] as List)
          .map((e) => DoctorProfileModel.fromJson(e))
          .toList();

      debugPrint("Doctors = ${list.length}");

      state = state.copyWith(doctors: list);
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<void> downloadCertificate(int id) async {
    try {
      final response = await _service.downloadCertificate(id);

      final directory = await getApplicationDocumentsDirectory();

      final file = File("${directory.path}/certificate_$id.pdf");

      await file.writeAsBytes(List<int>.from(response.data));

      await OpenFilex.open(file.path);
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<void> loadMyRequests() async {
    state = state.copyWith(isLoading: true);

    try {
      final response = await _service.getMyRequests();

      final list = (response.data as List)
          .map((e) => PatientCertificateRequestModel.fromJson(e))
          .toList();

      state = state.copyWith(allCertificates: list, isLoading: false);
    } catch (e) {
      debugPrint(e.toString());

      state = state.copyWith(isLoading: false);
    }
  }

  // Pure data computation matching sync querying profiles
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

  void setFilter(String filter) =>
      state = state.copyWith(selectedFilter: filter);
  void setSearchQuery(String query) =>
      state = state.copyWith(searchQuery: query);
  void setSelectedType(String type) =>
      state = state.copyWith(selectedType: type);
  void setAssignedDoctor(DoctorProfileModel doctor) {
    state = state.copyWith(assignedDoctor: doctor);
  }

  void setPurpose(String purpose) => state = state.copyWith(purpose: purpose);
  void setGender(String gender) => state = state.copyWith(gender: gender);
  void setBloodGroup(String bg) => state = state.copyWith(bloodGroup: bg);
  void clearValidationError() =>
      state = state.copyWith(showValidationError: false);

  bool validateDocuments() {
    if (state.uploadedDocs["Profile Photo"] == null) {
      state = state.copyWith(showValidationError: true);

      return false;
    }

    if (state.uploadedDocs["Government ID Proof"] == null) {
      state = state.copyWith(showValidationError: true);

      return false;
    }

    state = state.copyWith(showValidationError: false);

    return true;
  }

  // Emulate structural background asynchronous upload progress updates
  Future<void> uploadDocument(String key, String path) async {
    final docs = Map<String, String?>.from(state.uploadedDocs);

    docs[key] = path;

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

  // Handle transaction submission pipeline
  Future<bool> submitRequest() async {
    if (!validateDocuments()) {
      return false;
    }

    if (state.selectedType == null || state.assignedDoctor == null) {
      return false;
    }

    state = state.copyWith(isLoading: true);

    try {
      final create = await _service.createRequest({
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
      });

      final requestId = create.data["requestId"];

      await _service.uploadDocuments(
        requestId: requestId,

        profilePhoto: state.uploadedDocs["Profile Photo"],

        idProof: state.uploadedDocs["Government ID Proof"],

        medicalReports: state.uploadedDocs["Medical Reports"],

        prescription: state.uploadedDocs["Prescription"],
      );

      await loadMyRequests();

      resetForm();

      state = state.copyWith(isLoading: false);

      return true;
    } catch (e) {
      debugPrint(e.toString());

      state = state.copyWith(isLoading: false);

      return false;
    }
  }
}

// 🎯 Provider declaration mapped with an autoDispose tag setup
final certificateProvider =
    NotifierProvider.autoDispose<CertificateNotifier, CertificateFormState>(
      CertificateNotifier.new,
    );
