import 'package:flutter/material.dart';

class RightCurveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();

    path.moveTo(0, 0);
    path.lineTo(size.width, 0);
    path.lineTo(size.width, size.height);

    path.lineTo(size.width * 0.28, size.height);

    path.cubicTo(
      size.width * 0.72,
      size.height * 0.92,
      size.width * 0.95,
      size.height * 0.42,
      size.width,
      0,
    );

    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
