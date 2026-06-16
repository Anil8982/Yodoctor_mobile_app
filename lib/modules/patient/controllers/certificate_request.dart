import 'package:flutter/material.dart';
import 'package:yodoctor/core/models/medical_certificate.dart';
import '../../../core/utils/dummy_data.dart';

class CertificateController extends ChangeNotifier {
  CertificateController()
      : _certificates = List<MedicalCertificate>.from(DummyData.dummyCertificates);

  final List<MedicalCertificate> _certificates;
  bool _isLoading = false;

  String _selectedFilter = 'All';
  String _searchQuery = '';

  String? _selectedType;
  DoctorProfile? _assignedDoctor;
  String? _purpose;
  final TextEditingController additionalNotesController = TextEditingController();

  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController dobController = TextEditingController();
  String? _gender;
  String _bloodGroup = 'A+';
  final TextEditingController heightController = TextEditingController();
  final TextEditingController weightController = TextEditingController();
  final TextEditingController medicalConditionsController = TextEditingController();
  final TextEditingController medicationsController = TextEditingController();

  bool _showValidationError = false;

  final Map<String, String?> _uploadedDocs = {
    'Profile Photo': null,
    'Government ID Proof': null,
    'Medical Reports': null,
    'Prescription': null,
  };

  final Map<String, double?> _uploadProgress = {
    'Profile Photo': null,
    'Government ID Proof': null,
    'Medical Reports': null,
    'Prescription': null,
  };

  List<MedicalCertificate> get certificates {
    return _certificates.where((cert) {
      if (_selectedFilter != 'All' && cert.status.toUpperCase() != _selectedFilter.toUpperCase()) {
        return false;
      }
      if (_searchQuery.isNotEmpty) {
        final query = _searchQuery.toLowerCase();
        return cert.type.toLowerCase().contains(query) ||
            cert.doctor.name.toLowerCase().contains(query) ||
            cert.patientName.toLowerCase().contains(query);
      }
      return true;
    }).toList();
  }

  bool get isLoading => _isLoading;
  String get selectedFilter => _selectedFilter;
  String get searchQuery => _searchQuery;

  String? get selectedType => _selectedType;
  DoctorProfile? get assignedDoctor => _assignedDoctor;
  String? get purpose => _purpose;
  String? get gender => _gender;
  String get bloodGroup => _bloodGroup;
  bool get showValidationError => _showValidationError;

  String? getUploadedDoc(String documentKey) => _uploadedDocs[documentKey];
  double? getUploadProgress(String documentKey) => _uploadProgress[documentKey];

  void setFilter(String filter) {
    _selectedFilter = filter;
    notifyListeners();
  }

  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  void setSelectedType(String type) {
    _selectedType = type;
    notifyListeners();
  }

  void setAssignedDoctor(DoctorProfile doctor) {
    _assignedDoctor = doctor;
    notifyListeners();
  }

  void setPurpose(String purpose) {
    _purpose = purpose;
    notifyListeners();
  }

  void setGender(String gender) {
    _gender = gender;
    notifyListeners();
  }

  void setBloodGroup(String bg) {
    _bloodGroup = bg;
    notifyListeners();
  }

  void clearValidationError() {
    _showValidationError = false;
    notifyListeners();
  }

  bool validateDocuments() {
    if (_uploadedDocs['Profile Photo'] == null || _uploadedDocs['Government ID Proof'] == null) {
      _showValidationError = true;
      notifyListeners();
      return false;
    }
    _showValidationError = false;
    notifyListeners();
    return true;
  }

  Future<void> uploadDocument(String documentKey, String fileName) async {
    _uploadProgress[documentKey] = 0.0;
    notifyListeners();

    for (int i = 1; i <= 5; i++) {
      await Future<void>.delayed(const Duration(milliseconds: 150));
      _uploadProgress[documentKey] = i * 0.2;
      notifyListeners();
    }

    _uploadedDocs[documentKey] = fileName;
    _uploadProgress[documentKey] = null;
    notifyListeners();
  }

  void removeDocument(String documentKey) {
    _uploadedDocs[documentKey] = null;
    _uploadProgress[documentKey] = null;
    notifyListeners();
  }

  void initFormWithDefaults(PatientUser user) {
    resetForm();
    fullNameController.text = user.name;
    dobController.text = user.dateOfBirth;
    _gender = user.gender;
    _bloodGroup = user.bloodGroup;
  }

  void resetForm() {
    _selectedType = null;
    _assignedDoctor = null;
    _purpose = null;
    _showValidationError = false;
    additionalNotesController.clear();

    fullNameController.clear();
    dobController.clear();
    _gender = null;
    _bloodGroup = 'A+';
    heightController.clear();
    weightController.clear();
    medicalConditionsController.clear();
    medicationsController.clear();

    _uploadedDocs.updateAll((key, value) => null);
    _uploadProgress.updateAll((key, value) => null);
  }

  Future<bool> submitRequest() async {
    if (!validateDocuments()) {
      return false;
    }

    if (_selectedType == null || _assignedDoctor == null || fullNameController.text.isEmpty) {
      return false;
    }

    _isLoading = true;
    notifyListeners();

    await Future<void>.delayed(const Duration(milliseconds: 1000));

    final docList = _uploadedDocs.values.whereType<String>().toList();

    final newCert = MedicalCertificate(
      id: 'CERT-${_certificates.length + 1}',
      type: _selectedType!,
      patientName: fullNameController.text,
      dateOfBirth: dobController.text.isNotEmpty ? dobController.text : 'N/A',
      gender: _gender ?? 'N/A',
      bloodGroup: _bloodGroup,
      heightCm: double.tryParse(heightController.text) ?? 170.0,
      weightKg: double.tryParse(weightController.text) ?? 65.0,
      medicalConditions: medicalConditionsController.text.isNotEmpty ? medicalConditionsController.text : 'None',
      medications: medicationsController.text.isNotEmpty ? medicationsController.text : 'None',
      doctor: _assignedDoctor!,
      purpose: _purpose ?? 'Other',
      additionalNotes: additionalNotesController.text,
      status: 'PENDING',
      requestDate: DateTime.now(),
      documents: docList,
    );

    _certificates.insert(0, newCert);
    _isLoading = false;
    resetForm();
    notifyListeners();

    return true;
  }

  @override
  void dispose() {
    additionalNotesController.dispose();
    fullNameController.dispose();
    dobController.dispose();
    heightController.dispose();
    weightController.dispose();
    medicalConditionsController.dispose();
    medicationsController.dispose();
    super.dispose();
  }
}