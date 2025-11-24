import 'dart:math' as math;
import 'package:flutter/material.dart';

class CircularRevealClipper extends CustomClipper<Path> {
  final double fraction;

  CircularRevealClipper(this.fraction);

  @override
  Path getClip(Size size) {
    final center = Offset(size.width / 2, size.height);
    // Calculate max radius to cover the screen from bottom-center
    // Distance from (w/2, h) to (0, 0) is the furthest point.
    final maxRadius = math.sqrt(
      (size.width * size.width / 4) + (size.height * size.height),
    );
    final radius = maxRadius * fraction;

    final path = Path();
    path.addOval(Rect.fromCircle(center: center, radius: radius));
    return path;
  }

  @override
  bool shouldReclip(CircularRevealClipper oldClipper) =>
      oldClipper.fraction != fraction;
}
