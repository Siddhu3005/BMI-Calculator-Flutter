import 'package:flutter/material.dart';
import 'dart:math';

class BMIGauge extends StatelessWidget {
  final double bmi;

  const BMIGauge({super.key, required this.bmi});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: const Size(200, 120),
      painter: BMIGaugePainter(bmi),
      child: SizedBox(
        width: 200,
        height: 120,
        child: Center(
          child: Padding(
            padding: const EdgeInsets.only(top: 40),
            child: Text(
              'BMI = ${bmi.toStringAsFixed(1)}',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class BMIGaugePainter extends CustomPainter {
  final double bmi;

  BMIGaugePainter(this.bmi);

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height);
    final radius = size.width / 2 - 10;

    // Draw gauge segments
    _drawSegment(canvas, center, radius, -pi, -pi * 0.75, Colors.blue, 'Underweight');
    _drawSegment(canvas, center, radius, -pi * 0.75, -pi * 0.5, Colors.green, 'Normal');
    _drawSegment(canvas, center, radius, -pi * 0.5, -pi * 0.25, Colors.orange, 'Overweight');
    _drawSegment(canvas, center, radius, -pi * 0.25, 0, Colors.red, 'Obesity');

    // Draw needle
    _drawNeedle(canvas, center, radius);
  }

  void _drawSegment(Canvas canvas, Offset center, double radius, double startAngle, double endAngle, Color color, String label) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 20;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      startAngle,
      endAngle - startAngle,
      false,
      paint,
    );
  }

  void _drawNeedle(Canvas canvas, Offset center, double radius) {
    double angle;
    if (bmi < 18.5) {
      angle = -pi + (bmi / 18.5) * (pi * 0.25);
    } else if (bmi < 25) {
      angle = -pi * 0.75 + ((bmi - 18.5) / 6.5) * (pi * 0.25);
    } else if (bmi < 30) {
      angle = -pi * 0.5 + ((bmi - 25) / 5) * (pi * 0.25);
    } else {
      angle = -pi * 0.25 + (min(bmi - 30, 10) / 10) * (pi * 0.25);
    }

    final needleEnd = Offset(
      center.dx + (radius - 30) * cos(angle),
      center.dy + (radius - 30) * sin(angle),
    );

    final paint = Paint()
      ..color = Colors.black
      ..strokeWidth = 3;

    canvas.drawLine(center, needleEnd, paint);
    canvas.drawCircle(center, 5, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}