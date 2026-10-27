import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:yodoctor/l10n/app_localizations.dart';

class PatientBottomNav extends StatelessWidget {

  /// Total height occupied by the floating bar from screen bottom including device safe area.
  static double totalBarHeight(BuildContext context) {
    return MediaQuery.of(context).padding.bottom;
  }

  /// Centralized bottom padding to ensure scrollable content on nav pages
  /// dynamically clears the floating nav bar and device safe area.
  static double floatingNavPadding(
    BuildContext context, [
    double extraClearance = 24.0,
  ]) {
    return totalBarHeight(context) + extraClearance;
  }

  const PatientBottomNav({
    super.key,
    required this.currentIndex,
    required this.onTap,
    required this.onCenterButtonTap,
  });

  final int currentIndex;
  final ValueChanged<int> onTap;
  final VoidCallback onCenterButtonTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    final l10n = AppLocalizations.of(context);
    final homeLabel = l10n?.homeTab ?? "Home";
    final certLabel = l10n?.certificatesTab ?? "Certificates";
    final servicesLabel = l10n?.servicesTab ?? "Services";
    final profileLabel = l10n?.myProfileDrawerItem ?? "Profile";

    // Pure Glass Translucent Gradient Colors
    final glassTop = isDark
        ? const Color(0xFF101D22).withValues(alpha: 0.70)
        : Colors.white.withValues(alpha: 0.82);

    final glassBottom = isDark
        ? const Color(0xFF050D10).withValues(alpha: 0.88)
        : const Color(0xFFF0FDFC).withValues(alpha: 0.72);

    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.only(left: 18.0, right: 18.0, bottom: 14.0),
        child: SizedBox(
          height: 68,
          child: DecoratedBox(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(34),
              boxShadow: [
                // Soft Ambient Drop Shadow
                BoxShadow(
                  color: isDark
                      ? Colors.black.withValues(alpha: 0.55)
                      : colorScheme.shadow.withValues(alpha: 0.07),
                  blurRadius: 30,
                  spreadRadius: 2,
                  offset: const Offset(0, 10),
                ),
                // Subtle Teal Rim Glow
                BoxShadow(
                  color: colorScheme.primary.withValues(alpha: isDark ? 0.08 : 0.04),
                  blurRadius: 18,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(34),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 24.0, sigmaY: 24.0),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(34),
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [glassTop, glassBottom],
                    ),
                    border: Border.all(
                      width: 1.2,
                      color: isDark
                          ? Colors.white.withValues(alpha: 0.14)
                          : Colors.white.withValues(alpha: 0.95),
                    ),
                  ),
                  child: Row(
                    children: [
                      // 1. Home
                      Expanded(
                        child: _NavItem(
                          icon: Icons.home_outlined,
                          activeIcon: Icons.home_rounded,
                          label: homeLabel,
                          isSelected: currentIndex == 0,
                          onTap: () => onTap(0),
                        ),
                      ),

                      // 2. Certificates
                      Expanded(
                        child: _NavItem(
                          icon: Icons.wallet_membership_outlined,
                          activeIcon: Icons.wallet_membership_rounded,
                          label: certLabel,
                          isSelected: currentIndex == 1,
                          onTap: () => onTap(1),
                        ),
                      ),

                      // 3. Center QR Button
                      _CenterQRButton(
                        onTap: onCenterButtonTap,
                      ),

                      // 4. Services
                      Expanded(
                        child: _NavItem(
                          icon: Icons.medical_services_outlined,
                          activeIcon: Icons.medical_services_rounded,
                          label: servicesLabel,
                          isSelected: currentIndex == 2,
                          onTap: () => onTap(2),
                        ),
                      ),

                      // 5. Profile
                      Expanded(
                        child: _NavItem(
                          icon: Icons.person_outline_rounded,
                          activeIcon: Icons.person_rounded,
                          label: profileLabel,
                          isSelected: currentIndex == 3,
                          onTap: () => onTap(3),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// -----------------------------------------------------------------------------
// Interactive Navigation Item (Clean, No Dot, Smooth Spring Feedback)
// -----------------------------------------------------------------------------
class _NavItem extends StatefulWidget {
  const _NavItem({
    required this.icon,
    required this.activeIcon,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  final IconData icon;
  final IconData activeIcon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  State<_NavItem> createState() => _NavItemState();
}

class _NavItemState extends State<_NavItem> {
  bool _isPressed = false;

  void _handleTap() {
    HapticFeedback.lightImpact();
    widget.onTap();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    final activeColor = colorScheme.primary;
    final inactiveColor = colorScheme.onSurfaceVariant.withValues(alpha: 0.65);

    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) => setState(() => _isPressed = false),
      onTapCancel: () => setState(() => _isPressed = false),
      onTap: _handleTap,
      behavior: HitTestBehavior.opaque,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Spring scale feedback on tap and selection
          AnimatedScale(
            scale: _isPressed ? 0.90 : (widget.isSelected ? 1.15 : 1.0),
            duration: const Duration(milliseconds: 160),
            curve: Curves.easeOutCubic,
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 200),
              transitionBuilder: (child, animation) {
                return ScaleTransition(
                  scale: animation,
                  child: FadeTransition(opacity: animation, child: child),
                );
              },
              child: Icon(
                widget.isSelected ? widget.activeIcon : widget.icon,
                key: ValueKey<bool>(widget.isSelected),
                size: 24,
                color: widget.isSelected ? activeColor : inactiveColor,
              ),
            ),
          ),
          const SizedBox(height: 4),
          AnimatedDefaultTextStyle(
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeInOut,
            style: TextStyle(
              fontSize: 11,
              fontWeight: widget.isSelected ? FontWeight.w600 : FontWeight.w400,
              color: widget.isSelected ? activeColor : inactiveColor,
              letterSpacing: 0.1,
            ),
            child: Text(
              widget.label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}

// -----------------------------------------------------------------------------
// Ultra-Refined Center QR Action Button
// -----------------------------------------------------------------------------
class _CenterQRButton extends StatefulWidget {
  const _CenterQRButton({required this.onTap});

  final VoidCallback onTap;

  @override
  State<_CenterQRButton> createState() => _CenterQRButtonState();
}

class _CenterQRButtonState extends State<_CenterQRButton> {
  bool _isPressed = false;

  void _handleTap() {
    HapticFeedback.mediumImpact();
    widget.onTap();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) => setState(() => _isPressed = false),
      onTapCancel: () => setState(() => _isPressed = false),
      onTap: _handleTap,
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 6.0),
        child: AnimatedScale(
          scale: _isPressed ? 0.92 : 1.0,
          duration: const Duration(milliseconds: 140),
          curve: Curves.easeOutQuad,
          child: Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: [
                  colorScheme.primary,
                  colorScheme.secondary,
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              border: Border.all(
                color: isDark
                    ? Colors.white.withValues(alpha: 0.22)
                    : Colors.white.withValues(alpha: 0.8),
                width: 1.5,
              ),
              boxShadow: [
                BoxShadow(
                  color: colorScheme.primary.withValues(alpha: 0.38),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: const Center(
              child: Icon(
                Icons.qr_code_scanner_rounded,
                color: Colors.white,
                size: 24,
              ),
            ),
          ),
        ),
      ),
    );
  }
}