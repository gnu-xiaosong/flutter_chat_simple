import 'package:flutter/material.dart';

class DashedBorderPainter extends CustomPainter {
  final Color color;
  final double strokeWidth;
  final double dashWidth;
  final double dashSpace;
  final double borderRadius;

  DashedBorderPainter({
    required this.color,
    this.strokeWidth = 2.0,
    this.dashWidth = 5.0,
    this.dashSpace = 3.0,
    this.borderRadius = 12.0,
  });

  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;

    var path = Path()
      ..moveTo(borderRadius, 0)
      ..lineTo(size.width - borderRadius, 0)
      ..arcToPoint(Offset(size.width, borderRadius),
          radius: Radius.circular(borderRadius))
      ..lineTo(size.width, size.height - borderRadius)
      ..arcToPoint(Offset(size.width - borderRadius, size.height),
          radius: Radius.circular(borderRadius))
      ..lineTo(borderRadius, size.height)
      ..arcToPoint(Offset(0, size.height - borderRadius),
          radius: Radius.circular(borderRadius))
      ..lineTo(0, borderRadius)
      ..arcToPoint(Offset(borderRadius, 0),
          radius: Radius.circular(borderRadius));

    var dashPath = Path();
    var pathMetrics = path.computeMetrics();
    for (var pathMetric in pathMetrics) {
      var distance = 0.0;
      while (distance < pathMetric.length) {
        var length = dashWidth;
        dashPath.addPath(
          pathMetric.extractPath(distance, distance + length),
          Offset.zero,
        );
        distance += dashWidth + dashSpace;
      }
    }

    canvas.drawPath(dashPath, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
