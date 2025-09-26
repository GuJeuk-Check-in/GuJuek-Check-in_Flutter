import 'package:flutter/material.dart';

class GridPainter extends CustomPainter {
  final double cellSize;
  final Color lineColor;
  final double strokeWidth;

  GridPainter({
    this.cellSize = 30.0,           // 기본 간격
    this.lineColor = Colors.grey,   // 기본 색
    this.strokeWidth = 1,         // 기본 두께
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = lineColor.withOpacity(0.3)
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;

    for (double x = 0; x <= size.width; x += cellSize) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }

    for (double y = 0; y <= size.height; y += cellSize) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
