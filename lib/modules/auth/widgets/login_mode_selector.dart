import 'package:flutter/material.dart';

class LoginModeSelector extends StatelessWidget {
  final bool isOtpLogin;
  final ValueChanged<bool> onChanged;
  final Color activeColor;
  final bool enabled;

  const LoginModeSelector({
    super.key,
    required this.isOtpLogin,
    required this.onChanged,
    required this.activeColor,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: isOtpLogin
            ? activeColor.withValues(alpha: 0.08)
            : colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: isOtpLogin
              ? activeColor.withValues(alpha: 0.35)
              : colorScheme.outlineVariant.withValues(alpha: 0.35),
        ),
      ),
      child: Row(
        children: [
          SizedBox(
            height: 20,
            width: 20,
            child: Checkbox(
              value: isOtpLogin,
              activeColor: activeColor,
              checkColor: Colors.white,
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              visualDensity: VisualDensity.compact,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5),
              ),
              side: BorderSide(
                color: isOtpLogin
                    ? activeColor
                    : colorScheme.outline.withValues(alpha: 0.6),
                width: 1.4,
              ),
              onChanged: enabled ? (val) => onChanged(val ?? false) : null,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: enabled ? () => onChanged(!isOtpLogin) : null,
              child: Text(
                'Login with OTP (No password)',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: isOtpLogin ? activeColor : colorScheme.onSurface,
                  fontWeight: isOtpLogin ? FontWeight.w700 : FontWeight.w500,
                  fontSize: 13,
                ),
              ),
            ),
          ),
          if (isOtpLogin)
            Icon(
              Icons.sms_rounded,
              size: 15,
              color: activeColor,
            ),
        ],
      ),
    );
  }
}
