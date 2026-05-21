import 'package:flutter/material.dart';
import '../../../core/utils/dummy_data.dart';

class CertificateController extends ChangeNotifier {
  CertificateController()
      : _certificates = List<MedicalCertificate>.from(DummyData.dummyCertificates);

  final List<MedicalCertificate> _certificates;
  bool _isLoading = false;

  // Search & Filter state
  String _selectedFilter = 'All';
  String _searchQuery = '';

  // Form Wizard State (Apply Certificate Flow)
  String? _selectedType;
  DoctorProfile? _assignedDoctor;
  String? _purpose;
  final TextEditingController additionalNotesController = TextEditingController();

  // Personal Info
  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController dobController = TextEditingController();
  String? _gender;
  String _bloodGroup = 'A+';
  final TextEditingController heightController = TextEditingController();
  final TextEditingController weightController = TextEditingController();
  final TextEditingController medicalConditionsController = TextEditingController();
  final TextEditingController medicationsController = TextEditingController();

  // Document Upload Mock State (Stores uploaded file name or null)
  final Map<String, String?> _uploadedDocs = {
    'Profile Photo': null,
    'Government ID Proof': null,
    'Medical Reports': null,
    'Prescription': null,
  };

  // Uploading progress indicators (stores mock uploading progress 0.0 to 1.0 or null)
  final Map<String, double?> _uploadProgress = {
    'Profile Photo': null,
    'Government ID Proof': null,
    'Medical Reports': null,
    'Prescription': null,
  };

  // Getters
  List<MedicalCertificate> get certificates {
    return _certificates.where((cert) {
      // Apply status filter
      if (_selectedFilter != 'All' && cert.status.toUpperCase() != _selectedFilter.toUpperCase()) {
        return false;
      }
      // Apply search query filter
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

  // Wizard Getters
  String? get selectedType => _selectedType;
  DoctorProfile? get assignedDoctor => _assignedDoctor;
  String? get purpose => _purpose;
  String? get gender => _gender;
  String get bloodGroup => _bloodGroup;

  String? getUploadedDoc(String documentKey) => _uploadedDocs[documentKey];
  double? getUploadProgress(String documentKey) => _uploadProgress[documentKey];

  // Setters & Actions
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

  // Mock upload document with simulation timer
  Future<void> uploadDocument(String documentKey, String fileName) async {
    _uploadProgress[documentKey] = 0.0;
    notifyListeners();

    // Simulate upload progress steps
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

  // Pre-fill fields with user data when launching wizard
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

  // Submit flow
  Future<bool> submitRequest() async {
    if (_selectedType == null || _assignedDoctor == null || fullNameController.text.isEmpty) {
      return false;
    }

    _isLoading = true;
    notifyListeners();

    // Simulate server submission delay
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
