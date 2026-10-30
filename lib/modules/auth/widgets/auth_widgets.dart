import 'package:flutter/material.dart';

class YoPrimaryButton extends StatelessWidget {
  final String label;
  final VoidCallback? onTap;
  final Color? color;
  final bool isLoading;

  const YoPrimaryButton({
    super.key,
    required this.label,
    required this.onTap,
    this.color,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final btnColor = color ?? colorScheme.primary;
    final onButtonColor = colorScheme.onPrimary;

    return SizedBox(
      width: double.infinity,
      height: 54,
      child: ElevatedButton(
        onPressed: isLoading ? null : onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: btnColor,
          foregroundColor: onButtonColor,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
        child: isLoading
            ? SizedBox(
                width: 22,
                height: 22,
                child: CircularProgressIndicator(
                  color: onButtonColor,
                  strokeWidth: 2.5,
                ),
              )
            : Text(
                label,
                style: textTheme.labelLarge?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: onButtonColor,
                ),
              ),
      ),
    );
  }
}