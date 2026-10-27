import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:yodoctor/core/constants/log_tags.dart';
import 'package:yodoctor/core/debug/app_logger.dart';
import 'package:yodoctor/core/providers/app_role_provider.dart';
import 'package:yodoctor/core/providers/locale_provider.dart';
import 'package:yodoctor/core/routes/app_routes.dart';
import 'package:yodoctor/l10n/app_localizations.dart';
import 'package:yodoctor/modules/app_config/controllers/app_config_controller.dart';
import 'package:yodoctor/modules/patient/controllers/family_controller.dart';
import 'package:yodoctor/modules/widgets/app_snack_bar.dart';
import 'package:yodoctor/modules/widgets/logout_dialog.dart';
import '../../widgets/patient_app_bar.dart';
import '../../widgets/patient_bottom_nav.dart';
import '../../controllers/profile_controller.dart';
import '../../../../core/utils/app_spacing.dart';
import 'widgets/profile_header.dart';
import 'widgets/profile_settings_tile.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  static const String _subTag = 'ProfileScreen';

  @override
  void initState() {
    super.initState();
    AppLogger.info(
      'ProfileScreen Initialized',
      tag: LogTags.ui,
      subTag: _subTag,
    );
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(profileControllerProvider.notifier).loadProfile();
      ref.read(familyControllerProvider.notifier).loadFamilyMembers();
    });
  }

  void _navigateToEditProfile() {
    context.push(AppRoutes.profileEdit);
  }

  void _showLanguageSheet(BuildContext context) {
    final currentLocale = ref.read(localeProvider);
    final colorScheme = Theme.of(context).colorScheme;
    final l10n = AppLocalizations.of(context);

    showModalBottomSheet(
      context: context,
      backgroundColor: colorScheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: colorScheme.outlineVariant.withValues(alpha: 0.5),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 18),
              Text(
                l10n?.chooseAppLanguage ?? 'Choose App Language',
                style: const TextStyle(
                  fontWeight: FontWeight.w900,
                  fontSize: 18,
                  letterSpacing: -0.3,
                ),
              ),
              const SizedBox(height: 16),
              _buildLanguageOption(
                context: ctx,
                title: l10n?.languageEnglish ?? 'English',
                subtitle: 'English',
                isSelected: currentLocale.languageCode == 'en',
                onTap: () {
                  ref
                      .read(localeProvider.notifier)
                      .setLocale(LocaleNotifier.englishLocale);
                  Navigator.pop(ctx);
                },
              ),
              const SizedBox(height: 10),
              _buildLanguageOption(
                context: ctx,
                title: l10n?.languageHindi ?? 'हिन्दी (Hindi)',
                subtitle: 'हिन्दी भाषा',
                isSelected: currentLocale.languageCode == 'hi',
                onTap: () {
                  ref
                      .read(localeProvider.notifier)
                      .setLocale(LocaleNotifier.hindiLocale);
                  Navigator.pop(ctx);
                },
              ),
              const SizedBox(height: 12),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLanguageOption({
    required BuildContext context,
    required String title,
    required String subtitle,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    final colorScheme = Theme.of(context).colorScheme;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
          decoration: BoxDecoration(
            color: isSelected
                ? colorScheme.primary.withValues(alpha: 0.08)
                : colorScheme.surface,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: isSelected
                  ? colorScheme.primary
                  : colorScheme.outlineVariant.withValues(alpha: 0.4),
              width: isSelected ? 1.5 : 1.0,
            ),
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 14,
                        color: colorScheme.onSurface,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 11.5,
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              if (isSelected)
                Icon(
                  Icons.check_circle_rounded,
                  color: colorScheme.primary,
                  size: 20,
                ),
            ],
          ),
        ),
      ),
    );
  }

  void _openPrivacyPolicy(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final appConfig = ref.read(appConfigProvider).config;
    final url = appConfig?.legalAndSupport.privacyPolicyUrl ?? '';
    if (url.isNotEmpty) {
      context.push(
        AppRoutes.webViewPage(
          title: l10n?.privacyPolicyOnlyTitle ?? 'Privacy Policy',
          url: url,
        ),
      );
    } else {
      AppSnackBar.show(
        message: 'Privacy policy link is currently unavailable',
        type: AppSnackBarType.info,
      );
    }
  }

  void _openTermsOfService(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final appConfig = ref.read(appConfigProvider).config;
    final url = appConfig?.legalAndSupport.termsServiceUrl ?? '';
    if (url.isNotEmpty) {
      context.push(
        AppRoutes.webViewPage(
          title: l10n?.termsOfServiceTitle ?? 'Terms of Service',
          url: url,
        ),
      );
    } else {
      AppSnackBar.show(
        message: 'Terms of service link is currently unavailable',
        type: AppSnackBarType.info,
      );
    }
  }

  void _openHelpAndSupport(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final appConfig = ref.read(appConfigProvider).config;
    final helpCenter = appConfig?.legalAndSupport.helpCenterUrl ?? '';

    if (helpCenter.isNotEmpty) {
      context.push(
        AppRoutes.webViewPage(
          title: l10n?.helpSupportTitle ?? 'Help & Support',
          url: helpCenter,
        ),
      );
    } else {
      AppSnackBar.show(
        message: 'Help & Support link is currently unavailable',
        type: AppSnackBarType.info,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final profileState = ref.watch(profileControllerProvider);
    final familyState = ref.watch(familyControllerProvider);
    final currentLocale = ref.watch(localeProvider);
    final l10n = AppLocalizations.of(context);
    final int familyCount = familyState.members.length;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: PatientAppBar(
        titleText: l10n?.profileSettings ?? 'My Profile',
        subtitleText: profileState.user != null && profileState.user!.id > 0
            ? 'Patient ID: #${profileState.user!.id}'
            : (l10n?.personalDetailsSubtitle ?? 'Personal & Account Settings'),
      ),
      body: profileState.user == null && profileState.isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(
          AppSpacing.md,
          14,
          AppSpacing.md,
          PatientBottomNav.floatingNavPadding(context),
        ),
        physics: const AlwaysScrollableScrollPhysics(
          parent: BouncingScrollPhysics(),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (profileState.user != null) ...[
              // Patient Identity Header Card
              ProfileHeader(
                user: profileState.user!,
                isEditing: false,
                onEditTap: _navigateToEditProfile,
              ),

              const SizedBox(height: 18),

              // Section 1: Medical Records & Appointments
              ProfileSettingsGroup(
                title: l10n?.myHealthcareSection ?? 'MY HEALTHCARE',
                children: [
                  ProfileSettingsTile(
                    icon: Icons.calendar_month_rounded,
                    iconColor: const Color(0xFF0288D1),
                    title: l10n?.appointmentsHistory ?? 'Appointments History',
                    subtitle: l10n?.appointmentsHistorySubtitle ?? 'Past, ongoing & scheduled appointments',
                    onTap: () => context.push(AppRoutes.history),
                  ),
                  ProfileSettingsTile(
                    icon: Icons.verified_user_rounded,
                    iconColor: const Color(0xFF00897B),
                    title: l10n?.certificateWallet ?? 'Certificate Wallet',
                    subtitle: l10n?.certificateWalletSubtitle ?? 'View, verify & download medical certificates',
                    onTap: () => context.push(AppRoutes.certificateWallet),
                  ),
                ],
              ),

              const SizedBox(height: 18),

              // Section 2: Account & Family Management
              ProfileSettingsGroup(
                title: l10n?.accountAndFamilySection ?? 'ACCOUNT & FAMILY',
                children: [
                  ProfileSettingsTile(
                    icon: Icons.person_outline_rounded,
                    iconColor: colorScheme.primary,
                    title: l10n?.personalDetails ?? 'Personal Details',
                    subtitle: l10n?.personalDetailsSubtitle ?? 'View and update your personal info',
                    onTap: _navigateToEditProfile,
                  ),
                  ProfileSettingsTile(
                    icon: Icons.family_restroom_rounded,
                    iconColor: const Color(0xFF5C6BC0),
                    title: l10n?.familyMembers ?? 'Family Members',
                    subtitle: familyCount > 0
                        ? '$familyCount linked member profiles'
                        : (l10n?.familyMembersSubtitle ?? 'Add & manage dependents'),
                    trailing: familyCount > 0
                        ? Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: colorScheme.primary.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        '$familyCount',
                        style: TextStyle(
                          color: colorScheme.primary,
                          fontWeight: FontWeight.w800,
                          fontSize: 11,
                        ),
                      ),
                    )
                        : null,
                    onTap: () => context.push(AppRoutes.family),
                  ),
                ],
              ),

              const SizedBox(height: 18),

              // Section 3: Preferences
              ProfileSettingsGroup(
                title: l10n?.appPreferencesSection ?? 'PREFERENCES',
                children: [
                  ProfileSettingsTile(
                    icon: Icons.translate_rounded,
                    iconColor: const Color(0xFF8E24AA),
                    title: l10n?.language ?? 'Language',
                    subtitle: currentLocale.languageCode == 'hi'
                        ? (l10n?.languageHindi ?? 'हिन्दी (Hindi)')
                        : (l10n?.languageEnglish ?? 'English (English)'),
                    trailing: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 3,
                      ),
                      decoration: BoxDecoration(
                        color: colorScheme.primaryContainer.withValues(alpha: 0.5),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            currentLocale.languageCode.toUpperCase(),
                            style: TextStyle(
                              color: colorScheme.primary,
                              fontWeight: FontWeight.w800,
                              fontSize: 11,
                            ),
                          ),
                          const SizedBox(width: 4),
                          Icon(
                            Icons.chevron_right_rounded,
                            size: 16,
                            color: colorScheme.primary,
                          ),
                        ],
                      ),
                    ),
                    onTap: () => _showLanguageSheet(context),
                  ),
                ],
              ),

              const SizedBox(height: 18),

              // Section 4: Help, Legal & Support
              ProfileSettingsGroup(
                title: l10n?.supportAndLegalSection ?? 'SUPPORT & LEGAL',
                children: [
                  ProfileSettingsTile(
                    icon: Icons.headset_mic_rounded,
                    iconColor: const Color(0xFF00897B),
                    title: l10n?.helpSupportTitle ?? 'Help & Support',
                    subtitle: l10n?.helpSupportDesc ?? 'Get 24/7 assistance & query support',
                    onTap: () => _openHelpAndSupport(context),
                  ),
                  ProfileSettingsTile(
                    icon: Icons.privacy_tip_outlined,
                    iconColor: const Color(0xFF546E7A),
                    title: l10n?.privacyPolicyOnlyTitle ?? 'Privacy Policy',
                    subtitle: l10n?.privacyPolicySubtitle ?? 'How we protect your medical data',
                    onTap: () => _openPrivacyPolicy(context),
                  ),
                  ProfileSettingsTile(
                    icon: Icons.description_outlined,
                    iconColor: const Color(0xFF5C6BC0),
                    title: l10n?.termsOfServiceTitle ?? 'Terms of Service',
                    subtitle: l10n?.termsOfServiceSubtitle ?? 'Terms and conditions of use',
                    onTap: () => _openTermsOfService(context),
                  ),
                ],
              ),

              const SizedBox(height: 18),

              // Section 5: Account Actions
              ProfileSettingsGroup(
                title: l10n?.accountSection ?? 'ACCOUNT',
                children: [
                  ProfileSettingsTile(
                    icon: Icons.logout_rounded,
                    iconColor: colorScheme.error,
                    title: l10n?.logoutDrawerItem ?? 'Logout',
                    subtitle: l10n?.logoutAccountSubtitle ?? 'Sign out of your YoDoctor account',
                    isDestructive: true,
                    onTap: () => LogoutDialog.show(
                      context,
                      ref,
                      role: AppRole.patient,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),
            ] else if (profileState.errorMessage != null) ...[
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    profileState.errorMessage!,
                    style: TextStyle(color: colorScheme.error),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}