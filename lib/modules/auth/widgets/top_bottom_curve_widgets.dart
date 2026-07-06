import 'package:flutter/material.dart';
import 'package:yodoctor/core/theme/app_theme.dart';

class DoctorAvatar extends StatelessWidget {
  final Color color;
  final IconData icon;

  const DoctorAvatar({super.key, required this.color, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 80,
      height: 80,
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white, width: 4),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: .12),
            blurRadius: 14,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(5),
        child: Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: color.withValues(alpha: .10),
          ),
          child: Icon(icon, size: 34, color: color),
        ),
      ),
    );
  }
}

class TopBackground extends StatelessWidget {
  final Color color;

  const TopBackground({super.key, required this.color});
  @override
  Widget build(BuildContext context) {
    final scale = MediaQuery.of(context).size.width / 393;

    return SizedBox(
      height: 220 * scale,
      width: double.infinity,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          /// Back Circle
          Positioned(
            top: -230 * scale,
            left: -170 * scale,
            right: -170 * scale,
            child: Container(
              height: 450 * scale,
              decoration: BoxDecoration(
                color: color.withValues(alpha: .80),
                shape: BoxShape.circle,
              ),
            ),
          ),

          /// Front Circle
          Positioned(
            top: -255 * scale,
            left: -70 * scale,
            right: -70 * scale,
            child: Container(
              height: 440 * scale,
              decoration: BoxDecoration(
                color: color,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: .08),
                    blurRadius: 18 * scale,
                    offset: Offset(0, 6 * scale),
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
// class TopBackground extends StatelessWidget {
//   const TopBackground({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return SizedBox(
//       height: 200,
//       width: double.infinity,
//       child: Stack(
//         clipBehavior: Clip.none,
//         children: [
//           /// Back Circle (light green)
//           Positioned(
//             top: -240,
//             left: -170,
//             right: -170,
//             child: Container(
//               height: 440,
//               decoration: BoxDecoration(
//                 color: AppTheme.secondary.withOpacity(.80),
//                 shape: BoxShape.circle,
//               ),
//             ),
//           ),

//           /// Front Circle (dark green)
//           Positioned(
//             top: -265,
//             left: -70,
//             right: -70,
//             child: Container(
//               height: 430,
//               decoration: BoxDecoration(
//                 color: AppTheme.secondary,
//                 shape: BoxShape.circle,
//                 boxShadow: [
//                   BoxShadow(
//                     color: Colors.black.withOpacity(.08),
//                     blurRadius: 18,
//                     offset: const Offset(0, 6),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
class BottomLeftCircle extends StatelessWidget {
  final Color color;

  const BottomLeftCircle({super.key, required this.color});

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;

    final bigSize = w * 0.48;
    final smallSize = w * 0.05;

    final bigLeft = -bigSize * 0.45;
    final bigBottom = -bigSize * 0.45;

    return Stack(
      children: [
        /// Big Circle
        Positioned(
          left: bigLeft,
          bottom: bigBottom,
          child: Container(
            width: bigSize,
            height: bigSize,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: color.withOpacity(.08),
            ),
          ),
        ),

        /// Small Circle (with space)
        Positioned(
          left: bigLeft + bigSize + w * 0.04, // gap after big circle
          bottom: bigBottom + bigSize * 0.75, // move upward
          child: Container(
            width: smallSize,
            height: smallSize,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: color.withOpacity(.18),
            ),
          ),
        ),
      ],
    );
  }
}

// class BottomLeftCircle extends StatelessWidget {
//   const BottomLeftCircle({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final screenWidth = MediaQuery.of(context).size.width;

//     final circleSize = screenWidth * 0.48;

//     return Positioned(
//       left: -circleSize * 0.45,
//       bottom: -circleSize * 0.45,
//       child: Container(
//         width: circleSize,
//         height: circleSize,
//         decoration: BoxDecoration(
//           shape: BoxShape.circle,
//           color: AppTheme.secondary.withOpacity(.08),
//         ),
//       ),
//     );
//   }
// }

class BottomRightCircle extends StatelessWidget {
  final Color color;

  const BottomRightCircle({super.key, required this.color});

  @override
  Widget build(BuildContext context) {
    final scale = MediaQuery.of(context).size.width / 393;

    return Positioned(
      right: -35 * scale,
      bottom: 55 * scale,
      child: IgnorePointer(
        child: Container(
          width: 85 * scale,
          height: 85 * scale,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: color.withOpacity(.18), width: 3 * scale),
          ),
        ),
      ),
    );
  }
}
