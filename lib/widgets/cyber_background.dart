import 'dart:math';
import 'package:flutter/material.dart';
import 'circuit_painter.dart';
import 'particle_painter.dart';

class CyberBackground extends StatefulWidget {
  final Widget child;

  const CyberBackground({super.key, required this.child});

  @override
  State<CyberBackground> createState() => _CyberBackgroundState();
}

class _CyberBackgroundState extends State<CyberBackground>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  final List<Particle> _particles = [];
  Offset? _mouse;
  Size? _size;

  static const int _particleCount = 55;
  static const double _repelRadius = 110;
  static const double _repelForce = 4.0;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 6),
    )..repeat();

    // Actualizar partículas en cada frame de animación
    _ctrl.addListener(_tickParticles);
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  void _initParticles(Size size) {
    if (_particles.isNotEmpty) return;
    final rnd = Random();
    for (int i = 0; i < _particleCount; i++) {
      _particles.add(Particle(
        x: rnd.nextDouble() * size.width,
        y: rnd.nextDouble() * size.height,
        vx: (rnd.nextDouble() - 0.5) * 0.7,
        vy: (rnd.nextDouble() - 0.5) * 0.7,
        radius: 1.5 + rnd.nextDouble() * 2.0,
      ));
    }
  }

  void _tickParticles() {
    final size = _size;
    if (size == null || _particles.isEmpty) return;

    for (final p in _particles) {
      // Repulsión del cursor
      final m = _mouse;
      if (m != null) {
        final dx = p.x - m.dx;
        final dy = p.y - m.dy;
        final distSq = dx * dx + dy * dy;
        if (distSq < _repelRadius * _repelRadius && distSq > 0) {
          final dist = sqrt(distSq);
          final force = (_repelRadius - dist) / _repelRadius * _repelForce;
          p.vx += (dx / dist) * force;
          p.vy += (dy / dist) * force;
        }
      }

      // Fricción
      p.vx *= 0.95;
      p.vy *= 0.95;

      // Límite de velocidad
      final spd = sqrt(p.vx * p.vx + p.vy * p.vy);
      if (spd > 4.0) {
        p.vx = p.vx / spd * 4.0;
        p.vy = p.vy / spd * 4.0;
      }

      // Mover
      p.x += p.vx;
      p.y += p.vy;

      // Rebote suave en bordes (wrap)
      if (p.x < -8) p.x += size.width + 16;
      if (p.x > size.width + 8) p.x -= size.width + 16;
      if (p.y < -8) p.y += size.height + 16;
      if (p.y > size.height + 8) p.y -= size.height + 16;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF080818),
      body: MouseRegion(
        // Mouse en web y desktop
        onHover: (e) => _mouse = e.localPosition,
        onExit: (_) => _mouse = null,
        child: GestureDetector(
          // Touch en móvil
          onPanUpdate: (d) => _mouse = d.localPosition,
          onPanEnd: (_) => _mouse = null,
          child: LayoutBuilder(
            builder: (ctx, constraints) {
              _size = Size(constraints.maxWidth, constraints.maxHeight);
              _initParticles(_size!);

              return Stack(
                children: [
                  // Fondo degradado base
                  Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Color(0xFF050510),
                          Color(0xFF0A0A1E),
                          Color(0xFF080818),
                        ],
                      ),
                    ),
                  ),

                  // Circuito animado (capa inferior)
                  Positioned.fill(
                    child: AnimatedBuilder(
                      animation: _ctrl,
                      builder: (_, __) => CustomPaint(
                        painter: CircuitPainter(_ctrl.value),
                      ),
                    ),
                  ),

                  // Partículas interactivas (capa superior)
                  Positioned.fill(
                    child: AnimatedBuilder(
                      animation: _ctrl,
                      builder: (_, __) => CustomPaint(
                        painter: ParticlePainter(
                          particles: _particles,
                          mouse: _mouse,
                        ),
                      ),
                    ),
                  ),

                  // Glow azul superior
                  Positioned(
                    top: -80,
                    left: 0,
                    right: 0,
                    child: Container(
                      height: 300,
                      decoration: BoxDecoration(
                        gradient: RadialGradient(
                          center: Alignment.topCenter,
                          radius: 0.8,
                          colors: [
                            const Color(0xFF1A3A8F).withOpacity(0.45),
                            Colors.transparent,
                          ],
                        ),
                      ),
                    ),
                  ),

                  // Contenido de la pantalla
                  SafeArea(child: widget.child),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
