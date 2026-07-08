import 'package:chroma_kit/chroma_kit.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:yodoctor/core/routes/app_routes.dart';
import 'package:yodoctor/core/theme/app_theme.dart';
import 'package:yodoctor/modules/auth/screens/doctor/doctor_register_screen.dart';
import 'package:yodoctor/modules/auth/widgets/auth_widgets.dart';
import 'package:provider/provider.dart';
import '../../controllers/doctor_login_controller.dart';

class DoctorLoginScreen extends StatefulWidget {
  const DoctorLoginScreen({super.key});

  @override
  State<DoctorLoginScreen> createState() => _DoctorLoginScreenState();
}

class _DoctorLoginScreenState extends State<DoctorLoginScreen>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;
  bool _rememberMe = false;

  late AnimationController _animController;
  late Animation<double> _fadeAnim;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _fadeAnim = CurvedAnimation(parent: _animController, curve: Curves.easeIn);
    _animController.forward();
  }

  @override
  void dispose() {
    _animController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    if (!_formKey.currentState!.validate()) return;

    final controller = context.read<DoctorLoginController>();

    final result = await controller.login(
      identifier: _emailController.text.trim(),
      password: _passwordController.text.trim(),
    );

    if (!mounted) return;

    if (result == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(controller.error ?? "Login Failed")),
      );
      return;
    }

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
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text("Unknown login response")));
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    return Scaffold(
      backgroundColor: colorScheme.surfaceContainer,
      body: Stack(
        children: [
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              height: 200,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    AppTheme.primary,
                    AppTheme.primary.transparency(0.7),
                  ],
                ),
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(40),
                  bottomRight: Radius.circular(40),
                ),
              ),
            ),
          ),
          SafeArea(
            child: FadeTransition(
              opacity: _fadeAnim,
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
                              size: 20,
                            ),
                          ),
                        ),
                        const Spacer(),
                        RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: 'yo',
                                style: textTheme.titleLarge?.copyWith(
                                  fontWeight: FontWeight.w800,
                                  color: colorScheme.onPrimary,
                                ),
                              ),
                              TextSpan(
                                text: 'Doctor',
                                style: textTheme.titleLarge?.copyWith(
                                  fontWeight: FontWeight.w800,
                                  color: colorScheme.onPrimary,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Spacer(),
                        const SizedBox(width: 40),
                      ],
                    ),
                  ),
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: colorScheme.surface,
                      boxShadow: [
                        BoxShadow(
                          color: AppTheme.primary.transparency(0.3),
                          blurRadius: 20,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: Icon(
                      Icons.medical_services_rounded,
                      size: 38,
                      color: AppTheme.primary,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Container(
                        margin: const EdgeInsets.only(top: 8, bottom: 24),
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: colorScheme.surface,
                          borderRadius: BorderRadius.circular(24),
                          boxShadow: [
                            BoxShadow(
                              color: colorScheme.shadow.transparency(0.07),
                              blurRadius: 30,
                              offset: const Offset(0, 8),
                            ),
                          ],
                        ),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              AuthHeader(
                                role: 'Doctor Portal',
                                title: 'Welcome Back,\nDoctor!',
                                subtitle:
                                    'Login to manage your appointments and patients.',
                                color: AppTheme.primary,
                                icon: Icons.medical_services_rounded,
                              ),
                              const SizedBox(height: 28),
                              YoTextField(
                                label: 'Email / Medical ID',
                                hint: 'Enter your email',
                                prefixIcon: Icons.email_rounded,
                                keyboardType: TextInputType.emailAddress,
                                controller: _emailController,
                                validator: (v) {
                                  if (v == null || v.trim().isEmpty) {
                                    return 'Enter email or medical ID';
                                  }
                                  if (v.contains('@') &&
                                      !RegExp(r'\S+@\S+\.\S+').hasMatch(v)) {
                                    return 'Enter valid email';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 18),
                              YoTextField(
                                label: 'Password',
                                hint: 'Enter your password',
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
                              const SizedBox(height: 12),
                              Row(
                                children: [
                                  Transform.scale(
                                    scale: 0.9,
                                    child: Checkbox(
                                      value: _rememberMe,
                                      onChanged: (v) =>
                                          setState(() => _rememberMe = v!),
                                      activeColor: AppTheme.primary,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                    ),
                                  ),
                                  Text(
                                    'Remember me',
                                    style: textTheme.labelLarge?.copyWith(
                                      color: colorScheme.onSurfaceVariant,
                                    ),
                                  ),
                                  const Spacer(),
                                  TextButton(
                                    onPressed: () {
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        const SnackBar(
                                          content: Text(
                                            'Forgot password feature coming soon',
                                          ),
                                        ),
                                      );
                                    },
                                    child: Text(
                                      'Forgot Password?',
                                      style: textTheme.labelLarge?.copyWith(
                                        color: AppTheme.primary,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 20),
                              Consumer<DoctorLoginController>(
                                builder: (_, controller, __) {
                                  return YoPrimaryButton(
                                    label: 'Login as Doctor',
                                    onTap: _handleLogin,
                                    color: AppTheme.primary,
                                    isLoading: controller.isLoading,
                                  );
                                },
                              ),
                              const SizedBox(height: 28),
                              Container(
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: AppTheme.primaryLight,
                                  borderRadius: BorderRadius.circular(14),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      "Don't have an account? ",
                                      style: textTheme.labelMedium?.copyWith(
                                        color: colorScheme.onSurfaceVariant,
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () =>
                                          context.go(AppRoutes.doctorRegister),
                                      child: Text(
                                        'Register here',
                                        style: textTheme.labelMedium?.copyWith(
                                          fontWeight: FontWeight.w700,
                                          color: AppTheme.primary,
                                          decoration: TextDecoration.underline,
                                          decorationColor: AppTheme.primary,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
