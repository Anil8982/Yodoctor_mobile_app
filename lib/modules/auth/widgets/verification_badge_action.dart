import 'package:chroma_kit/chroma_kit.dart';
import 'package:flutter/material.dart';
import 'package:yodoctor/core/theme/app_theme.dart';

class VerificationBadgeAction extends StatelessWidget {
  final bool isVerified;
  final bool isLoading;
  final VoidCallback onVerify;
  final Color? primaryColor;
  final String label;
  final String verifiedLabel;
  final IconData icon;

  const VerificationBadgeAction({
    super.key,
    required this.isVerified,
    required this.isLoading,
    required this.onVerify,
    this.primaryColor,
    this.label = 'Verify via OTP',
    this.verifiedLabel = 'Verified Successfully',
    this.icon = Icons.verified_user_outlined,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final effectivePrimaryColor = primaryColor ?? AppTheme.secondary;

    if (isVerified) {
      return Container(
        margin: const EdgeInsets.only(top: 6, bottom: 4),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: AppTheme.yoGreenLight,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: AppTheme.yoGreen.transparency(0.35),
            width: 1,
          ),
        ),
        child: Row(
          children: [
            Icon(
              Icons.check_circle_rounded,
              color: AppTheme.yoGreen,
              size: 16,
            ),
            const SizedBox(width: 8),
            Text(
              verifiedLabel,
              style: textTheme.labelMedium?.copyWith(
                color: AppTheme.yoGreen,
                fontWeight: FontWeight.w700,
              ),
            ),
            const Spacer(),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: AppTheme.yoGreen.transparency(0.15),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                'Verified',
                style: textTheme.labelSmall?.copyWith(
                  color: AppTheme.yoGreen,
                  fontWeight: FontWeight.w700,
                  fontSize: 11,
                ),
              ),
            ),
          ],
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.only(top: 6, bottom: 4),
      child: Align(
        alignment: Alignment.centerRight,
        child: SizedBox(
          height: 38,
          child: OutlinedButton.icon(
            onPressed: isLoading ? null : onVerify,
            icon: isLoading
                ? SizedBox(
                    width: 14,
                    height: 14,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: effectivePrimaryColor,
                    ),
                  )
                : Icon(
                    icon,
                    size: 16,
                    color: effectivePrimaryColor,
                  ),
            label: Text(
              isLoading ? 'Sending OTP...' : label,
              style: textTheme.labelMedium?.copyWith(
                color: effectivePrimaryColor,
                fontWeight: FontWeight.w700,
              ),
            ),
            style: OutlinedButton.styleFrom(
              foregroundColor: effectivePrimaryColor,
              backgroundColor: effectivePrimaryColor.transparency(0.06),
              side: BorderSide(
                color: effectivePrimaryColor.transparency(0.35),
                width: 1.2,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            ),
          ),
        ),
      ),
    );
  }
}

