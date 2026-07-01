import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yodoctor/core/models/patient/lab_test_model.dart';
import '../../../../core/utils/dummy_data.dart';

class LabCategoryNotifier extends Notifier<String> {
  @override
  String build() {
    return 'all';
  }

  void selectCategory(String categoryId) {
    state = categoryId;
  }
}

final labCategoryProvider = NotifierProvider<LabCategoryNotifier, String>(
  LabCategoryNotifier.new,
);

class LabCartNotifier extends Notifier<List<LabPackage>> {
  @override
  List<LabPackage> build() {
    return [];
  }

  void toggleCartItem(LabPackage package) {
    if (state.any((item) => item.id == package.id)) {
      state = state.where((item) => item.id != package.id).toList();
    } else {
      state = [...state, package];
    }
  }

  void clearCart() {
    state = [];
  }
}

final labCartProvider = NotifierProvider<LabCartNotifier, List<LabPackage>>(
  LabCartNotifier.new,
);

final filteredLabPackagesProvider = Provider<List<LabPackage>>((ref) {
  final selectedCategory = ref.watch(labCategoryProvider);

  if (selectedCategory == 'all') {
    return DummyData.labPackages;
  }
  return DummyData.labPackages.where((pkg) => pkg.categoryId == selectedCategory).toList();
});