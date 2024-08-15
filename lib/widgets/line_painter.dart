import 'package:wingscape_puzzle/style/theme.dart';
import 'package:flutter/material.dart';

class LinePainter extends CustomPainter {
  final List<Offset> points;
  final double cellSize;

  LinePainter(this.points, this.cellSize);

  @override
  void paint(Canvas canvas, Size size) {
    if (points.isEmpty) return;

    // Create a gradient for the line
    const gradient = AppTheme.line;

    // Paint for the glow effect
    final glowPaint = Paint()
      ..shader = gradient.createShader(Rect.fromPoints(
        Offset(points.first.dx * cellSize, points.first.dy * cellSize),
        Offset(points.last.dx * cellSize, points.last.dy * cellSize),
      ))
      ..color = Colors.white.withOpacity(0.5)
      ..strokeWidth = 16
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 10)
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    final paint = Paint()
      ..shader = gradient.createShader(Rect.fromPoints(
        Offset(points.first.dx * cellSize, points.first.dy * cellSize),
        Offset(points.last.dx * cellSize, points.last.dy * cellSize),
      ))
      ..strokeWidth = 8
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    for (int i = 0; i < points.length - 1; i++) {
      canvas.drawLine(
        Offset(points[i].dx * cellSize + cellSize / 2,
            points[i].dy * cellSize + cellSize / 2),
        Offset(points[i + 1].dx * cellSize + cellSize / 2,
            points[i + 1].dy * cellSize + cellSize / 2),
        glowPaint,
      );
    }

    for (int i = 0; i < points.length - 1; i++) {
      canvas.drawLine(
        Offset(points[i].dx * cellSize + cellSize / 2,
            points[i].dy * cellSize + cellSize / 2),
        Offset(points[i + 1].dx * cellSize + cellSize / 2,
            points[i + 1].dy * cellSize + cellSize / 2),
        paint,
      );
    }

    // // Draw dots at each point
    // final dotPaint = Paint()
    //   ..shader = gradient.createShader(Rect.fromPoints(
    //     Offset(points.first.dx * cellSize, points.first.dy * cellSize),
    //     Offset(points.last.dx * cellSize, points.last.dy * cellSize),
    //   ))
    //   ..style = PaintingStyle.fill;

    // for (var point in points) {
    //   // Draw glow for dots
    //   canvas.drawCircle(
    //     Offset(point.dx * cellSize + cellSize / 2,
    //         point.dy * cellSize + cellSize / 2),
    //     12, // Larger radius for glow
    //     glowPaint,
    //   );

    //   // Draw main dots
    //   canvas.drawCircle(
    //     Offset(point.dx * cellSize + cellSize / 2,
    //         point.dy * cellSize + cellSize / 2),
    //     6,
    //     dotPaint,
    //   );
    // }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
