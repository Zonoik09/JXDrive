import 'package:flutter/material.dart';

class MainCanvas extends CustomPainter {
  final bool isHovered;
  final bool isFocused;

  // Pinceles para los bordes
  final Paint _borderPaint = Paint()
    ..color = Colors.black
    ..style = PaintingStyle.stroke
    ..strokeWidth = 2.0;

  final Paint _focusBorderPaint = Paint()
    ..color = Colors.red
    ..style = PaintingStyle.stroke
    ..strokeWidth = 2.0;

  MainCanvas({
    required this.isHovered,
    required this.isFocused,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // Dibuja el borde del campo de texto
    final Rect rect = Rect.fromLTWH(5, 5, size.width / 1.5, size.height / 4);
    canvas.drawRect(
        rect, isHovered || isFocused ? _focusBorderPaint : _borderPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true; // Necesitamos redibujar para que la animación se actualice
  }
}