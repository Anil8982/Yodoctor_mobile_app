import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yodoctor/core/providers/storage_provider.dart'; // 🎯 स्टोरेज प्रोव्हायडर इम्पोर्ट करा

enum AppRole { patient, doctor, admin }

class AppRoleNotifier extends Notifier<AppRole> {
  @override
  AppRole build() {
    final storage = ref.read(storageProvider);
    final savedRole = storage.getRole();

    if (savedRole == 'doctor') return AppRole.doctor;
    if (savedRole == 'admin') return AppRole.admin;
    return AppRole.patient;
  }

  Future<void> setRole(AppRole newRole) async {
    state = newRole;
    final storage = ref.read(storageProvider);
    await storage.saveRole(newRole.name);
  }

  Future<void> clearRole() async {
    state = AppRole.patient;
    final storage = ref.read(storageProvider);
    await storage.clearRole();
  }
}

final appRoleProvider = NotifierProvider<AppRoleNotifier, AppRole>(
  AppRoleNotifier.new,
);