import 'package:flutter/material.dart';

class RulerPainterFunction extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = Colors.grey
      ..strokeWidth = 1.0;

    final double step = size.height / 20; // Number of lines

    // Extra padding to prevent cutting off lines
    final double padding = 4.0;

    for (int i = 0; i <= 23; i++) {
      double y = step * i;
      double lineLength;

      if (i % 5 == 0) {
        lineLength = size.width * 0.3; // Longest line
      } else {
        lineLength = size.width * 0.1; // Shorter lines
      }

      // Adjust drawing start and end positions with padding
      canvas.drawLine(
        Offset(size.width - lineLength, y + padding),
        Offset(size.width, y + padding),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

