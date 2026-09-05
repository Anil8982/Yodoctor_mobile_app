import 'package:chroma_kit/chroma_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:yodoctor/core/constants/app_assets.dart';
import 'package:yodoctor/core/routes/app_routes.dart';
import 'package:yodoctor/core/theme/app_theme.dart';

import 'package:yodoctor/modules/auth/widgets/auth_widgets.dart';
import 'package:yodoctor/modules/auth/widgets/top_bottom_curve_widgets.dart';
import 'package:yodoctor/modules/auth/widgets/yo_login_text_field.dart';
import 'package:yodoctor/modules/widgets/app_snack_bar.dart';
import '../../controllers/doctor_login_controller.dart';

class DoctorLoginScreen extends ConsumerStatefulWidget {
  const DoctorLoginScreen({super.key});

  @override
  ConsumerState<DoctorLoginScreen> createState() => _DoctorLoginScreenState();
}

class _DoctorLoginScreenState extends ConsumerState<DoctorLoginScreen>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _rememberMe = false;

  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

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

    final notifier = ref.read(doctorLoginControllerProvider.notifier);

    final result = await notifier.login(
      identifier: _emailController.text.trim(),
      password: _passwordController.text.trim(),
    );

    if (!mounted) return;

    if (result == null) {
      final loginState = ref.read(doctorLoginControllerProvider);
      final errorMsg = loginState.error?.toString() ?? "Login Failed";
      AppSnackBar.show(message: errorMsg, type: AppSnackBarType.error);
      return;
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;

      switch (result["redirect"]) {
        case "resume":
          context.go(AppRoutes.doctorRegister, extra: result["nextStep"]);
          break;

        case "waiting-approval":
          context.go(AppRoutes.waitingApproval);
          break;

        case "dashboard":
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

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    // 🎯 FIXED: Reactive tracking synced with riverpod state emission clocks
    final loginState = ref.watch(doctorLoginControllerProvider);

    return Scaffold(
      backgroundColor: colorScheme.surfaceContainer,
      body: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: Container(
            color: colorScheme.surface,
            child: SafeArea(
              top: false,
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    keyboardDismissBehavior:
                        ScrollViewKeyboardDismissBehavior.onDrag,
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        minHeight: constraints.maxHeight,
                      ),
                      child: IntrinsicHeight(
                        child: Stack(
                          children: [
                            TopBackground(color: AppTheme.primary),
                            BottomLeftCircle(color: AppTheme.primary),
                            BottomRightCircle(color: AppTheme.primary),

                            SafeArea(
                              child: Column(
                                children: [
                                  Hero(
                                    tag: 'docAppBar',
                                    child: Padding(
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
                                                color: colorScheme.onPrimary
                                                    .transparency(0.25),
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                              ),
                                              child: Icon(
                                                Icons.arrow_back_rounded,
                                                color: colorScheme.onPrimary,
                                              ),
                                            ),
                                          ),
                                          const Spacer(),
                                          Text(
                                            'Doctor Portal',
                                            style: textTheme.titleMedium
                                                ?.copyWith(
                                                  color: colorScheme.onPrimary,
                                                  fontWeight: FontWeight.w700,
                                                ),
                                          ),
                                          const Spacer(),
                                          const SizedBox(width: 40),
                                        ],
                                      ),
                                    ),
                                  ),

                                  Padding(
                                    padding: const EdgeInsets.only(
                                      left: 24,
                                      right: 24,
                                      top: 10,
                                      bottom: 0,
                                    ),
                                    child: Stack(
                                      clipBehavior: Clip.none,
                                      alignment: Alignment.topCenter,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.only(
                                            top: 80,
                                          ),
                                          child: _buildLoginCard(
                                            loginState.isLoading,
                                          ),
                                        ),

                                        Positioned(
                                          top: 0,
                                          child: Hero(
                                            tag: 'AppLogo',
                                            child: DoctorAvatar(
                                              color: AppTheme.primary,
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
                                        onPressed: () => context.push(
                                          AppRoutes.doctorRegister,
                                        ),
                                        style: TextButton.styleFrom(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 6,
                                          ),
                                          minimumSize: Size.zero,
                                          tapTargetSize:
                                              MaterialTapTargetSize.shrinkWrap,
                                        ),
                                        child: Text(
                                          "Register Here",
                                          style: TextStyle(
                                            color: AppTheme.primary,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 15,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const Spacer(),

                                  const SizedBox(height: 10),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLoginCard(bool isLoading) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: AppTheme.black.transparency(0.04),
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
                      'Welcome Back,\nDoctor!',
                      style: textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w800,
                        color: colorScheme.onSurface,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Login to manage your appointments and patients.',
                      style: textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              YoLoginTextField(
                color: AppTheme.primary,
                hint: 'Email / Medical ID',
                prefixIcon: Icons.email_rounded,
                keyboardType: TextInputType.emailAddress,
                controller: _emailController,
                validator: (v) {
                  if (v == null || v.isEmpty) {
                    return 'Enter doctor email';
                  }
                  if (!RegExp(r'\S+@\S+\.\S+').hasMatch(v)) {
                    return 'Enter valid email';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 12),

              YoLoginTextField(
                color: AppTheme.primary,
                hint: 'Password',
                prefixIcon: Icons.lock_rounded,
                isPassword: true,
                controller: _passwordController,
                validator: (v) {
                  if (v == null || v.isEmpty) {
                    return 'Enter password';
                  }
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
                      activeColor: AppTheme.primary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4),
                      ),
                      onChanged: (value) {
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
                    onPressed: () {
                      AppSnackBar.show(
                        message: 'Forgot password feature coming soon',
                        type: AppSnackBarType.info,
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
                        color: AppTheme.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              YoPrimaryButton(
                label: 'Login as Doctor',
                color: AppTheme.primary,
                isLoading: isLoading,
                onTap: isLoading ? null : _handleLogin,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
