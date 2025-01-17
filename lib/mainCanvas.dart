import 'package:flutter/material.dart';

class CustomTextFieldWidget extends StatelessWidget {
  final String labelText;
  final TextEditingController controller;
  final FocusNode focusNode;
  final bool isHovered;
  final bool isFocused;

  CustomTextFieldWidget({
    Key? key,
    required this.labelText,
    required this.controller,
    required this.focusNode,
    this.isHovered = false,
    this.isFocused = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: CustomPaint(
        painter: _TextFieldPainter(
          isHovered: isHovered,
          isFocused: focusNode.hasFocus,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Texto en la izquierda
            Padding(
              padding: const EdgeInsets.only(left: 10.0),
              child: Text(
                labelText,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: TextField(
                controller: controller,
                focusNode: focusNode,
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  hintText: "Escriu aqui...",
                ),
                style: const TextStyle(fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TextFieldPainter extends CustomPainter {
  final bool isHovered;
  final bool isFocused;

  _TextFieldPainter({required this.isHovered, required this.isFocused});

  final Paint _borderPaint = Paint()
    ..color = Colors.black
    ..style = PaintingStyle.stroke
    ..strokeWidth = 2.0;

  final Paint _focusBorderPaint = Paint()
    ..color = Colors.blue
    ..style = PaintingStyle.stroke
    ..strokeWidth = 2.0;

  @override
  void paint(Canvas canvas, Size size) {
    // Definir un radio para las esquinas redondeadas
    const double borderRadius = 10.0;

    // Crear un RRect para el borde con esquinas redondeadas
    final RRect rRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(0, 0, size.width, size.height),
      Radius.circular(borderRadius),
    );

    // Dibujar el borde dependiendo del estado de hover o focus
    canvas.drawRRect(
        rRect, isHovered || isFocused ? _focusBorderPaint : _borderPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
