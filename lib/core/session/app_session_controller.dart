import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/app_role_provider.dart';
import '../../modules/auth/repositories/patient_auth_repository.dart';
import '../../modules/auth/repositories/doctor_auth_repository.dart';

import 'provider_registry.dart';

final appSessionProvider = Provider(
      (ref) => AppSessionController(ref),
);

class AppSessionController {
  AppSessionController(this.ref);

  final Ref ref;

  Future<void> logout(AppRole role) async {

    if (role == AppRole.doctor) {
      await ref.read(doctorAuthRepositoryProvider).clearAuthSession();
    } else {
      await ref.read(patientAuthRepositoryProvider).signOut();
    }

    await ref.read(appRoleProvider.notifier).clearRole();

    ProviderRegistry.invalidateAll(ref);
  }
}