import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MainCanvas extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    // Rectángulo principal con margen de 2px
    final rect = Rect.fromLTWH(2, 2, size.width - 4, size.height - 4);
    final paint = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    // Dibujar el rectángulo
    canvas.drawRect(rect, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
