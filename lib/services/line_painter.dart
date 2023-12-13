import 'package:flutter/material.dart';

class LinePainter extends CustomPainter {
  final int length;
  final int index;

  LinePainter({required this.length, required this.index});

  @override
  void paint(Canvas canvas, Size size) {
    if (index == -1) {
      return;
    }

    double topOffset = 0.0;
    double bottomOffset = index < length - 1 ? size.height : 0;

    final Paint paint = Paint()
      ..color = Colors.black // Change the color as desired
      ..strokeWidth = 1.0;

    canvas.drawLine(
      Offset(size.width / 2, topOffset),
      Offset(size.width / 2, bottomOffset),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
