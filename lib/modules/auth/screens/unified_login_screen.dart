import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:yodoctor/core/constants/app_assets.dart';
import 'package:yodoctor/core/constants/log_tags.dart';
import 'package:yodoctor/core/debug/app_logger.dart';
import 'package:yodoctor/core/providers/app_role_provider.dart';
import 'package:yodoctor/core/routes/app_routes.dart';
import 'package:yodoctor/core/theme/app_theme.dart';

import 'package:yodoctor/modules/auth/controllers/doctor_login_controller.dart';
import 'package:yodoctor/modules/auth/controllers/patient_auth_controller.dart';
import 'package:yodoctor/modules/auth/widgets/login_mode_selector.dart';
import 'package:yodoctor/modules/auth/widgets/otp_bottom_sheet.dart';
import 'package:yodoctor/modules/auth/widgets/social_auth_button.dart';
import 'package:yodoctor/modules/auth/widgets/yo_login_text_field.dart';
import 'package:yodoctor/modules/widgets/app_snack_bar.dart';

enum UserRole { doctor, patient }

class UnifiedLoginScreen extends ConsumerStatefulWidget {
  final UserRole role;

  const UnifiedLoginScreen({super.key, required this.role});

  @override
  ConsumerState<UnifiedLoginScreen> createState() => _UnifiedLoginScreenState();
}

