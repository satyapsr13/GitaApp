// ignore_for_file: prefer_const_constructors
import 'dart:math';

import 'package:flutter/material.dart';

class CustomShapeClipper extends CustomClipper<Path> {
  final int sides;
  final double borderRadius;

  CustomShapeClipper({required this.sides, required this.borderRadius});

  @override
  Path getClip(Size size) {
    final path = Path();
    final double centerX = size.width / 2;
    final double centerY = size.height / 2;
    final double radius = size.width / 2;

    final double angle = (2 * pi) / sides;

    path.moveTo(centerX + radius * cos(0), centerY + radius * sin(0));

    for (int i = 1; i <= sides; i++) {
      final double theta = i * angle;
      final double x = centerX + radius * cos(theta);
      final double y = centerY + radius * sin(theta);
      path.lineTo(x, y);

      // Add a rounded corner if a border radius is specified
      if (borderRadius > 0) {
        final double controlX =
            centerX + (radius + borderRadius) * cos(theta - (angle / 2));
        final double controlY =
            centerY + (radius + borderRadius) * sin(theta - (angle / 2));
        path.quadraticBezierTo(controlX, controlY, x, y);
      }
    }

    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return true;
  }
}


class StarClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.moveTo(size.width / 2, 0);
    path.lineTo(size.width * 0.3, size.height * 0.7);
    path.lineTo(size.width, size.height * 0.35);
    path.lineTo(0, size.height * 0.35);
    path.lineTo(size.width * 0.7, size.height * 0.7);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }
}
