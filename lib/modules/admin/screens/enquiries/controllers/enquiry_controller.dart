import 'package:flutter/foundation.dart';
import 'package:yodoctor/core/utils/dummy_data.dart';
import 'package:yodoctor/modules/admin/screens/enquiries/models/enquiry_model.dart';

class EnquiryController extends ChangeNotifier {
  bool _isLoading = false;
  String? _errorMessage;
  List<EnquiryModel> _enquiries = [];
  final Set<int> _deletedIds = {};

  int? _expandedIndex;

  bool get isLoading => _isLoading;

  String? get errorMessage => _errorMessage;

  List<EnquiryModel> get enquiries => _enquiries;
  

  bool isCardExpanded(int index) {
    return _expandedIndex == index;
  }

  void toggleExpansion(int index) {
    if (_expandedIndex == index) {
      _expandedIndex = null;
    } else {
      _expandedIndex = index;
    }

    notifyListeners();
  }

  EnquiryController() {
    loadEnquiries();
  }
Future<void> _fetchEnquiries() async {
  final data = await DummyData.getEnquiries();

  _enquiries = data
      .where((item) => !_deletedIds.contains(item.id))
      .toList();
}
  Future<void> loadEnquiries() async {
  _isLoading = true;
  _errorMessage = null;
  notifyListeners();

  try {
    await _fetchEnquiries();
  } catch (_) {
    _errorMessage = 'Unable to load enquiries.';
  } finally {
    _isLoading = false;
    notifyListeners();
  }
}

  Future<void> refreshEnquiries() async {
  try {
    await _fetchEnquiries();
    notifyListeners();
  } catch (_) {
    _errorMessage = 'Unable to refresh enquiries.';
    notifyListeners();
  }
}

  void deleteEnquiry(int id) {
  _deletedIds.add(id);

  _enquiries.removeWhere((item) => item.id == id);

  _expandedIndex = null;

  notifyListeners();
}
}