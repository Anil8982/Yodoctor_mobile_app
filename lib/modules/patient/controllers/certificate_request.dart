import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yodoctor/core/models/medical_certificate.dart';
import '../../../core/utils/dummy_data.dart';

// 🎯 Immutable state structure for tracking certificates data and dynamic form fields
class CertificateFormState {
  final List<MedicalCertificate> allCertificates;
  final bool isLoading;
  final String selectedFilter;
  final String searchQuery;
  final String? selectedType;
  final DoctorProfile? assignedDoctor;
  final String? purpose;
  final String? gender;
  final String bloodGroup;
  final bool showValidationError;
  final Map<String, String?> uploadedDocs;
  final Map<String, double?> uploadProgress;

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
    List<MedicalCertificate>? allCertificates,
    bool? isLoading,
    String? selectedFilter,
    String? searchQuery,
    String? selectedType,
    DoctorProfile? assignedDoctor,
    String? purpose,
    String? gender,
    String? bloodGroup,
    bool? showValidationError,
    Map<String, String?>? uploadedDocs,
    Map<String, double?>? uploadProgress,
  }) {
    return CertificateFormState(
      allCertificates: allCertificates ?? this.allCertificates,
      isLoading: isLoading ?? this.isLoading,
      selectedFilter: selectedFilter ?? this.selectedFilter,
      searchQuery: searchQuery ?? this.searchQuery,
      selectedType: selectedType ?? this.selectedType,
      assignedDoctor: assignedDoctor ?? this.assignedDoctor,
      purpose: purpose ?? this.purpose,
      gender: gender ?? this.gender,
      bloodGroup: bloodGroup ?? this.bloodGroup,
      showValidationError: showValidationError ?? this.showValidationError,
      uploadedDocs: uploadedDocs ?? this.uploadedDocs,
      uploadProgress: uploadProgress ?? this.uploadProgress,
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

  @override
  CertificateFormState build() {
    // Hook up automated lifecycle cleanup loop to clear memory leaks
    ref.onDispose(() {
      additionalNotesController.dispose();
      fullNameController.dispose();
      dobController.dispose();
      heightController.dispose();
      weightController.dispose();
      medicalConditionsController.dispose();
      medicationsController.dispose();
    });

    return CertificateFormState(
      allCertificates: List<MedicalCertificate>.from(DummyData.dummyCertificates),
    );
  }

  // Pure data computation matching sync querying profiles
  List<MedicalCertificate> getFilteredCertificates() {
    final current = state;
    return current.allCertificates.where((cert) {
      if (current.selectedFilter != 'All' && cert.status.toUpperCase() != current.selectedFilter.toUpperCase()) {
        return false;
      }
      if (current.searchQuery.isNotEmpty) {
        final query = current.searchQuery.toLowerCase();
        return cert.type.toLowerCase().contains(query) ||
            cert.doctor.name.toLowerCase().contains(query) ||
            cert.patientName.toLowerCase().contains(query);
      }
      return true;
    }).toList();
  }

  void setFilter(String filter) => state = state.copyWith(selectedFilter: filter);
  void setSearchQuery(String query) => state = state.copyWith(searchQuery: query);
  void setSelectedType(String type) => state = state.copyWith(selectedType: type);
  void setAssignedDoctor(DoctorProfile doctor) => state = state.copyWith(assignedDoctor: doctor);
  void setPurpose(String purpose) => state = state.copyWith(purpose: purpose);
  void setGender(String gender) => state = state.copyWith(gender: gender);
  void setBloodGroup(String bg) => state = state.copyWith(bloodGroup: bg);
  void clearValidationError() => state = state.copyWith(showValidationError: false);

  bool validateDocuments() {
    if (state.uploadedDocs['Profile Photo'] == null || state.uploadedDocs['Government ID Proof'] == null) {
      state = state.copyWith(showValidationError: true);
      return false;
    }
    state = state.copyWith(showValidationError: false);
    return true;
  }

  // Emulate structural background asynchronous upload progress updates
  Future<void> uploadDocument(String documentKey, String fileName) async {
    final currentProgress = Map<String, double?>.from(state.uploadProgress);
    currentProgress[documentKey] = 0.0;
    state = state.copyWith(uploadProgress: currentProgress);

    for (int i = 1; i <= 5; i++) {
      await Future<void>.delayed(const Duration(milliseconds: 150));
      final chunkProgress = Map<String, double?>.from(state.uploadProgress);
      chunkProgress[documentKey] = i * 0.2;
      state = state.copyWith(uploadProgress: chunkProgress);
    }

    final finalDocs = Map<String, String?>.from(state.uploadedDocs)..[documentKey] = fileName;
    final finalProgress = Map<String, double?>.from(state.uploadProgress)..[documentKey] = null;
    state = state.copyWith(uploadedDocs: finalDocs, uploadProgress: finalProgress);
  }

  void removeDocument(String documentKey) {
    final updatedDocs = Map<String, String?>.from(state.uploadedDocs)..[documentKey] = null;
    final updatedProgress = Map<String, double?>.from(state.uploadProgress)..[documentKey] = null;
    state = state.copyWith(uploadedDocs: updatedDocs, uploadProgress: updatedProgress);
  }

  void initFormWithDefaults(PatientUser user) {
    resetForm();
    fullNameController.text = user.name;
    dobController.text = user.dateOfBirth;
    state = state.copyWith(gender: user.gender, bloodGroup: user.bloodGroup);
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
    if (!validateDocuments()) return false;
    if (state.selectedType == null || state.assignedDoctor == null || fullNameController.text.isEmpty) {
      return false;
    }

    state = state.copyWith(isLoading: true);
    await Future<void>.delayed(const Duration(milliseconds: 1000));

    final docList = state.uploadedDocs.values.whereType<String>().toList();

    final newCert = MedicalCertificate(
      id: 'CERT-${state.allCertificates.length + 1}',
      type: state.selectedType!,
      patientName: fullNameController.text,
      dateOfBirth: dobController.text.isNotEmpty ? dobController.text : 'N/A',
      gender: state.gender ?? 'N/A',
      bloodGroup: state.bloodGroup,
      heightCm: double.tryParse(heightController.text) ?? 170.0,
      weightKg: double.tryParse(weightController.text) ?? 65.0,
      medicalConditions: medicalConditionsController.text.isNotEmpty ? medicalConditionsController.text : 'None',
      medications: medicationsController.text.isNotEmpty ? medicationsController.text : 'None',
      doctor: state.assignedDoctor!,
      purpose: state.purpose ?? 'Other',
      additionalNotes: additionalNotesController.text,
      status: 'PENDING',
      requestDate: DateTime.now(),
      documents: docList,
    );

    final updatedList = List<MedicalCertificate>.from(state.allCertificates)..insert(0, newCert);

    // Clear state data variables cleanly on successful request transaction completion
    state = state.copyWith(
      allCertificates: updatedList,
      isLoading: false,
    );
    resetForm();

    return true;
  }
}

// 🎯 Provider declaration mapped with an autoDispose tag setup
final certificateProvider = NotifierProvider.autoDispose<CertificateNotifier, CertificateFormState>(
  CertificateNotifier.new,
);