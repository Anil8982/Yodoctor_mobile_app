import 'package:chroma_kit/chroma_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:yodoctor/core/constants/app_assets.dart';
import 'package:yodoctor/core/constants/log_tags.dart';
import 'package:yodoctor/core/debug/app_logger.dart';
import 'package:yodoctor/core/routes/app_routes.dart';
import 'package:yodoctor/core/theme/app_theme.dart';
import 'package:yodoctor/core/providers/app_role_provider.dart';
import 'package:yodoctor/modules/auth/screens/patient/patient_register_screen.dart';
import 'package:yodoctor/modules/auth/widgets/auth_widgets.dart';
import 'package:yodoctor/modules/auth/widgets/top_bottom_curve_widgets.dart';
import 'package:yodoctor/modules/auth/controllers/patient_auth_controller.dart';
import 'package:yodoctor/modules/auth/widgets/yo_login_text_field.dart';

class PatientLoginScreen extends ConsumerStatefulWidget {
  const PatientLoginScreen({super.key});

  @override
  ConsumerState<PatientLoginScreen> createState() => _PatientLoginScreenState();
}

class _PatientLoginScreenState extends ConsumerState<PatientLoginScreen>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _rememberMe = false;

  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  static const String _subTag = 'PatientLoginScreen';

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    _fadeAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeIn,
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    if (!_formKey.currentState!.validate()) return;

    // 🎯 कीबोर्ड आधी बंद करा भाऊ, जेणेकरून स्पिनर स्मूथ दिसेल
    FocusManager.instance.primaryFocus?.unfocus();

    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    AppLogger.info(
      'Form validated. Submitting payload to AsyncNotifier.',
      tag: LogTags.ui,
      subTag: _subTag,
    );

    ref.read(patientAuthControllerProvider.notifier).signInWithEmail(
      email: email,
      password: password,
      onSuccess: () {
        if (email == "admin@gmail.com" ||
            email.toLowerCase().contains("admin")) {
          ref.read(appRoleProvider.notifier).setRole(AppRole.admin);
          context.go(AppRoutes.adminDashboard);
        } else {
          ref.read(appRoleProvider.notifier).setRole(AppRole.patient);
          context.go(AppRoutes.dashboard);
        }
      },
      onFailure: (errorMessage) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(errorMessage)),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    final authState = ref.watch(patientAuthControllerProvider);
    final bool isProcessing = authState is AsyncLoading;

    return Scaffold(
      backgroundColor: const Color(0xffF8FBF8),
      body: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () {
          FocusManager.instance.primaryFocus?.unfocus();
        },
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: Stack(
            children: [
              TopBackground(color: AppTheme.secondary),
              BottomLeftCircle(color: AppTheme.secondary),
              BottomRightCircle(color: AppTheme.secondary),

              SafeArea(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 16,
                      ),
                      child: Row(
                        children: [
                          GestureDetector(
                            onTap: () => Navigator.pop(context),
                            child: Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                color: colorScheme.onPrimary.transparency(0.25),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Icon(
                                Icons.arrow_back_rounded,
                                color: colorScheme.onPrimary,
                              ),
                            ),
                          ),
                          const Spacer(),
                          Text(
                            'Patient Portal',
                            style: textTheme.titleMedium?.copyWith(
                              color: colorScheme.onPrimary,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const Spacer(),
                          const SizedBox(width: 40),
                        ],
                      ),
                    ),

                    Expanded(
                      child: Stack(
                        clipBehavior: Clip.none,
                        alignment: Alignment.topCenter,
                        children: [
                          Positioned.fill(
                            top: 90,
                            left: 24,
                            right: 24,
                            bottom: 0,
                            child: _buildMainScrollableLoginCard(isProcessing),
                          ),
                          Positioned(
                            top: 10,
                            child: Hero(
                              tag: 'AppLogo',

                              child: DoctorAvatar(
                                color: AppTheme.secondary,
                                icon: Image.asset(
                                  AppAssets.logoV(context),
                                  width: 90,
                                  height: 90,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMainScrollableLoginCard(bool isProcessing) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    return CustomScrollView(
      physics: const BouncingScrollPhysics(),
      slivers: [
        SliverList(
          delegate: SliverChildListDelegate([
            _buildLoginCard(isProcessing),

            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Don't have an account?",
                  style: textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
                TextButton(
                  onPressed: isProcessing ? null : () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const PatientRegisterScreen(),
                      ),
                    );
                  },
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 6),
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  child: Text(
                    "Register Here",
                    style: TextStyle(
                      color: isProcessing ? colorScheme.outline : AppTheme.secondary,
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
                ),
              ],
            ),
          ]),
        ),
      ],
    );
  }

  Widget _buildLoginCard(bool isProcessing) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.transparency(0.04),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Center(
                child: Column(
                  children: [
                    const SizedBox(height: 15),
                    Text(
                      'Welcome Back',
                      style: textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w800,
                        color: colorScheme.onSurface,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Login to book appointments and consult doctors.',
                      style: textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              YoLoginTextField(
                color: AppTheme.secondary,
                hint: 'Email Address',
                prefixIcon: Icons.email_rounded,
                keyboardType: TextInputType.emailAddress,
                controller: _emailController,
                enabled: !isProcessing,
                validator: (v) {
                  if (v == null || v.isEmpty) return 'Enter email address';
                  if (!RegExp(r'\S+@\S+\.\S+').hasMatch(v)) {
                    return 'Enter valid email';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 12),
              YoLoginTextField(
                color: AppTheme.secondary,
                hint: 'Password',
                prefixIcon: Icons.lock_rounded,
                isPassword: true,
                controller: _passwordController,
                enabled: !isProcessing,
                validator: (v) {
                  if (v == null || v.isEmpty) return 'Enter password';
                  if (v.length < 6) {
                    return 'Password must be at least 6 characters';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 6),
              Row(
                children: [
                  Transform.scale(
                    scale: 0.90,
                    child: Checkbox(
                      value: _rememberMe,
                      activeColor: AppTheme.secondary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4),
                      ),
                      onChanged: isProcessing ? null : (value) {
                        setState(() {
                          _rememberMe = value!;
                        });
                      },
                    ),
                  ),
                  Text(
                    'Remember me',
                    style: textTheme.bodySmall?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const Spacer(),
                  TextButton(
                    onPressed: isProcessing ? null : () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Forgot password feature coming soon'),
                        ),
                      );
                    },
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.zero,
                      minimumSize: Size.zero,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    child: Text(
                      'Forgot Password?',
                      style: textTheme.bodySmall?.copyWith(
                        color: isProcessing ? colorScheme.outline : AppTheme.secondary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              YoPrimaryButton(
                label: 'Login as Patient',
                color: AppTheme.secondary,
                isLoading: isProcessing,
                onTap: isProcessing ? null : () => _handleLogin(),
              ),
              const SizedBox(height: 16),
              buildDividerWithText(context, 'OR'),
              const SizedBox(height: 16),
              _buildSocialButton(
                context: context,
                icon: Image.asset(AppAssets.google, height: 20),
                label: 'Continue with Google',
                isLoading: isProcessing, // 🎯 स्पिनर मॅनेजमेंट पॅरामीटर
                onTap: isProcessing
                    ? null
                    : () {
                  FocusManager.instance.primaryFocus?.unfocus(); // Close keyboard
                  AppLogger.info(
                    'Google button click event received',
                    tag: LogTags.ui,
                    subTag: _subTag,
                  );
                  ref
                      .read(patientAuthControllerProvider.notifier)
                      .signInWithGoogle(
                    onSuccess: (user) {
                      AppLogger.highlight(
                        'OAuth authorization resolved for user: ${user.name}',
                      );
                      ref
                          .read(appRoleProvider.notifier)
                          .setRole(AppRole.patient);
                      context.go(AppRoutes.dashboard);
                    },
                    onCanceled: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            'Google Sign-In was canceled.',
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSocialButton({
    required BuildContext context,
    required Widget icon,
    required String label,
    required VoidCallback? onTap,
    bool isLoading = false, // Added local spinner check
  }) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: onTap,
      child: Container(
        height: 52,
        width: double.infinity,
        decoration: BoxDecoration(
          color: colorScheme.surface,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: colorScheme.outlineVariant),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            isLoading
                ? SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: colorScheme.primary,
              ),
            )
                : icon,
            const SizedBox(width: 12),
            Text(
              isLoading ? 'Connecting...' : label,
              style: textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w600,
                color: isLoading ? colorScheme.outline : colorScheme.onSurface,
              ),
            ),
          ],
        ),
      ),
    );
  }
}