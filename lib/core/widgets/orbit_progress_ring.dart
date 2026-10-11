import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:quy_dao/core/theme/app_tokens.dart';

class OrbitProgressRing extends StatelessWidget {
  const OrbitProgressRing({
    super.key,
    required this.progress, // 0.0 -> 1.0
    this.size = 96.0,
    this.strokeWidth = 6.0,
    this.child,
    this.arcColor = AppTokens.signalOrange,
    this.trackColor,
  });

  final double progress;
  final double size;
  final double strokeWidth;
  final Widget? child;
  final Color arcColor;
  final Color? trackColor;

  @override
  Widget build(BuildContext context) {
    final clampedProgress = progress.clamp(0.0, 1.0);

    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: 0.0, end: clampedProgress),
      duration: const Duration(milliseconds: 600),
      curve: Curves.easeOutCubic,
      builder: (context, animatedValue, _) {
        return SizedBox(
          width: size,
          height: size,
          child: Stack(
            alignment: Alignment.center,
            children: <Widget>[
              CustomPaint(
                size: Size(size, size),
                painter: _OrbitRingPainter(
                  progress: animatedValue,
                  strokeWidth: strokeWidth,
                  arcColor: arcColor,
                  trackColor:
                      trackColor ?? AppTokens.dustTaupe.withValues(alpha: 0.4),
                ),
              ),
              if (child != null) ...<Widget>[child!],
            ],
          ),
        );
      },
    );
  }
}

class _OrbitRingPainter extends CustomPainter {
  const _OrbitRingPainter({
    required this.progress,
    required this.strokeWidth,
    required this.arcColor,
    required this.trackColor,
  });

  final double progress;
  final double strokeWidth;
  final Color arcColor;
  final Color trackColor;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - strokeWidth) / 2;

    // 1. Vẽ vòng quỹ đạo nền (Track)
    final trackPaint = Paint()
      ..color = trackColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    canvas.drawCircle(center, radius, trackPaint);

    if (progress <= 0.0) return;

    // 2. Vẽ cung quỹ đạo màu cam (Progress Arc)
    const startAngle = -math.pi / 2; // Bắt đầu ở đỉnh 12 giờ
    final sweepAngle = 2 * math.pi * progress;

    final arcPaint = Paint()
      ..color = arcColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      startAngle,
      sweepAngle,
      false,
      arcPaint,
    );

    // 3. Vẽ điểm tròn vệ tinh (Satellite "Hành tinh trên quỹ đạo")
    final satelliteAngle = startAngle + sweepAngle;
    final satelliteOffset = Offset(
      center.dx + radius * math.cos(satelliteAngle),
      center.dy + radius * math.sin(satelliteAngle),
    );

    // Vành ngoài vệ tinh
    final satelliteOuterPaint = Paint()
      ..color = AppTokens.white
      ..style = PaintingStyle.fill;
    canvas.drawCircle(satelliteOffset, strokeWidth * 0.9, satelliteOuterPaint);

    // Điểm cam bên trong vệ tinh
    final satelliteInnerPaint = Paint()
      ..color = arcColor
      ..style = PaintingStyle.fill;
    canvas.drawCircle(satelliteOffset, strokeWidth * 0.55, satelliteInnerPaint);
  }

  @override
  bool shouldRepaint(covariant _OrbitRingPainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.arcColor != arcColor ||
        oldDelegate.trackColor != trackColor ||
        oldDelegate.strokeWidth != strokeWidth;
  }
}
