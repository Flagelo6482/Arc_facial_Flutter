import 'dart:math';
import 'package:flutter/material.dart';

class Particle {
  double x, y, vx, vy;
  final double radius;

  Particle({
    required this.x,
    required this.y,
    required this.vx,
    required this.vy,
    required this.radius,
  });
}

class ParticlePainter extends CustomPainter {
  final List<Particle> particles;
  final Offset? mouse;

  static const double _connectDist = 115;

  const ParticlePainter({required this.particles, this.mouse});

  @override
  void paint(Canvas canvas, Size size) {
    // Líneas entre partículas cercanas
    for (int i = 0; i < particles.length; i++) {
      for (int j = i + 1; j < particles.length; j++) {
        final dx = particles[i].x - particles[j].x;
        final dy = particles[i].y - particles[j].y;
        final dist = sqrt(dx * dx + dy * dy);

        if (dist < _connectDist) {
          canvas.drawLine(
            Offset(particles[i].x, particles[i].y),
            Offset(particles[j].x, particles[j].y),
            Paint()
              ..color = const Color(0xFF4FC3F7)
                  .withOpacity((1 - dist / _connectDist) * 0.30)
              ..strokeWidth = 0.7,
          );
        }
      }

      // Líneas hacia el cursor
      final m = mouse;
      if (m != null) {
        final dx = particles[i].x - m.dx;
        final dy = particles[i].y - m.dy;
        final dist = sqrt(dx * dx + dy * dy);
        final mouseDist = _connectDist * 2.0;

        if (dist < mouseDist) {
          canvas.drawLine(
            Offset(particles[i].x, particles[i].y),
            m,
            Paint()
              ..color = const Color(0xFF80DEEA)
                  .withOpacity((1 - dist / mouseDist) * 0.55)
              ..strokeWidth = 0.9,
          );
        }
      }
    }

    // Dibujar partículas
    for (final p in particles) {
      // Halo exterior
      canvas.drawCircle(
        Offset(p.x, p.y),
        p.radius + 2.5,
        Paint()
          ..color = const Color(0xFF00BFFF).withOpacity(0.18)
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4)
          ..style = PaintingStyle.fill,
      );
      // Núcleo
      canvas.drawCircle(
        Offset(p.x, p.y),
        p.radius,
        Paint()
          ..color = const Color(0xFF4FC3F7).withOpacity(0.80)
          ..style = PaintingStyle.fill,
      );
    }
  }

  @override
  bool shouldRepaint(ParticlePainter old) => true;
}
