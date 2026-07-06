import 'package:chroma_kit/chroma_kit.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:yodoctor/core/routes/app_routes.dart';
import 'package:yodoctor/core/theme/app_theme.dart';
import 'package:yodoctor/modules/auth/screens/doctor/doctor_register_screen.dart';
import 'package:yodoctor/modules/auth/widgets/auth_widgets.dart';
import 'package:yodoctor/modules/auth/widgets/top_bottom_curve_widgets.dart';

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

    final emailOrId = _emailController.text.trim();
    final password = _passwordController.text.trim();

    setState(() => _isLoading = true);
    await Future.delayed(const Duration(seconds: 2));
    setState(() => _isLoading = false);

    if (emailOrId.isEmpty || password.isEmpty) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Invalid credentials')));
      return;
    }

    if (!mounted) return;
    Provider.of<AppRoleProvider>(
      context,
      listen: false,
    ).setRole(AppRole.doctor);
    context.go(AppRoutes.doctorDashboard);
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    return Scaffold(
      backgroundColor: const Color(0xffF8FBF8),
      resizeToAvoidBottomInset: false,
      body: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () {
          FocusManager.instance.primaryFocus?.unfocus();
        },
        child: FadeTransition(
          opacity: _fadeAnim,
          child: Stack(
            children: [
              TopBackground(color: AppTheme.primary),
              BottomLeftCircle(color: AppTheme.primary),
              BottomRightCircle(color: AppTheme.primary),

              SafeArea(
                child: Column(
                  children: [
                    _buildTopBar(),

                    const SizedBox(height: 70),

                    Expanded(
                      child: SingleChildScrollView(
                        physics: const BouncingScrollPhysics(),
                        child: Column(
                          children: [
                            Stack(
                              clipBehavior: Clip.none,
                              alignment: Alignment.topCenter,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 25,
                                    vertical: 10,
                                  ),
                                  child: _buildDoctorLoginCard(),
                                ),

                                Positioned(
                                  top: -28,
                                  child: DoctorAvatar(
                                    color: AppTheme.primary,
                                    icon: Icons.medical_services_rounded,
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 10),

                            _buildRegisterSection(),
                          ],
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
    );
  }

  Widget _buildTopBar() {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: colorScheme.onPrimary.withValues(alpha: .25),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                Icons.arrow_back_rounded,
                color: colorScheme.onPrimary,
              ),
            ),
          ),

          const Spacer(),

          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: "yo",
                  style: textTheme.titleLarge?.copyWith(
                    color: colorScheme.onPrimary,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                TextSpan(
                  text: "Doctor",
                  style: textTheme.titleLarge?.copyWith(
                    color: colorScheme.onPrimary,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
          ),

          const Spacer(),
          const SizedBox(width: 40),
        ],
      ),
    );
  }

  Widget _buildDoctorLoginCard() {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Container(
      width: MediaQuery.of(context).size.width * .90,
      // height: MediaQuery.of(context).size.height * .58,
      margin: const EdgeInsets.only(top: 18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: .08),
            blurRadius: 24,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(28),
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(18, 42, 18, 18),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // AuthHeader(
                //   role: 'Patient Portal',
                //   title: 'Welcome Back!',
                //   subtitle: 'Login to book appointments and consult doctors.',
                //   color: AppTheme.secondary,
                //   icon: Icons.person_rounded,
                // ),

                // const SizedBox(height: 16),
                YoLoginTextField(
                  color: AppTheme.primary,
                  hint: "Email / Medical ID",
                  prefixIcon: Icons.email_rounded,
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  validator: (v) {
                    if (v == null || v.isEmpty) {
                      return "Enter doctor email";
                    }

                    if (!RegExp(r'\S+@\S+\.\S+').hasMatch(v)) {
                      return "Enter valid email";
                    }

                    return null;
                  },
                ),

                const SizedBox(height: 15),
                YoLoginTextField(
                  color: AppTheme.primary,
                  hint: "Password",
                  prefixIcon: Icons.lock_rounded,
                  controller: _passwordController,
                  isPassword: true,
                  validator: (v) {
                    if (v == null || v.isEmpty) {
                      return "Enter password";
                    }

                    if (v.length < 6) {
                      return "Password must be at least 6 characters";
                    }

                    return null;
                  },
                ),

                const SizedBox(height: 5),
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
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              'Forgot password feature coming soon',
                            ),
                          ),
                        );
                      },
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

                const SizedBox(height: 5),

                YoPrimaryButton(
                  label: "Login as Doctor",
                  color: AppTheme.primary,
                  isLoading: _isLoading,
                  onTap: _handleLogin,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRegisterSection() {
    final textTheme = Theme.of(context).textTheme;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "Don't have an account?",
          style: textTheme.bodyMedium?.copyWith(color: Colors.grey.shade700),
        ),

        TextButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const DoctorRegisterScreen()),
            );
          },
          style: TextButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            minimumSize: Size.zero,
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
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
    );
  }
}
