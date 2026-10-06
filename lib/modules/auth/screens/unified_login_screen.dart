// import 'package:chroma_kit/chroma_kit.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:go_router/go_router.dart';
//
// import 'package:yodoctor/core/constants/app_assets.dart';
// import 'package:yodoctor/core/constants/log_tags.dart';
// import 'package:yodoctor/core/debug/app_logger.dart';
// import 'package:yodoctor/core/providers/app_role_provider.dart';
// import 'package:yodoctor/core/routes/app_routes.dart';
// import 'package:yodoctor/core/theme/app_theme.dart';
//
// import 'package:yodoctor/modules/auth/controllers/doctor_login_controller.dart';
// import 'package:yodoctor/modules/auth/controllers/patient_auth_controller.dart';
// import 'package:yodoctor/modules/auth/widgets/auth_widgets.dart';
// import 'package:yodoctor/modules/auth/widgets/otp_bottom_sheet.dart';
// import 'package:yodoctor/modules/auth/widgets/top_bottom_curve_widgets.dart';
// import 'package:yodoctor/modules/auth/widgets/yo_login_text_field.dart';
// import 'package:yodoctor/modules/widgets/app_snack_bar.dart';
//
// enum UserRole { doctor, patient }
//
// class UnifiedLoginScreen extends ConsumerStatefulWidget {
//   final UserRole role;
//
//   const UnifiedLoginScreen({
//     super.key,
//     required this.role,
//   });
//
//   @override
//   ConsumerState<UnifiedLoginScreen> createState() => _UnifiedLoginScreenState();
// }
//
// class _UnifiedLoginScreenState extends ConsumerState<UnifiedLoginScreen>
//     with SingleTickerProviderStateMixin {
//   final _formKey = GlobalKey<FormState>();
//
//   final _emailController = TextEditingController();
//   final _passwordController = TextEditingController();
//
//   bool _rememberMe = false;
//
//   late AnimationController _animationController;
//   late Animation<double> _fadeAnimation;
//
//   bool get _isDoctor => widget.role == UserRole.doctor;
//   Color get _themeColor => AppTheme.primary;
//
//   static const String _subTag = 'UnifiedLoginScreen';
//
//   @override
//   void initState() {
//     super.initState();
//
//     _animationController = AnimationController(
//       vsync: this,
//       duration: const Duration(milliseconds: 600),
//     );
//
//     _fadeAnimation = CurvedAnimation(
//       parent: _animationController,
//       curve: Curves.easeIn,
//     );
//
//     _animationController.forward();
//   }
//
//   @override
//   void dispose() {
//     _animationController.dispose();
//     _emailController.dispose();
//     _passwordController.dispose();
//     super.dispose();
//   }
//
//   String _cleanInputIdentifier(String input) {
//     final trimmed = input.trim();
//     if (RegExp(r'[a-zA-Z@]').hasMatch(trimmed)) {
//       return trimmed.toLowerCase();
//     }
//
//     String cleanNumber = trimmed.replaceAll(RegExp(r'[\s\-\(\)+]'), '');
//     if (cleanNumber.startsWith('91') && cleanNumber.length == 12) {
//       cleanNumber = cleanNumber.substring(2);
//     } else if (cleanNumber.startsWith('0') && cleanNumber.length == 11) {
//       cleanNumber = cleanNumber.substring(1);
//     }
//     return cleanNumber;
//   }
//
//   void _processDoctorRedirect(Map<String, dynamic> result) {
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       if (!mounted) return;
//
//       switch (result['redirect']) {
//         case 'resume':
//           context.go(AppRoutes.doctorRegister, extra: result['nextStep']);
//           break;
//         case 'waiting-approval':
//           context.go(AppRoutes.waitingApproval);
//           break;
//         case 'dashboard':
//           ref.read(appRoleProvider.notifier).setRole(AppRole.doctor);
//           context.go(AppRoutes.doctorDashboard);
//           break;
//         default:
//           AppSnackBar.show(
//             message: 'Unknown login response protocol',
//             type: AppSnackBarType.error,
//           );
//       }
//     });
//   }
//
//   Future<void> _handleLogin() async {
//     if (!_formKey.currentState!.validate()) return;
//
//     FocusManager.instance.primaryFocus?.unfocus();
//
//     final identifier = _cleanInputIdentifier(_emailController.text);
//     final password = _passwordController.text.trim();
//
//     AppLogger.info(
//       'Submitting login payload for ${widget.role.name}',
//       tag: LogTags.ui,
//       subTag: _subTag,
//     );
//
//     if (_isDoctor) {
//       await _executeDoctorLogin(identifier, password);
//     } else {
//       await _executePatientLogin(identifier, password);
//     }
//   }
//
//   Future<void> _executeDoctorLogin(String identifier, String password) async {
//     final notifier = ref.read(doctorLoginControllerProvider.notifier);
//     final result = await notifier.login(
//       identifier: identifier,
//       password: password,
//     );
//
//     if (!mounted) return;
//
//     if (result == null) {
//       final state = ref.read(doctorLoginControllerProvider);
//       final errorMsg = state.error?.toString() ?? 'Login failed';
//       AppSnackBar.show(message: errorMsg, type: AppSnackBarType.error);
//       return;
//     }
//
//     if (result['redirect'] == 'otp' || result['requiresOtp'] == true) {
//       _showOtpModal(
//         verificationId: result['verificationId'],
//         channel: result['channel'],
//         mobile: result['mobile'],
//         maskedDestination: result['maskedDestination'],
//         onVerifyOtp: (otp) async {
//           final verifyResult = await notifier.verifyOtp(
//             otp: otp,
//             verificationId: result['verificationId'],
//             channel: result['channel'],
//             mobile: result['mobile'],
//           );
//           if (verifyResult != null) {
//             _processDoctorRedirect(verifyResult);
//             return true;
//           }
//           final state = ref.read(doctorLoginControllerProvider);
//           return state.error?.toString() ?? 'Invalid or expired OTP';
//         },
//         onResendOtp: () async {
//           final resendResult = await notifier.resendOtp(
//             identifier: identifier,
//             password: password,
//           );
//           if (resendResult != null && resendResult['success'] == true) {
//             return true;
//           }
//           return resendResult?['message'] ?? 'Failed to resend OTP';
//         },
//       );
//       return;
//     }
//
//     _processDoctorRedirect(result);
//   }
//
//   Future<void> _executePatientLogin(String identifier, String password) async {
//     final notifier = ref.read(patientAuthControllerProvider.notifier);
//     final result = await notifier.signInWithEmail(
//       email: identifier,
//       password: password,
//     );
//
//     if (!mounted) return;
//
//     if (result == null) {
//       final state = ref.read(patientAuthControllerProvider);
//       final errorMsg = state.error?.toString() ?? 'Login failed';
//       AppSnackBar.show(message: errorMsg, type: AppSnackBarType.error);
//       return;
//     }
//
//     if (result['redirect'] == 'otp' || result['requiresOtp'] == true) {
//       _showOtpModal(
//         verificationId: result['verificationId'],
//         channel: result['channel'],
//         mobile: result['mobile'],
//         maskedDestination: result['maskedDestination'],
//         onVerifyOtp: (otp) async {
//           final verifyResult = await notifier.verifyOtp(
//             otp: otp,
//             email: identifier,
//             verificationId: result['verificationId'],
//             channel: result['channel'],
//             mobile: result['mobile'],
//           );
//
//           if (verifyResult != null && verifyResult['success'] == true) {
//             ref.read(appRoleProvider.notifier).setRole(AppRole.patient);
//             if (mounted) {
//               context.go(AppRoutes.dashboard);
//             }
//             return true;
//           }
//           final state = ref.read(patientAuthControllerProvider);
//           return state.error?.toString() ?? 'Invalid or expired OTP';
//         },
//         onResendOtp: () async {
//           final resendResult = await notifier.resendOtp(
//             email: identifier,
//             password: password,
//           );
//           if (resendResult != null && resendResult['success'] == true) {
//             return true;
//           }
//           return resendResult?['message'] ?? 'Failed to resend OTP';
//         },
//       );
//       return;
//     }
//
//     ref.read(appRoleProvider.notifier).setRole(AppRole.patient);
//     context.go(AppRoutes.dashboard);
//   }
//
//   void _showOtpModal({
//     required String? verificationId,
//     required String? channel,
//     required String? mobile,
//     required String? maskedDestination,
//     required OtpVerifyCallback onVerifyOtp,
//     required OtpResendCallback onResendOtp,
//   }) {
//     OtpBottomSheet.show(
//       context: context,
//       verificationId: verificationId,
//       channel: channel,
//       mobile: mobile,
//       maskedDestination: maskedDestination,
//       primaryColor: _themeColor,
//       onVerify: onVerifyOtp,
//       onResend: onResendOtp,
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final colorScheme = Theme.of(context).colorScheme;
//     final textTheme = Theme.of(context).textTheme;
//
//     final isProcessing = _isDoctor
//         ? ref.watch(doctorLoginControllerProvider).isLoading
//         : ref.watch(patientAuthControllerProvider) is AsyncLoading;
//
//     return Scaffold(
//       backgroundColor: colorScheme.surfaceContainer,
//       body: GestureDetector(
//         behavior: HitTestBehavior.translucent,
//         onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
//         child: FadeTransition(
//           opacity: _fadeAnimation,
//           child: Container(
//             color: colorScheme.surface,
//             child: SafeArea(
//               top: false,
//               child: LayoutBuilder(
//                 builder: (context, constraints) {
//                   return SingleChildScrollView(
//                     physics: const BouncingScrollPhysics(),
//                     keyboardDismissBehavior:
//                     ScrollViewKeyboardDismissBehavior.onDrag,
//                     child: ConstrainedBox(
//                       constraints: BoxConstraints(
//                         minHeight: constraints.maxHeight,
//                       ),
//                       child: IntrinsicHeight(
//                         child: Stack(
//                           children: [
//                             TopBackground(color: _themeColor),
//                             BottomLeftCircle(color: _themeColor),
//                             BottomRightCircle(color: _themeColor),
//
//                             SafeArea(
//                               child: Column(
//                                 children: [
//                                   Padding(
//                                     padding: const EdgeInsets.symmetric(
//                                       horizontal: 24,
//                                       vertical: 16,
//                                     ),
//                                     child: Row(
//                                       children: [
//                                         GestureDetector(
//                                           onTap: () {
//                                             if (context.canPop()) {
//                                               context.pop();
//                                             } else {
//                                               context.go(AppRoutes.landing);
//                                             }
//                                           },
//                                           child: Container(
//                                             width: 40,
//                                             height: 40,
//                                             decoration: BoxDecoration(
//                                               color: colorScheme.onPrimary
//                                                   .transparency(0.25),
//                                               borderRadius:
//                                               BorderRadius.circular(12),
//                                             ),
//                                             child: Icon(
//                                               Icons.arrow_back_rounded,
//                                               color: colorScheme.onPrimary,
//                                             ),
//                                           ),
//                                         ),
//                                         const Spacer(),
//                                         Text(
//                                           _isDoctor
//                                               ? 'Doctor Portal'
//                                               : 'Patient Portal',
//                                           style: textTheme.titleMedium
//                                               ?.copyWith(
//                                             color: colorScheme.onPrimary,
//                                             fontWeight: FontWeight.w700,
//                                           ),
//                                         ),
//                                         const Spacer(),
//                                         const SizedBox(width: 40),
//                                       ],
//                                     ),
//                                   ),
//
//                                   Padding(
//                                     padding: const EdgeInsets.only(
//                                       left: 24,
//                                       right: 24,
//                                       top: 10,
//                                       bottom: 0,
//                                     ),
//                                     child: Stack(
//                                       clipBehavior: Clip.none,
//                                       alignment: Alignment.topCenter,
//                                       children: [
//                                         Padding(
//                                           padding: const EdgeInsets.only(
//                                             top: 80,
//                                           ),
//                                           child: _buildLoginCard(isProcessing),
//                                         ),
//
//                                         Positioned(
//                                           top: 0,
//                                           child: Hero(
//                                             tag: 'AppLogo',
//                                             child: DoctorAvatar(
//                                               color: _themeColor,
//                                               icon: Image.asset(
//                                                 AppAssets.logoV(context),
//                                                 width: 90,
//                                                 height: 90,
//                                               ),
//                                             ),
//                                           ),
//                                         ),
//                                       ],
//                                     ),
//                                   ),
//                                   const SizedBox(height: 24),
//                                   Row(
//                                     mainAxisAlignment: MainAxisAlignment.center,
//                                     children: [
//                                       Text(
//                                         "Don't have an account?",
//                                         style: textTheme.bodyMedium?.copyWith(
//                                           color: colorScheme.onSurfaceVariant,
//                                         ),
//                                       ),
//                                       TextButton(
//                                         onPressed: isProcessing
//                                             ? null
//                                             : () => context.push(
//                                           _isDoctor
//                                               ? AppRoutes.doctorRegister
//                                               : AppRoutes
//                                               .patientRegister,
//                                         ),
//                                         style: TextButton.styleFrom(
//                                           padding: const EdgeInsets.symmetric(
//                                             horizontal: 6,
//                                           ),
//                                           minimumSize: Size.zero,
//                                           tapTargetSize:
//                                           MaterialTapTargetSize.shrinkWrap,
//                                         ),
//                                         child: Text(
//                                           'Register Here',
//                                           style: TextStyle(
//                                             color: isProcessing
//                                                 ? colorScheme.outline
//                                                 : _themeColor,
//                                             fontWeight: FontWeight.bold,
//                                             fontSize: 15,
//                                           ),
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                   const Spacer(),
//                                   const SizedBox(height: 10),
//                                 ],
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),
//                   );
//                 },
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget _buildLoginCard(bool isProcessing) {
//     final colorScheme = Theme.of(context).colorScheme;
//     final textTheme = Theme.of(context).textTheme;
//
//     return Container(
//       width: double.infinity,
//       decoration: BoxDecoration(
//         color: colorScheme.surface,
//         borderRadius: BorderRadius.circular(24),
//         boxShadow: [
//           BoxShadow(
//             color: AppTheme.black.transparency(0.04),
//             blurRadius: 20,
//             offset: const Offset(0, 8),
//           ),
//         ],
//       ),
//       child: Padding(
//         padding: const EdgeInsets.all(24),
//         child: Form(
//           key: _formKey,
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               Center(
//                 child: Column(
//                   children: [
//                     const SizedBox(height: 15),
//                     Text(
//                       _isDoctor
//                           ? 'Welcome Back,\nDoctor!'
//                           : 'Welcome Back',
//                       textAlign: TextAlign.center,
//                       style: textTheme.titleLarge?.copyWith(
//                         fontWeight: FontWeight.w800,
//                         color: colorScheme.onSurface,
//                       ),
//                     ),
//                     const SizedBox(height: 4),
//                     Text(
//                       _isDoctor
//                           ? 'Login to manage your appointments and patients.'
//                           : 'Login to book appointments and consult doctors.',
//                       textAlign: TextAlign.center,
//                       style: textTheme.bodySmall?.copyWith(
//                         color: colorScheme.onSurfaceVariant,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//               const SizedBox(height: 16),
//
//               YoLoginTextField(
//                 color: _themeColor,
//                 hint: 'Email / Phone No.',
//                 prefixIcon: Icons.email_rounded,
//                 autoDetectPhone: true,
//                 keyboardType: TextInputType.emailAddress,
//                 controller: _emailController,
//                 enabled: !isProcessing,
//                 validator: (v) {
//                   final raw = v?.trim() ?? '';
//
//                   if (raw.isEmpty) {
//                     return 'Enter email address or phone no.';
//                   }
//
//                   if (RegExp(r'[a-zA-Z@]').hasMatch(raw)) {
//                     final emailRegex = RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$');
//                     if (!emailRegex.hasMatch(raw)) {
//                       return 'Enter valid email address';
//                     }
//                     return null;
//                   }
//
//                   String cleanNumber =
//                   raw.replaceAll(RegExp(r'[\s\-\(\)]'), '');
//                   if (cleanNumber.startsWith('+91')) {
//                     cleanNumber = cleanNumber.substring(3);
//                   } else if (cleanNumber.startsWith('91') &&
//                       cleanNumber.length == 12) {
//                     cleanNumber = cleanNumber.substring(2);
//                   } else if (cleanNumber.startsWith('0') &&
//                       cleanNumber.length == 11) {
//                     cleanNumber = cleanNumber.substring(1);
//                   }
//
//                   if (!RegExp(r'^[6-9]\d{9}$').hasMatch(cleanNumber)) {
//                     return 'Enter valid 10-digit phone number';
//                   }
//
//                   return null;
//                 },
//               ),
//
//               const SizedBox(height: 12),
//
//               YoLoginTextField(
//                 color: _themeColor,
//                 hint: 'Password',
//                 prefixIcon: Icons.lock_rounded,
//                 isPassword: true,
//                 controller: _passwordController,
//                 enabled: !isProcessing,
//                 validator: (v) {
//                   if (v == null || v.isEmpty) return 'Enter password';
//                   if (v.length < 6) {
//                     return 'Password must be at least 6 characters';
//                   }
//                   return null;
//                 },
//               ),
//
//               const SizedBox(height: 6),
//
//               Row(
//                 children: [
//                   Transform.scale(
//                     scale: 0.90,
//                     child: Checkbox(
//                       value: _rememberMe,
//                       activeColor: _themeColor,
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(4),
//                       ),
//                       onChanged: isProcessing
//                           ? null
//                           : (value) {
//                         setState(() {
//                           _rememberMe = value!;
//                         });
//                       },
//                     ),
//                   ),
//                   Text(
//                     'Remember me',
//                     style: textTheme.bodySmall?.copyWith(
//                       color: colorScheme.onSurfaceVariant,
//                     ),
//                   ),
//                   const Spacer(),
//                   TextButton(
//                     onPressed: isProcessing
//                         ? null
//                         : () {
//                       AppSnackBar.show(
//                         message: 'Forgot password feature coming soon',
//                         type: AppSnackBarType.info,
//                       );
//                     },
//                     style: TextButton.styleFrom(
//                       padding: EdgeInsets.zero,
//                       minimumSize: Size.zero,
//                       tapTargetSize: MaterialTapTargetSize.shrinkWrap,
//                     ),
//                     child: Text(
//                       'Forgot Password?',
//                       style: textTheme.bodySmall?.copyWith(
//                         color: isProcessing
//                             ? colorScheme.outline
//                             : _themeColor,
//                         fontWeight: FontWeight.w600,
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//
//               const SizedBox(height: 12),
//
//               YoPrimaryButton(
//                 label: _isDoctor ? 'Login as Doctor' : 'Login as Patient',
//                 color: _themeColor,
//                 isLoading: isProcessing,
//                 onTap: isProcessing ? null : _handleLogin,
//               ),
//
//               // Google Auth only for Patient
//               if (!_isDoctor) ...[
//                 const SizedBox(height: 16),
//                 buildDividerWithText(context, 'OR'),
//                 const SizedBox(height: 16),
//                 _buildSocialButton(
//                   context: context,
//                   icon: Image.asset(AppAssets.google, height: 20),
//                   label: 'Continue with Google',
//                   isLoading: isProcessing,
//                   onTap: isProcessing ? null : _handleGoogleSignIn,
//                 ),
//               ],
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   String _getGoogleAuthErrorMessage(dynamic error) {
//     final errStr = error.toString().toLowerCase();
//
//     // User cancelled account selection (no need to show an angry red error)
//     if (errStr.contains('cancel') ||
//         errStr.contains('sign_in_canceled') ||
//         errStr.contains('user cancelled')) {
//       return '';
//     }
//
//     // Network connection problems
//     if (errStr.contains('network') ||
//         errStr.contains('socketexception') ||
//         errStr.contains('connection refused') ||
//         errStr.contains('timeout')) {
//       return 'Unable to connect. Please check your internet connection and try again.';
//     }
//
//     // Google configuration / Play services mismatch
//     if (errStr.contains('api_not_connected') ||
//         errStr.contains('developer_error') ||
//         errStr.contains('10') ||
//         errStr.contains('12500')) {
//       return 'Google Sign-In is temporarily unavailable. Please try using email and password.';
//     }
//
//     // Account disabled or restricted
//     if (errStr.contains('account_disabled') || errStr.contains('blocked')) {
//       return 'Your Google account seems to be restricted. Please contact support.';
//     }
//
//     // Generic fallback
//     return 'Could not sign in with Google. Please try again.';
//   }
//
//   Future<void> _handleGoogleSignIn() async {
//     FocusManager.instance.primaryFocus?.unfocus();
//     AppLogger.info(
//       'Google button click event received',
//       tag: LogTags.ui,
//       subTag: _subTag,
//     );
//
//     try {
//       final user = await ref
//           .read(patientAuthControllerProvider.notifier)
//           .signInWithGoogle();
//
//       if (!mounted) return;
//
//       if (user != null) {
//         AppLogger.highlight('OAuth authorization resolved for user: ${user.name}');
//         ref.read(appRoleProvider.notifier).setRole(AppRole.patient);
//         context.go(AppRoutes.dashboard);
//       } else {
//         final authState = ref.read(patientAuthControllerProvider);
//
//         if (authState.hasError) {
//           final message = _getGoogleAuthErrorMessage(authState.error);
//           if (message.isNotEmpty && mounted) {
//             AppSnackBar.show(
//               message: message,
//               type: AppSnackBarType.error,
//             );
//           }
//         }
//       }
//     } catch (e, st) {
//       AppLogger.error(
//         'Unhandled Google Sign-In exception',
//         tag: LogTags.ui,
//         subTag: _subTag,
//         error: e,
//         stackTrace: st,
//       );
//
//       if (!mounted) return;
//
//       final message = _getGoogleAuthErrorMessage(e);
//       if (message.isNotEmpty) {
//         AppSnackBar.show(
//           message: message,
//           type: AppSnackBarType.error,
//         );
//       }
//     }
//   }
//
//
//   Widget _buildSocialButton({
//     required BuildContext context,
//     required Widget icon,
//     required String label,
//     required VoidCallback? onTap,
//     bool isLoading = false,
//   }) {
//     final colorScheme = Theme.of(context).colorScheme;
//     final textTheme = Theme.of(context).textTheme;
//
//     return InkWell(
//       borderRadius: BorderRadius.circular(14),
//       onTap: onTap,
//       child: Container(
//         height: 52,
//         width: double.infinity,
//         decoration: BoxDecoration(
//           color: colorScheme.surface,
//           borderRadius: BorderRadius.circular(14),
//           border: Border.all(color: colorScheme.outlineVariant),
//         ),
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             isLoading
//                 ? SizedBox(
//               width: 20,
//               height: 20,
//               child: CircularProgressIndicator(
//                 strokeWidth: 2,
//                 color: colorScheme.primary,
//               ),
//             )
//                 : icon,
//             const SizedBox(width: 12),
//             Text(
//               isLoading ? 'Connecting...' : label,
//               style: textTheme.titleSmall?.copyWith(
//                 fontWeight: FontWeight.w600,
//                 color: isLoading ? colorScheme.outline : colorScheme.onSurface,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

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
import 'package:yodoctor/modules/auth/widgets/otp_bottom_sheet.dart';
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

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  // bool _rememberMe = false;

  late final AnimationController _animController;
  late final Animation<double> _fadeAnimation;
  late final Animation<Offset> _slideAnimation;

  bool get _isDoctor => widget.role == UserRole.doctor;
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
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  String _cleanInputIdentifier(String input) {
    final trimmed = input.trim();
    if (RegExp(r'[a-zA-Z@]').hasMatch(trimmed)) {
      return trimmed.toLowerCase();
    }

    String cleanNumber = trimmed.replaceAll(RegExp(r'[\s\-\(\)+]'), '');
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
          AppSnackBar.show(
            message: 'Unknown login response protocol',
            type: AppSnackBarType.error,
          );
      }
    });
  }

  Future<void> _handleLogin() async {
    if (!_formKey.currentState!.validate()) return;

    FocusManager.instance.primaryFocus?.unfocus();

    final identifier = _cleanInputIdentifier(_emailController.text);
    final password = _passwordController.text.trim();

    AppLogger.info(
      'Submitting login payload for ${widget.role.name}',
      tag: LogTags.ui,
      subTag: _subTag,
    );

    if (_isDoctor) {
      await _executeDoctorLogin(identifier, password);
    } else {
      await _executePatientLogin(identifier, password);
    }
  }

  Future<void> _executeDoctorLogin(String identifier, String password) async {
    final notifier = ref.read(doctorLoginControllerProvider.notifier);
    final result = await notifier.login(
      identifier: identifier,
      password: password,
    );

    if (!mounted) return;

    if (result == null) {
      final state = ref.read(doctorLoginControllerProvider);
      final errorMsg = state.error?.toString() ?? 'Login failed';
      AppSnackBar.show(message: errorMsg, type: AppSnackBarType.error);
      return;
    }

    if (result['redirect'] == 'otp' || result['requiresOtp'] == true) {
      _showOtpModal(
        verificationId: result['verificationId'],
        channel: result['channel'],
        mobile: result['mobile'],
        maskedDestination: result['maskedDestination'],
        onVerifyOtp: (otp) async {
          final verifyResult = await notifier.verifyOtp(
            otp: otp,
            verificationId: result['verificationId'],
            channel: result['channel'],
            mobile: result['mobile'],
          );
          if (verifyResult != null) {
            _processDoctorRedirect(verifyResult);
            return true;
          }
          final state = ref.read(doctorLoginControllerProvider);
          return state.error?.toString() ?? 'Invalid or expired OTP';
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

  Future<void> _executePatientLogin(String identifier, String password) async {
    final notifier = ref.read(patientAuthControllerProvider.notifier);
    final result = await notifier.signInWithEmail(
      email: identifier,
      password: password,
    );

    if (!mounted) return;

    if (result == null) {
      final state = ref.read(patientAuthControllerProvider);
      final errorMsg = state.error?.toString() ?? 'Login failed';
      AppSnackBar.show(message: errorMsg, type: AppSnackBarType.error);
      return;
    }

    if (result['redirect'] == 'otp' || result['requiresOtp'] == true) {
      _showOtpModal(
        verificationId: result['verificationId'],
        channel: result['channel'],
        mobile: result['mobile'],
        maskedDestination: result['maskedDestination'],
        onVerifyOtp: (otp) async {
          final verifyResult = await notifier.verifyOtp(
            otp: otp,
            email: identifier,
            verificationId: result['verificationId'],
            channel: result['channel'],
            mobile: result['mobile'],
          );

          if (verifyResult != null && verifyResult['success'] == true) {
            ref.read(appRoleProvider.notifier).setRole(AppRole.patient);
            if (mounted) {
              context.go(AppRoutes.dashboard);
            }
            return true;
          }
          final state = ref.read(patientAuthControllerProvider);
          return state.error?.toString() ?? 'Invalid or expired OTP';
        },
        onResendOtp: () async {
          final resendResult = await notifier.resendOtp(
            email: identifier,
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

  void _showOtpModal({
    required String? verificationId,
    required String? channel,
    required String? mobile,
    required String? maskedDestination,
    required OtpVerifyCallback onVerifyOtp,
    required OtpResendCallback onResendOtp,
  }) {
    final colorScheme = Theme.of(context).colorScheme;
    OtpBottomSheet.show(
      context: context,
      verificationId: verificationId,
      channel: channel,
      mobile: mobile,
      maskedDestination: maskedDestination,
      primaryColor: colorScheme.primary,
      onVerify: onVerifyOtp,
      onResend: onResendOtp,
    );
  }

  String _getGoogleAuthErrorMessage(dynamic error) {
    final errStr = error.toString().toLowerCase();

    if (errStr.contains('cancel') ||
        errStr.contains('sign_in_canceled') ||
        errStr.contains('user cancelled')) {
      return '';
    }

    if (errStr.contains('network') ||
        errStr.contains('socketexception') ||
        errStr.contains('connection refused') ||
        errStr.contains('timeout')) {
      return 'Unable to connect. Please check your internet connection.';
    }

    if (errStr.contains('api_not_connected') ||
        errStr.contains('developer_error') ||
        errStr.contains('10') ||
        errStr.contains('12500')) {
      return 'Google Sign-In is unavailable. Please try email and password.';
    }

    if (errStr.contains('account_disabled') || errStr.contains('blocked')) {
      return 'Your Google account seems to be restricted. Please contact support.';
    }

    return 'Could not sign in with Google. Please try again.';
  }

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

        if (authState.hasError) {
          final message = _getGoogleAuthErrorMessage(authState.error);
          if (message.isNotEmpty && mounted) {
            AppSnackBar.show(message: message, type: AppSnackBarType.error);
          }
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

      final message = _getGoogleAuthErrorMessage(e);
      if (message.isNotEmpty) {
        AppSnackBar.show(message: message, type: AppSnackBarType.error);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
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
            // Ambient Material 3 Mesh Background
            _buildAmbientMeshBackground(colorScheme),

            SafeArea(
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: SlideTransition(
                  position: _slideAnimation,
                  child: CustomScrollView(
                    physics: const BouncingScrollPhysics(),
                    slivers: [
                      // Modern Glass App Bar
                      SliverToBoxAdapter(
                        child: _buildTopBar(context, colorScheme, theme),
                      ),

                      // Main Login Container
                      SliverPadding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 12,
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
                              ),
                            ),
                          ),
                        ),
                      ),

                      // Bottom Register Action Link
                      SliverFillRemaining(
                        hasScrollBody: false,
                        child: Align(
                          alignment: Alignment.bottomCenter,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 24),
                            child: _buildRegisterFooter(
                              context,
                              colorScheme,
                              theme,
                              isProcessing,
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
          // Top ambient bloom
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
                    colorScheme.primaryContainer.withValues(alpha: 0.45),
                    colorScheme.primaryContainer.withValues(alpha: 0.0),
                  ],
                ),
              ),
            ),
          ),
          // Bottom soft tertiary glow
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
                    colorScheme.tertiaryContainer.withValues(alpha: 0.35),
                    colorScheme.tertiaryContainer.withValues(alpha: 0.0),
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
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
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
              minimumSize: const Size(40, 40),
              padding: EdgeInsets.zero,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: BorderSide(
                  color: colorScheme.outlineVariant.withValues(alpha: 0.4),
                  width: 1,
                ),
              ),
            ),
            icon: const Icon(Icons.arrow_back_rounded, size: 20),
          ),

          // Portal Tag
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: BoxDecoration(
              color: colorScheme.primaryContainer.withValues(alpha: 0.6),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: colorScheme.primary.withValues(alpha: 0.15),
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  _isDoctor
                      ? Icons.medical_services_rounded
                      : Icons.person_rounded,
                  size: 15,
                  color: colorScheme.primary,
                ),
                const SizedBox(width: 6),
                Text(
                  _isDoctor ? 'Doctor Portal' : 'Patient Portal',
                  style: theme.textTheme.labelMedium?.copyWith(
                    color: colorScheme.onPrimaryContainer,
                    fontWeight: FontWeight.w700,
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
  ) {
    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(
          color: colorScheme.outlineVariant.withValues(alpha: 0.5),
        ),
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.withValues(alpha: 0.05),
            blurRadius: 24,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      padding: const EdgeInsets.all(24),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Center Identity / Brand Icon
            Center(
              child: Hero(
                tag: 'AppLogo',
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        colorScheme.primary.withValues(alpha: 0.85),
                        colorScheme.secondary.withValues(alpha: 0.25),
                      ],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: AppTheme.black.withValues(alpha: 0.18),
                        blurRadius: 18,
                        offset: const Offset(0, 7),
                      ),
                      BoxShadow(
                        color: Colors.white.withValues(alpha: 0.35),
                        blurRadius: 10,
                        offset: const Offset(-2, -2),
                      ),
                    ],
                  ),
                  child: Container(
                    width: 84,
                    height: 84,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    padding: const EdgeInsets.all(3),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(50),
                      child: Image.asset(
                        AppAssets.logoLightV,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 18),

            // Header Titles
            Text(
              _isDoctor ? 'Welcome Back, Doctor' : 'Welcome to YoDoctor',
              textAlign: TextAlign.center,
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w800,
                color: colorScheme.onSurface,
                letterSpacing: -0.4,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              _isDoctor
                  ? 'Sign in to access your appointments and patient records.'
                  : 'Sign in to consult certified specialists and manage health reports.',
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 28),

            // Identifier Input Field
            YoLoginTextField(
              color: colorScheme.primary,
              hint: 'Email or Mobile Number',
              prefixIcon: Icons.alternate_email_rounded,
              autoDetectPhone: true,
              keyboardType: TextInputType.emailAddress,
              controller: _emailController,
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

                String clean = raw.replaceAll(RegExp(r'[\s\-\(\)]'), '');
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
            const SizedBox(height: 6),

            // Password Input Field
            YoLoginTextField(
              color: colorScheme.primary,
              hint: 'Password',
              prefixIcon: Icons.lock_outline_rounded,
              isPassword: true,
              controller: _passwordController,
              enabled: !isProcessing,
              validator: (v) {
                if (v == null || v.isEmpty) return 'Enter your password';
                if (v.length < 6) {
                  return 'Password must be at least 6 characters';
                }
                return null;
              },
            ),
            const SizedBox(height: 2),

            // Remember Me and Forgot Password
            Row(
              children: [
                // SizedBox(
                //   height: 24,
                //   width: 24,
                //   child: Checkbox(
                //     value: _rememberMe,
                //     activeColor: colorScheme.primary,
                //     checkColor: colorScheme.onPrimary,
                //     shape: RoundedRectangleBorder(
                //       borderRadius: BorderRadius.circular(6),
                //     ),
                //     side: BorderSide(
                //       color: colorScheme.outline.withValues(alpha: 0.7),
                //       width: 1.5,
                //     ),
                //     onChanged: isProcessing
                //         ? null
                //         : (val) => setState(() => _rememberMe = val ?? false),
                //   ),
                // ),
                // const SizedBox(width: 8),
                // Text(
                //   'Remember me',
                //   style: theme.textTheme.bodyMedium?.copyWith(
                //     color: colorScheme.onSurfaceVariant,
                //     fontSize: 13.5,
                //   ),
                // ),
                const Spacer(),
                TextButton(
                  onPressed: isProcessing
                      ? null
                      : () {
                          AppSnackBar.show(
                            message:
                                'Password reset instructions will be sent shortly',
                            type: AppSnackBarType.info,
                          );
                        },
                  style: TextButton.styleFrom(
                    visualDensity: VisualDensity.compact,
                    foregroundColor: colorScheme.primary,
                    textStyle: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                  child: const Text('Forgot Password?'),
                ),
              ],
            ),
            const SizedBox(height: 8),

            // Primary Login CTA
            SizedBox(
              height: 52,
              child: FilledButton(
                onPressed: isProcessing ? null : _handleLogin,
                style: FilledButton.styleFrom(
                  backgroundColor: colorScheme.primary,
                  foregroundColor: colorScheme.onPrimary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 0,
                ),
                child: isProcessing
                    ? SizedBox(
                        height: 22,
                        width: 22,
                        child: CircularProgressIndicator(
                          strokeWidth: 2.2,
                          color: colorScheme.onPrimary,
                        ),
                      )
                    : Text(
                        _isDoctor ? 'Sign In as Doctor' : 'Sign In as Patient',
                        style: const TextStyle(
                          fontSize: 15.5,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.2,
                        ),
                      ),
              ),
            ),

            // Google OAuth (Exclusive to Patients)
            if (!_isDoctor) ...[
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: Divider(
                      color: colorScheme.outlineVariant.withValues(alpha: 0.5),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 14),
                    child: Text(
                      'OR',
                      style: theme.textTheme.labelMedium?.copyWith(
                        color: colorScheme.onSurfaceVariant.withValues(
                          alpha: 0.7,
                        ),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Divider(
                      color: colorScheme.outlineVariant.withValues(alpha: 0.5),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              _buildGoogleSocialButton(colorScheme, theme, isProcessing),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildGoogleSocialButton(
    ColorScheme colorScheme,
    ThemeData theme,
    bool isProcessing,
  ) {
    return SizedBox(
      height: 52,
      child: OutlinedButton(
        onPressed: isProcessing ? null : _handleGoogleSignIn,
        style: OutlinedButton.styleFrom(
          backgroundColor: colorScheme.surface,
          foregroundColor: colorScheme.onSurface,
          side: BorderSide(
            color: colorScheme.outlineVariant.withValues(alpha: 0.8),
            width: 1.2,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(AppAssets.google, height: 20),
            const SizedBox(width: 12),
            Text(
              'Continue with Google',
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w600,
                color: colorScheme.onSurface,
              ),
            ),
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
  ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "Don't have an account?",
          style: theme.textTheme.bodyMedium?.copyWith(
            color: colorScheme.onSurfaceVariant,
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
            foregroundColor: colorScheme.primary,
          ),
          child: const Text(
            'Register Here',
            style: TextStyle(fontWeight: FontWeight.w700),
          ),
        ),
      ],
    );
  }
}
