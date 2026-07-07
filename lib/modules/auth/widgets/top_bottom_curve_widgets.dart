import 'package:flutter/material.dart';

class DoctorAvatar extends StatelessWidget {
  final Color color;
  final Widget icon;

  const DoctorAvatar({super.key, required this.color, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 110,
      height: 110,
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
        padding: const EdgeInsets.all(1),
        child: Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: color.withValues(alpha: .10),
          ),
          child: Center(child: icon),
        ),
      ),
    );
  }
}

class TopBackground extends StatelessWidget {
  final Color color;

  const TopBackground({super.key, required this.color});

  static const double headerHeight = 200;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: headerHeight,
      width: double.infinity,
      child: CustomPaint(painter: _TopBackgroundPainter(color)),
    );
  }
}

class _TopBackgroundPainter extends CustomPainter {
  final Color color;

  _TopBackgroundPainter(this.color);

  @override
  void paint(Canvas canvas, Size size) {
    final backPaint = Paint()
      ..color = color.withValues(alpha: .80)
      ..style = PaintingStyle.fill;

    final frontPaint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final shadowPaint = Paint()
      ..color = Colors.black.withValues(alpha: .08)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 18);

    // Fixed header height
    const double headerHeight = 200;

    // Bigger circles so the curve reaches both edges
    final double backRadius = size.width * 1.08;
    final double frontRadius = size.width * 1.03;

    // Move circles higher to match Image 2
    final Offset backCenter = Offset(
      size.width / 2,
      -backRadius + headerHeight - 6,
    );

    final Offset frontCenter = Offset(
      size.width / 2,
      -frontRadius + headerHeight - 30,
    );

    // Shadow
    canvas.drawCircle(frontCenter.translate(0, 8), frontRadius, shadowPaint);

    // Back circle
    canvas.drawCircle(backCenter, backRadius, backPaint);

    // Front circle
    canvas.drawCircle(frontCenter, frontRadius, frontPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class BottomLeftCircle extends StatelessWidget {
  final Color color;

  const BottomLeftCircle({super.key, required this.color});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: -85,
      bottom: -85,
      child: IgnorePointer(
        child: SizedBox(
          width: 220,
          height: 220,
          child: CustomPaint(painter: _BottomLeftCirclePainter(color)),
        ),
      ),
    );
  }
}

class _BottomLeftCirclePainter extends CustomPainter {
  final Color color;

  const _BottomLeftCirclePainter(this.color);

  @override
  void paint(Canvas canvas, Size size) {
    final bigPaint = Paint()
      ..color = color.withValues(alpha: .08)
      ..style = PaintingStyle.fill;

    final smallPaint = Paint()
      ..color = color.withValues(alpha: .18)
      ..style = PaintingStyle.fill;

    // Big Circle (188 diameter)
    canvas.drawCircle(const Offset(94, 126), 94, bigPaint);

    // Small Circle (20 diameter)
    canvas.drawCircle(const Offset(214, 78), 10, smallPaint);
  }

  @override
  bool shouldRepaint(covariant _BottomLeftCirclePainter oldDelegate) {
    return oldDelegate.color != color;
  }
}

class BottomRightCircle extends StatelessWidget {
  final Color color;

  const BottomRightCircle({super.key, required this.color});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      right: -35,
      bottom: 55,
      child: IgnorePointer(
        child: CustomPaint(
          size: const Size(85, 85),
          painter: _BottomRightCirclePainter(color),
        ),
      ),
    );
  }
}

class _BottomRightCirclePainter extends CustomPainter {
  final Color color;

  const _BottomRightCirclePainter(this.color);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color.withValues(alpha: 0.18)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3;

    canvas.drawCircle(
      Offset(size.width / 2, size.height / 2),
      (size.width / 2) - (paint.strokeWidth / 2),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant _BottomRightCirclePainter oldDelegate) {
    return oldDelegate.color != color;
  }
}
