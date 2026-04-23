// widgets/orbit_painter.dart
// ✅ BÔNUS: CustomPainter desenhando formas geométricas (órbitas e estrelas)

import 'dart:math' as math;
import 'package:flutter/material.dart';

/// CustomPainter que desenha um sistema de órbitas animado.
/// Usado no background da tela principal e na tela de detalhes.
class OrbitPainter extends CustomPainter {
  final double animationValue; // 0.0 a 1.0 (rotação)
  final Color orbitColor;
  final int orbitCount;

  const OrbitPainter({
    required this.animationValue,
    required this.orbitColor,
    this.orbitCount = 3,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final maxRadius = math.min(size.width, size.height) * 0.45;

    // Desenha anéis orbitais
    for (int i = 0; i < orbitCount; i++) {
      final radius = maxRadius * (0.4 + i * 0.3);
      final orbitPaint = Paint()
        ..color = orbitColor.withValues(alpha: 0.15 - i * 0.03)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.0;

      canvas.drawCircle(center, radius, orbitPaint); // drawCircle (obrigatório)

      // Planeta orbitando em cada anel
      final angle = animationValue * 2 * math.pi + (i * math.pi * 2 / 3);
      final planetX = center.dx + radius * math.cos(angle);
      final planetY = center.dy + radius * math.sin(angle);

      final dotPaint = Paint()
        ..color = orbitColor.withValues(alpha: 0.5)
        ..style = PaintingStyle.fill;

      canvas.drawCircle(Offset(planetX, planetY), 4.0 - i * 0.5, dotPaint);
    }

    // Estrela central
    _drawStar(canvas, center, 12, 6, orbitColor.withValues(alpha: 0.6));

    // Estrelas pequenas de fundo
    final starPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.4)
      ..style = PaintingStyle.fill;

    final rand = math.Random(42); // seed fixo para posições consistentes
    for (int i = 0; i < 30; i++) {
      final x = rand.nextDouble() * size.width;
      final y = rand.nextDouble() * size.height;
      final starRadius = rand.nextDouble() * 1.5 + 0.5;
      canvas.drawCircle(Offset(x, y), starRadius, starPaint);
    }
  }

  /// Desenha uma estrela de N pontas usando drawPath
  void _drawStar(
    Canvas canvas,
    Offset center,
    double outerRadius,
    double innerRadius,
    Color color,
  ) {
    const points = 5;
    final path = Path();
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    for (int i = 0; i < points * 2; i++) {
      final radius = i.isEven ? outerRadius : innerRadius;
      final angle = (i * math.pi / points) - math.pi / 2;
      final x = center.dx + radius * math.cos(angle);
      final y = center.dy + radius * math.sin(angle);
      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }
    path.close();
    canvas.drawPath(path, paint); // drawPath (obrigatório)
  }

  @override
  bool shouldRepaint(OrbitPainter oldDelegate) {
    // Repinta apenas se o valor de animação ou cor mudou
    return oldDelegate.animationValue != animationValue ||
        oldDelegate.orbitColor != orbitColor;
  }
}

/// CustomPainter para o anel de Saturno na tela de detalhes
class RingPainter extends CustomPainter {
  final Color color;
  final double tilt; // inclinação em radianos

  const RingPainter({required this.color, this.tilt = 0.3});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);

    for (int i = 0; i < 3; i++) {
      final rx = size.width * (0.6 + i * 0.08);
      final ry = rx * 0.25;

      final ringPaint = Paint()
        ..color = color.withValues(alpha: 0.3 - i * 0.08)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 8.0 - i * 2;

      // drawOval para os anéis de Saturno
      canvas.drawOval(
        Rect.fromCenter(center: center, width: rx, height: ry),
        ringPaint,
      );
    }
  }

  @override
  bool shouldRepaint(RingPainter oldDelegate) =>
      oldDelegate.color != color || oldDelegate.tilt != tilt;
}
