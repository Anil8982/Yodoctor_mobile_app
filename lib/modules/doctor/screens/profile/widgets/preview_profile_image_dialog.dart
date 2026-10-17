import 'package:flutter/material.dart';
import 'package:yodoctor/modules/widgets/app_dialog.dart';

class PreviewProfileImageDialog {
  static void show(BuildContext context, {required String? imageUrl}) {
    final colorScheme = Theme.of(context).colorScheme;

    AppDialog.show(
      context: context,
      title: 'Profile Image',
      content: Column(
        children: [
          // Align(
          //   alignment: Alignment.topRight,
          //   child: IconButton(
          //     icon: const Icon(
          //       Icons.close_rounded,
          //       color: Colors.white,
          //       size: 28,
          //     ),
          //     onPressed: () => Navigator.pop(context),
          //   ),
          // ),
          // const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Container(
              constraints: const BoxConstraints(maxHeight: 500),
              color: colorScheme.surface,
              child: imageUrl != null && imageUrl.isNotEmpty
                  ? Image.network(
                      imageUrl,
                      fit: BoxFit.contain,
                      errorBuilder: (_, _, _) =>
                          _buildLargeFallbackAvatar(colorScheme),
                    )
                  : _buildLargeFallbackAvatar(colorScheme),
            ),
          ),
        ],
      ),
      icon: Icons.image_rounded,
      confirmLabel: 'Close',
      showCancel: false,
      onConfirm: () {},
    );
  }

  static Widget _buildLargeFallbackAvatar(ColorScheme colorScheme) {
    return Container(
      width: 200,
      height: 200,
      alignment: Alignment.center,
      color: colorScheme.surfaceContainerHighest,
      child: Icon(
        Icons.person_rounded,
        color: colorScheme.onSurfaceVariant,
        size: 100,
      ),
    );
  }
}
