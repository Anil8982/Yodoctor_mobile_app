import 'package:flutter_riverpod/flutter_riverpod.dart';

enum AppRole { patient, doctor, admin }

class AppRoleNotifier extends Notifier<AppRole> {
  @override
  AppRole build() => AppRole.patient;

  void setRole(AppRole newRole) => state = newRole;
}

final appRoleProvider = NotifierProvider<AppRoleNotifier, AppRole>(
  AppRoleNotifier.new,
);