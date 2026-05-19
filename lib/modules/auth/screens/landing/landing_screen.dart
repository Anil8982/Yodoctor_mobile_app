import 'package:chroma_kit/chroma_kit.dart';
import 'package:flutter/material.dart';
import 'package:yodoctor/core/theme/app_theme.dart';
import 'package:yodoctor/modules/auth/screens/doctor/doctor_login_screen.dart';
import 'package:yodoctor/modules/auth/screens/patient/patient_login_screen.dart';

class LandingScreen extends StatefulWidget {
  const LandingScreen({super.key});

  @override
  State<LandingScreen> createState() => _LandingScreenState();
}

class _LandingScreenState extends State<LandingScreen> {
  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(gradient: AppTheme.backgroundGradient),
        child: SafeArea(
          top: false,
          child: LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight: constraints.maxHeight,
                  ),
                  child: IntrinsicHeight(
                    child: Column(
                      children: [
                        Container(
                          height: 260,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                colorScheme.secondary.transparency(.8),
                                colorScheme.secondary.transparency(.2),
                              ],
                            ),
                            borderRadius: const BorderRadius.vertical(bottom: Radius.circular(36)),
                            boxShadow: [
                              BoxShadow(
                                color: colorScheme.primary.transparency(0.12),
                                blurRadius: 24,
                                offset: const Offset(0, 10),
                              ),
                            ],
                          ),
                          child: Stack(
                            children: [
                              Positioned(
                                top: -40,
                                right: -40,
                                child: Container(
                                  width: 160,
                                  height: 160,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: colorScheme.onPrimary.transparency(0.08),
                                  ),
                                ),
                              ),
                              Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const SizedBox(height: 28),
                                    Container(
                                      padding: const EdgeInsets.all(16),
                                      decoration: BoxDecoration(
                                        color: colorScheme.onPrimary.transparency(0.12),
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                          color: colorScheme.onPrimary.transparency(0.2),
                                          width: 1.5,
                                        ),
                                      ),
                                      child: Icon(
                                        Icons.medical_services_rounded,
                                        size: 44,
                                        color: colorScheme.onPrimary,
                                      ),
                                    ),
                                    const SizedBox(height: 16),
                                    Image.asset(
                                      'assets/images/Logo.jpg',
                                      height: 52,
                                      fit: BoxFit.contain,
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      'Your health, connected.',
                                      style: textTheme.bodyMedium?.copyWith(
                                        color: colorScheme.onPrimary.transparency(0.85),
                                        fontWeight: FontWeight.w500,
                                        letterSpacing: 0.6,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 24),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 24),
                          child: Column(
                            children: [
                              Text(
                                'Healthcare simplified for everyone',
                                textAlign: TextAlign.center,
                                style: textTheme.headlineSmall?.copyWith(
                                  fontWeight: FontWeight.w800,
                                  color: colorScheme.onSurface,
                                ),
                              ),
                              const SizedBox(height: 16),
                              SizedBox(
                                width: double.infinity,
                                child: Image.asset(
                                  'assets/images/doctor_team.jpg',
                                  height: 160,
                                  fit: BoxFit.contain,
                                ),
                              ),
                            ],
                          ),
                        ),

                        const Spacer(flex: 2),

                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 26),
                          child: Text(
                            'Choose your role to get started with your personalized health journey.',
                            textAlign: TextAlign.center,
                            style: textTheme.titleSmall?.copyWith(
                              color: colorScheme.onSurfaceVariant,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 1.5
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),

                        _GradientButton(
                          height: 78,
                          imageSize: 36,
                          imagePath: 'assets/images/doctorLogo.jpg',
                          title: 'I am a Doctor',
                          subtitle: 'Manage patients & schedules',
                          gradient: AppTheme.doctorGradient,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (_) => const DoctorLoginScreen()),
                            );
                          },
                        ),
                        const SizedBox(height: 14),
                        _GradientButton(
                          height: 78,
                          imageSize: 36,
                          imagePath: 'assets/images/patientlogo.png',
                          title: 'I am a Patient',
                          subtitle: 'Book appointments & track health',
                          gradient: AppTheme.patientGradient,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (_) => const PatientLoginScreen()),
                            );
                          },
                        ),

                        const Spacer(flex: 1),
                        const SizedBox(height: 16),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

class _GradientButton extends StatelessWidget {
  final String imagePath;
  final String title;
  final String subtitle;
  final Gradient gradient;
  final VoidCallback onTap;
  final double height;
  final double imageSize;

  const _GradientButton({
    required this.imagePath,
    required this.title,
    required this.subtitle,
    required this.gradient,
    required this.onTap,
    required this.height,
    required this.imageSize,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Container(
        decoration: BoxDecoration(
          gradient: gradient,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: gradient.colors.first.transparency(0.25),
              blurRadius: 14,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(20),
            splashColor: colorScheme.onPrimary.transparency(0.15),
            highlightColor: Colors.transparent,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18),
              child: SizedBox(
                height: height,
                child: Row(
                  children: [
                    Container(
                      width: imageSize + 12,
                      height: imageSize + 12,
                      decoration: BoxDecoration(
                        color: colorScheme.onPrimary.transparency(0.2),
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Image.asset(
                          imagePath,
                          width: imageSize,
                          height: imageSize,
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            title,
                            style: textTheme.titleMedium?.copyWith(
                              color: colorScheme.onPrimary,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 0.2,
                            ),
                          ),
                          const SizedBox(height: 1),
                          Text(
                            subtitle,
                            style: textTheme.bodySmall?.copyWith(
                              color: colorScheme.onPrimary.transparency(0.75),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Icon(
                      Icons.arrow_forward_ios_rounded,
                      color: colorScheme.onPrimary,
                      size: 18,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}