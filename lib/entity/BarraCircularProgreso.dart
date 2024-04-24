import 'dart:math' as math;
import 'package:flutter/material.dart';

class CircularProgressBar extends StatelessWidget {
  final double percentage;
  final double radius;
  final Color backgroundColor;
  final Color foregroundColor;
  final double strokeWidth;
  final int number;

  CircularProgressBar({
    required this.percentage,
    this.radius = 50,
    this.backgroundColor = Colors.grey,
    this.foregroundColor = Colors.blue,
    this.strokeWidth = 10,
    required this.number,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          width: radius * 2,
          height: radius * 2,
          child: CircularProgressIndicator(
            value: percentage / 100,
            backgroundColor: backgroundColor,
            valueColor: AlwaysStoppedAnimation<Color>(foregroundColor),
            strokeWidth: strokeWidth,
          ),
        ),
        Text(
          number.toString(),
          style: TextStyle(
            fontSize: radius * 0.8,
            fontWeight: FontWeight.bold,
            color: foregroundColor,
          ),
        ),
      ],
    );
  }
}

class CircularProgressBarPainter extends CustomPainter {
  final double strokeWidth;
  final Color backgroundColor;
  final Color progressColor;
  final int percentage;

  CircularProgressBarPainter({
    required this.strokeWidth,
    required this.backgroundColor,
    required this.progressColor,
    required this.percentage,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final Paint backgroundPaint = Paint()
      ..color = backgroundColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;

    final Paint progressPaint = Paint()
      ..color = progressColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    final double radius = size.width / 2;
    final Offset center = Offset(size.width / 2, size.height / 2);
    final double angle = 2 * math.pi * (percentage / 100);

    // Dibujar el círculo de fondo
    canvas.drawCircle(center, radius, backgroundPaint);

    // Dibujar el arco de progreso
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -math.pi / 2, // Empezar desde arriba (12 en punto)
      angle, // Ángulo de progreso
      false,
      progressPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