class _UnifiedLoginScreenState extends ConsumerState<UnifiedLoginScreen>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();

  final _identifierController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _isOtpLogin = false;

  late final AnimationController _animController;
  late final Animation<double> _fadeAnimation;
  late final Animation<Offset> _slideAnimation;

  bool get _isDoctor => widget.role == UserRole.doctor;
  Color get _themeColor => _isDoctor ? AppTheme.primary : AppTheme.secondary;
  static const String _subTag = 'UnifiedLoginScreen';

  @override
  void initState() {
    super.initState();

    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );

    _fadeAnimation = CurvedAnimation(
      parent: _animController,
      curve: const Interval(0.0, 0.8, curve: Curves.easeOutCubic),
    );

    _slideAnimation =
        Tween<Offset>(begin: const Offset(0, 0.06), end: Offset.zero).animate(
          CurvedAnimation(
            parent: _animController,
            curve: const Interval(0.0, 1.0, curve: Curves.easeOutCubic),
          ),
        );

    _animController.forward();
  }

  @override
  void dispose() {
    _animController.dispose();
    _identifierController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  String _cleanInputIdentifier(String input) {
    final trimmed = input.trim();
    if (RegExp(r'[a-zA-Z@]').hasMatch(trimmed)) {
      return trimmed.toLowerCase();
    }

    String cleanNumber = trimmed.replaceAll(RegExp(r'[\s\-()+]'), '');
    if (cleanNumber.startsWith('91') && cleanNumber.length == 12) {
      cleanNumber = cleanNumber.substring(2);
    } else if (cleanNumber.startsWith('0') && cleanNumber.length == 11) {
      cleanNumber = cleanNumber.substring(1);
    }
    return cleanNumber;
  }

  void _processDoctorRedirect(Map<String, dynamic> result) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;

      switch (result['redirect']) {
        case 'resume':
          context.go(AppRoutes.doctorRegister, extra: result['nextStep']);
          break;
        case 'waiting-approval':
          context.go(AppRoutes.waitingApproval);
          break;
        case 'dashboard':
          ref.read(appRoleProvider.notifier).setRole(AppRole.doctor);
          context.go(AppRoutes.doctorDashboard);
          break;
        default:
          ref.read(appRoleProvider.notifier).setRole(AppRole.doctor);
          context.go(AppRoutes.doctorDashboard);
          break;
      }
    });
  }

  Future<void> _handleSubmit() async {
    if (!_formKey.currentState!.validate()) return;

    FocusManager.instance.primaryFocus?.unfocus();

    final identifier = _cleanInputIdentifier(_identifierController.text);
    final password = _passwordController.text.trim();

    AppLogger.info(
      'Submitting login (${_isOtpLogin ? "OTP Flow" : "Normal Password Flow"}) for ${widget.role.name}',
      tag: LogTags.ui,
      subTag: _subTag,
    );

    if (_isOtpLogin) {
      await _executeOtpLogin(identifier);
    } else {
      if (_isDoctor) {
        await _executeDoctorNormalLogin(identifier, password);
      } else {
        await _executePatientNormalLogin(identifier, password);
      }
    }
  }

  // -------------------------------------------------------------
  // 🔐 Normal Password Login Flows
  // -------------------------------------------------------------

  Future<void> _executeDoctorNormalLogin(String identifier, String password) async {
    final notifier = ref.read(doctorLoginControllerProvider.notifier);
    final result = await notifier.login(
      identifier: identifier,
      password: password,
    );

    if (!mounted) return;

    if (result == null) {
      final state = ref.read(doctorLoginControllerProvider);
      final errorMsg = state.error?.toString() ?? 'Unable to login. Please check your credentials.';
      AppSnackBar.show(message: errorMsg, type: AppSnackBarType.error);
      return;
    }

    if (result['redirect'] == 'otp' || result['requiresOtp'] == true) {
      _showOtpModal(
        verificationId: result['verificationId'],
        channel: result['channel'],
        mobile: result['mobile'],
        maskedDestination: result['maskedDestination'] ?? identifier,
        onVerifyOtp: (otp) async {
          final verifyResult = await notifier.verifyOtp(
            otp: otp,
            verificationId: result['verificationId'],
            channel: result['channel'],
            mobile: result['mobile'],
            identifier: identifier,
          );
          if (verifyResult != null) {
            _processDoctorRedirect(verifyResult);
            return true;
          }
          final state = ref.read(doctorLoginControllerProvider);
          return state.error?.toString() ?? 'Incorrect OTP. Please check the code and try again.';
        },
        onResendOtp: () async {
          final resendResult = await notifier.resendOtp(
            identifier: identifier,
            password: password,
          );
          if (resendResult != null && resendResult['success'] == true) {
            return true;
          }
          return resendResult?['message'] ?? 'Failed to resend OTP';
        },
      );
      return;
    }

    _processDoctorRedirect(result);
  }

  Future<void> _executePatientNormalLogin(String identifier, String password) async {
    final notifier = ref.read(patientAuthControllerProvider.notifier);
    final result = await notifier.signInWithEmail(
      email: identifier,
      password: password,
    );

    if (!mounted) return;

    if (result == null) {
      final state = ref.read(patientAuthControllerProvider);
      final errorMsg = state.error?.toString() ?? 'Unable to login. Please check your credentials.';
      AppSnackBar.show(message: errorMsg, type: AppSnackBarType.error);
      return;
    }

    if (result['redirect'] == 'otp' || result['requiresOtp'] == true) {
      _showOtpModal(
        verificationId: result['verificationId'],
        channel: result['channel'],
        mobile: result['mobile'],
        maskedDestination: result['maskedDestination'] ?? identifier,
        onVerifyOtp: (otp) async {
          final verifyResult = await notifier.verifyOtp(
            otp: otp,
            email: identifier,
            verificationId: result['verificationId'],
            channel: result['channel'],
            mobile: result['mobile'],
            identifier: identifier,
          );

          if (verifyResult != null && verifyResult['success'] == true) {
            ref.read(appRoleProvider.notifier).setRole(AppRole.patient);
            if (mounted) {
              context.go(AppRoutes.dashboard);
            }
            return true;
          }
          final state = ref.read(patientAuthControllerProvider);
          return state.error?.toString() ?? 'Incorrect OTP. Please check the code and try again.';
        },
        onResendOtp: () async {
          final resendResult = await notifier.resendOtp(
            identifier: identifier,
            password: password,
          );
          if (resendResult != null && resendResult['success'] == true) {
            return true;
          }
          return resendResult?['message'] ?? 'Failed to resend OTP';
        },
      );
      return;
    }

    ref.read(appRoleProvider.notifier).setRole(AppRole.patient);
    context.go(AppRoutes.dashboard);
  }

  // -------------------------------------------------------------
  // 📲 Login With OTP (No Password) Flows
  // -------------------------------------------------------------

  Future<void> _executeOtpLogin(String identifier) async {
    if (_isDoctor) {
      final notifier = ref.read(doctorLoginControllerProvider.notifier);
      final result = await notifier.sendLoginOtp(identifier: identifier);

      if (!mounted) return;

      if (result == null) {
        final state = ref.read(doctorLoginControllerProvider);
        final errorMsg = state.error?.toString() ?? 'Failed to send OTP. Please try again.';
        AppSnackBar.show(message: errorMsg, type: AppSnackBarType.error);
        return;
      }

      if (result['requiresOtp'] == true || result['redirect'] == 'otp') {
        _showOtpModal(
          verificationId: result['verificationId'],
          channel: result['channel'],
          mobile: result['mobile'],
          maskedDestination: result['maskedDestination'] ?? identifier,
          onVerifyOtp: (otp) async {
            final verifyResult = await notifier.verifyOtp(
              otp: otp,
              verificationId: result['verificationId'],
              channel: result['channel'],
              mobile: result['mobile'],
              identifier: identifier,
            );
            if (verifyResult != null) {
              _processDoctorRedirect(verifyResult);
              return true;
            }
            final state = ref.read(doctorLoginControllerProvider);
            return state.error?.toString() ?? 'Incorrect OTP. Please check the code and try again.';
          },
          onResendOtp: () async {
            final resendResult = await notifier.resendOtp(
              identifier: identifier,
            );
            if (resendResult != null && resendResult['success'] == true) {
              return true;
            }
            return resendResult?['message'] ?? 'Failed to resend OTP';
          },
        );
      } else {
        _processDoctorRedirect(result);
      }
    } else {
      final notifier = ref.read(patientAuthControllerProvider.notifier);
      final result = await notifier.sendLoginOtp(identifier: identifier);

      if (!mounted) return;

      if (result == null) {
        final state = ref.read(patientAuthControllerProvider);
        final errorMsg = state.error?.toString() ?? 'Failed to send OTP. Please try again.';
        AppSnackBar.show(message: errorMsg, type: AppSnackBarType.error);
        return;
      }

      if (result['requiresOtp'] == true || result['redirect'] == 'otp') {
        _showOtpModal(
          verificationId: result['verificationId'],
          channel: result['channel'],
          mobile: result['mobile'],
          maskedDestination: result['maskedDestination'] ?? identifier,
          onVerifyOtp: (otp) async {
            final verifyResult = await notifier.verifyOtp(
              otp: otp,
              email: identifier,
              verificationId: result['verificationId'],
              channel: result['channel'],
              mobile: result['mobile'],
              identifier: identifier,
            );

            if (verifyResult != null && verifyResult['success'] == true) {
              ref.read(appRoleProvider.notifier).setRole(AppRole.patient);
              if (mounted) {
                context.go(AppRoutes.dashboard);
              }
              return true;
            }
            final state = ref.read(patientAuthControllerProvider);
            return state.error?.toString() ?? 'Incorrect OTP. Please check the code and try again.';
          },
          onResendOtp: () async {
            final resendResult = await notifier.resendOtp(
              identifier: identifier,
            );
            if (resendResult != null && resendResult['success'] == true) {
              return true;
            }
            return resendResult?['message'] ?? 'Failed to resend OTP';
          },
        );
      } else {
        ref.read(appRoleProvider.notifier).setRole(AppRole.patient);
        if (mounted) {
          context.go(AppRoutes.dashboard);
        }
      }
    }
  }

  void _showOtpModal({
    required String? verificationId,
    required String? channel,
    required String? mobile,
    required String? maskedDestination,
    required OtpVerifyCallback onVerifyOtp,
    required OtpResendCallback onResendOtp,
  }) {
    OtpBottomSheet.show(
      context: context,
      verificationId: verificationId,
      channel: channel,
      mobile: mobile,
      maskedDestination: maskedDestination,
      primaryColor: _themeColor,
      onVerify: onVerifyOtp,
      onResend: onResendOtp,
    );
  }

  // -------------------------------------------------------------
  // 🌐 Google Sign-In (Patient Only)
  // -------------------------------------------------------------

  Future<void> _handleGoogleSignIn() async {
    FocusManager.instance.primaryFocus?.unfocus();
    AppLogger.info(
      'Google button click event received',
      tag: LogTags.ui,
      subTag: _subTag,
    );

    try {
      final user = await ref
          .read(patientAuthControllerProvider.notifier)
          .signInWithGoogle();

      if (!mounted) return;

      if (user != null) {
        AppLogger.highlight(
          'OAuth authorization resolved for user: ${user.name}',
        );
        ref.read(appRoleProvider.notifier).setRole(AppRole.patient);
        context.go(AppRoutes.dashboard);
      } else {
        final authState = ref.read(patientAuthControllerProvider);
        if (authState.hasError && mounted) {
          AppSnackBar.show(
            message: authState.error.toString(),
            type: AppSnackBarType.error,
          );
        }
      }
    } catch (e, st) {
      AppLogger.error(
        'Unhandled Google Sign-In exception',
        tag: LogTags.ui,
        subTag: _subTag,
        error: e,
        stackTrace: st,
      );

      if (!mounted) return;
      AppSnackBar.show(
        message: 'Could not sign in with Google. Please try again.',
        type: AppSnackBarType.error,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final size = MediaQuery.sizeOf(context);
    final isCompact = size.height < 740 || size.width < 380;
    final isVeryCompact = size.height < 640;

    final isProcessing = _isDoctor
        ? ref.watch(doctorLoginControllerProvider).isLoading
        : ref.watch(patientAuthControllerProvider) is AsyncLoading;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      body: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: Stack(
          children: [
            _buildAmbientMeshBackground(colorScheme),

            SafeArea(
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: SlideTransition(
                  position: _slideAnimation,
                  child: CustomScrollView(
                    physics: const BouncingScrollPhysics(),
                    slivers: [
                      SliverToBoxAdapter(
                        child: _buildTopBar(context, colorScheme, theme, isCompact),
                      ),
                      SliverPadding(
                        padding: EdgeInsets.symmetric(
                          horizontal: isCompact ? 16 : 20,
                          vertical: isCompact ? 6 : 10,
                        ),
                        sliver: SliverToBoxAdapter(
                          child: Center(
                            child: ConstrainedBox(
                              constraints: const BoxConstraints(maxWidth: 440),
                              child: _buildMainCard(
                                context,
                                theme,
                                colorScheme,
                                isProcessing,
                                isCompact,
                                isVeryCompact,
                              ),
                            ),
                          ),
                        ),
                      ),
                      SliverFillRemaining(
                        hasScrollBody: false,
                        child: Align(
                          alignment: Alignment.bottomCenter,
                          child: Padding(
                            padding: EdgeInsets.only(
                              bottom: isVeryCompact ? 12 : 20,
                              top: 8,
                            ),
                            child: _buildRegisterFooter(
                              context,
                              colorScheme,
                              theme,
                              isProcessing,
                              isCompact,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAmbientMeshBackground(ColorScheme colorScheme) {
    return Positioned.fill(
      child: Stack(
        children: [
          Positioned(
            top: -100,
            right: -60,
            child: Container(
              width: 320,
              height: 320,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    _themeColor.withValues(alpha: 0.15),
                    _themeColor.withValues(alpha: 0.0),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            bottom: -80,
            left: -80,
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    _themeColor.withValues(alpha: 0.10),
                    _themeColor.withValues(alpha: 0.0),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTopBar(
    BuildContext context,
    ColorScheme colorScheme,
    ThemeData theme,
    bool isCompact,
  ) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: isCompact ? 16 : 20,
        vertical: isCompact ? 6 : 10,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton.filledTonal(
            onPressed: () {
              if (context.canPop()) {
                context.pop();
              } else {
                context.go(AppRoutes.landing);
              }
            },
            style: IconButton.styleFrom(
              backgroundColor: colorScheme.surfaceContainerHighest.withValues(
                alpha: 0.7,
              ),
              foregroundColor: colorScheme.onSurface,
              minimumSize: Size(isCompact ? 36 : 40, isCompact ? 36 : 40),
              padding: EdgeInsets.zero,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
                side: BorderSide(
                  color: colorScheme.outlineVariant.withValues(alpha: 0.4),
                  width: 1,
                ),
              ),
            ),
            icon: Icon(Icons.arrow_back_rounded, size: isCompact ? 18 : 20),
          ),

          Container(
            padding: EdgeInsets.symmetric(
              horizontal: isCompact ? 10 : 12,
              vertical: isCompact ? 5 : 6,
            ),
            decoration: BoxDecoration(
              color: _themeColor.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: _themeColor.withValues(alpha: 0.25),
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  _isDoctor
                      ? Icons.medical_services_rounded
                      : Icons.person_rounded,
                  size: isCompact ? 13 : 15,
                  color: _themeColor,
                ),
                const SizedBox(width: 5),
                Text(
                  _isDoctor ? 'Doctor Portal' : 'Patient Portal',
                  style: theme.textTheme.labelMedium?.copyWith(
                    color: _themeColor,
                    fontWeight: FontWeight.w700,
                    fontSize: isCompact ? 11.5 : 12.5,
                    letterSpacing: 0.2,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMainCard(
    BuildContext context,
    ThemeData theme,
    ColorScheme colorScheme,
    bool isProcessing,
    bool isCompact,
    bool isVeryCompact,
  ) {
    final logoSize = isVeryCompact ? 56.0 : (isCompact ? 64.0 : 72.0);

    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(isCompact ? 20 : 24),
        border: Border.all(
          color: colorScheme.outlineVariant.withValues(alpha: 0.5),
        ),
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.withValues(alpha: 0.04),
            blurRadius: 18,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      padding: EdgeInsets.symmetric(
        horizontal: isCompact ? 18 : 22,
        vertical: isVeryCompact ? 16 : (isCompact ? 18 : 22),
      ),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: Hero(
                tag: 'AppLogo',
                child: Container(
                  padding: const EdgeInsets.all(3),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        _themeColor.withValues(alpha: 0.85),
                        _themeColor.withValues(alpha: 0.25),
                      ],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: AppTheme.black.withValues(alpha: 0.12),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Container(
                    width: logoSize,
                    height: logoSize,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    padding: const EdgeInsets.all(3),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(40),
                      child: Image.asset(
                        AppAssets.logoLightV,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: isVeryCompact ? 10 : (isCompact ? 12 : 16)),

            Text(
              _isDoctor ? 'Welcome Back, Doctor' : 'Welcome to YoDoctor',
              textAlign: TextAlign.center,
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w800,
                color: colorScheme.onSurface,
                fontSize: isVeryCompact ? 18.5 : (isCompact ? 20 : 22),
                letterSpacing: -0.3,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              _isDoctor
                  ? (_isOtpLogin
                      ? 'Enter your registered email or mobile to receive OTP.'
                      : 'Sign in to access appointments and patient records.')
                  : (_isOtpLogin
                      ? 'Enter your registered email or mobile to receive OTP.'
                      : 'Sign in to consult certified specialists & health records.'),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: theme.textTheme.bodySmall?.copyWith(
                color: colorScheme.onSurfaceVariant,
                fontSize: isCompact ? 12.5 : 13.5,
                height: 1.35,
              ),
            ),
            SizedBox(height: isVeryCompact ? 14 : (isCompact ? 16 : 20)),

            YoLoginTextField(
              color: _themeColor,
              hint: 'Email or Mobile Number',
              prefixIcon: Icons.alternate_email_rounded,
              autoDetectPhone: true,
              keyboardType: TextInputType.emailAddress,
              controller: _identifierController,
              enabled: !isProcessing,
              validator: (v) {
                final raw = v?.trim() ?? '';
                if (raw.isEmpty) {
                  return 'Please enter your email or mobile number';
                }

                if (RegExp(r'[a-zA-Z@]').hasMatch(raw)) {
                  final emailRegex = RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$');
                  if (!emailRegex.hasMatch(raw)) {
                    return 'Enter a valid email address';
                  }
                  return null;
                }

                String clean = raw.replaceAll(RegExp(r'[\s\-()]'), '');
                if (clean.startsWith('+91')) {
                  clean = clean.substring(3);
                } else if (clean.startsWith('91') && clean.length == 12) {
                  clean = clean.substring(2);
                } else if (clean.startsWith('0') && clean.length == 11) {
                  clean = clean.substring(1);
                }

                if (!RegExp(r'^[6-9]\d{9}$').hasMatch(clean)) {
                  return 'Enter a valid 10-digit mobile number';
                }
                return null;
              },
            ),
            SizedBox(height: isCompact ? 6 : 8),

            AnimatedSize(
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeInOut,
              child: !_isOtpLogin
                  ? Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        YoLoginTextField(
                          color: _themeColor,
                          hint: 'Password',
                          prefixIcon: Icons.lock_outline_rounded,
                          isPassword: true,
                          controller: _passwordController,
                          enabled: !isProcessing,
                          validator: (v) {
                            if (_isOtpLogin) return null;
                            if (v == null || v.isEmpty) return 'Enter your password';
                            if (v.length < 6) {
                              return 'Password must be at least 6 characters';
                            }
                            return null;
                          },
                        ),
                        // Align(
                        //   alignment: Alignment.centerRight,
                        //   child: Padding(
                        //     padding: const EdgeInsets.only(top: 2, bottom: 4),
                        //     child: TextButton(
                        //       onPressed: isProcessing
                        //           ? null
                        //           : () {
                        //               AppSnackBar.show(
                        //                 message:
                        //                     'Password reset instructions will be sent shortly',
                        //                 type: AppSnackBarType.info,
                        //               );
                        //             },
                        //       style: TextButton.styleFrom(
                        //         visualDensity: VisualDensity.compact,
                        //         padding: const EdgeInsets.symmetric(
                        //           horizontal: 4,
                        //           vertical: 4,
                        //         ),
                        //         minimumSize: Size.zero,
                        //         tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        //         foregroundColor: _themeColor,
                        //         textStyle: TextStyle(
                        //           fontWeight: FontWeight.w600,
                        //           fontSize: isCompact ? 12.5 : 13,
                        //         ),
                        //       ),
                        //       child: const Text('Forgot Password?'),
                        //     ),
                        //   ),
                        // ),
                      ],
                    )
                  : const SizedBox.shrink(),
            ),

            SizedBox(height: isCompact ? 8 : 10),


            LoginModeSelector(
              isOtpLogin: _isOtpLogin,
              onChanged: (val) {
                setState(() {
                  _isOtpLogin = val;
                });
              },
              activeColor: _themeColor,
              enabled: !isProcessing,
            ),
            SizedBox(height: isCompact ? 10 : 14),

            SizedBox(
              height: isCompact ? 48 : 50,
              child: FilledButton(
                onPressed: isProcessing ? null : _handleSubmit,
                style: FilledButton.styleFrom(
                  backgroundColor: _themeColor,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  elevation: 0,
                ),
                child: isProcessing
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : Text(
                        _isOtpLogin
                            ? 'Send OTP'
                            : (_isDoctor ? 'Sign In as Doctor' : 'Sign In as Patient'),
                        style: TextStyle(
                          fontSize: isCompact ? 14.5 : 15.5,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.2,
                        ),
                      ),
              ),
            ),

            if (!_isDoctor) ...[
              Padding(
                padding: EdgeInsets.symmetric(vertical: isCompact ? 10 : 14),
                child: Row(
                  children: [
                    Expanded(
                      child: Divider(
                        color: colorScheme.outlineVariant.withValues(alpha: 0.5),
                        height: 1,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Text(
                        'OR',
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: colorScheme.onSurfaceVariant.withValues(
                            alpha: 0.65,
                          ),
                          fontWeight: FontWeight.w600,
                          fontSize: 11,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Divider(
                        color: colorScheme.outlineVariant.withValues(alpha: 0.5),
                        height: 1,
                      ),
                    ),
                  ],
                ),
              ),
              SocialAuthButton(
                icon: Image.asset(AppAssets.google, height: isCompact ? 18 : 20),
                label: 'Continue with Google',
                height: isCompact ? 48 : 50,
                borderRadius: 14,
                isLoading: isProcessing,
                onTap: _handleGoogleSignIn,
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildRegisterFooter(
    BuildContext context,
    ColorScheme colorScheme,
    ThemeData theme,
    bool isProcessing,
    bool isCompact,
  ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "Don't have an account?",
          style: theme.textTheme.bodyMedium?.copyWith(
            color: colorScheme.onSurfaceVariant,
            fontSize: isCompact ? 13 : 14,
          ),
        ),
        TextButton(
          onPressed: isProcessing
              ? null
              : () => context.push(
                  _isDoctor
                      ? AppRoutes.doctorRegister
                      : AppRoutes.patientRegister,
                ),
          style: TextButton.styleFrom(
            visualDensity: VisualDensity.compact,
            foregroundColor: _themeColor,
          ),
          child: Text(
            'Register Here',
            style: TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: isCompact ? 13 : 14,
            ),
          ),
        ),
      ],
    );
  }
}
