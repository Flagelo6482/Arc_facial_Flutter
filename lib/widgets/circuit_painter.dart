import 'dart:math';
import 'package:flutter/material.dart';

enum _Dir { right, left, up, down }

class _Seg {
  final Offset start, end;
  final double phase, speed;
  const _Seg(this.start, this.end, this.phase, this.speed);
}

class _Seed {
  final Offset origin;
  final _Dir dir;
  final double len;
  const _Seed(this.origin, this.dir, this.len);
}

class CircuitPainter extends CustomPainter {
  final double t;

  CircuitPainter(this.t);

  // Cache para no reconstruir la geometría cada frame
  static List<_Seg>? _cache;
  static Size? _cacheSize;

  List<_Seg> _buildSegments(Size size) {
    if (_cacheSize == size && _cache != null) return _cache!;

    final rnd = Random(42);
    final segs = <_Seg>[];

    // Puntos semilla desde los bordes y zonas clave de la pantalla
    final seeds = [
      _Seed(Offset(size.width * 0.50, 0),            _Dir.down,  size.height * 0.65),
      _Seed(Offset(size.width * 0.20, 0),            _Dir.down,  size.height * 0.50),
      _Seed(Offset(size.width * 0.80, 0),            _Dir.down,  size.height * 0.50),
      _Seed(Offset(0, size.height * 0.25),           _Dir.right, size.width  * 0.70),
      _Seed(Offset(0, size.height * 0.65),           _Dir.right, size.width  * 0.55),
      _Seed(Offset(size.width, size.height * 0.40),  _Dir.left,  size.width  * 0.65),
      _Seed(Offset(size.width, size.height * 0.80),  _Dir.left,  size.width  * 0.40),
      _Seed(Offset(size.width * 0.30, size.height),  _Dir.up,    size.height * 0.60),
      _Seed(Offset(size.width * 0.70, size.height),  _Dir.up,    size.height * 0.55),
    ];

    for (final s in seeds) {
      _branch(s.origin, s.dir, s.len, 5, rnd, segs);
    }

    _cache = segs;
    _cacheSize = size;
    return segs;
  }

  void _branch(
    Offset start, _Dir dir, double len, int depth, Random rnd, List<_Seg> segs,
  ) {
    if (depth <= 0 || len < 20) return;

    final actualLen = len * (0.40 + rnd.nextDouble() * 0.55);

    final Offset end;
    switch (dir) {
      case _Dir.right: end = Offset(start.dx + actualLen, start.dy); break;
      case _Dir.left:  end = Offset(start.dx - actualLen, start.dy); break;
      case _Dir.down:  end = Offset(start.dx, start.dy + actualLen); break;
      case _Dir.up:    end = Offset(start.dx, start.dy - actualLen); break;
    }

    segs.add(_Seg(start, end, rnd.nextDouble(), 0.35 + rnd.nextDouble() * 0.85));

    // Ramas perpendiculares
    final perpA = (dir == _Dir.right || dir == _Dir.left) ? _Dir.down  : _Dir.right;
    final perpB = (dir == _Dir.right || dir == _Dir.left) ? _Dir.up    : _Dir.left;

    final numBranches = depth >= 4 ? 2 + rnd.nextInt(2) : 1 + rnd.nextInt(2);
    for (int i = 0; i < numBranches; i++) {
      final bT = 0.15 + rnd.nextDouble() * 0.65;
      _branch(
        Offset.lerp(start, end, bT)!,
        rnd.nextBool() ? perpA : perpB,
        actualLen * 0.58,
        depth - 1,
        rnd,
        segs,
      );
    }

    // Continúa en la misma dirección ocasionalmente
    if (rnd.nextDouble() > 0.40 && depth > 1) {
      _branch(end, dir, actualLen * 0.55, depth - 1, rnd, segs);
    }
  }

  @override
  void paint(Canvas canvas, Size size) {
    final segs = _buildSegments(size);

    // Dibuja trazos con brillo pulsante
    for (final seg in segs) {
      final pulse = sin((t + seg.phase) * 2 * pi) * 0.5 + 0.5;
      _drawTrace(canvas, seg.start, seg.end, pulse);
    }

    // Dibuja señales viajando por cada trazo
    for (final seg in segs) {
      _drawSignal(canvas, seg);
    }

    // Puntos titilantes adicionales
    final rnd2 = Random(13);
    for (int i = 0; i < 25; i++) {
      final pos = Offset(
        rnd2.nextDouble() * size.width,
        rnd2.nextDouble() * size.height,
      );
      final phase = rnd2.nextDouble();
      final twinkle = sin((t * 3.0 + phase) * 2 * pi) * 0.5 + 0.5;
      _drawDot(canvas, pos, 1.2 + rnd2.nextDouble() * 1.8, twinkle);
    }
  }

  void _drawTrace(Canvas canvas, Offset s, Offset e, double pulse) {
    canvas.drawLine(
      s, e,
      Paint()
        ..color = const Color(0xFF0088DD).withOpacity(0.10 + pulse * 0.22)
        ..strokeWidth = 2.5
        ..style = PaintingStyle.stroke
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4),
    );
    canvas.drawLine(
      s, e,
      Paint()
        ..color = const Color(0xFF1B4F8A).withOpacity(0.28 + pulse * 0.30)
        ..strokeWidth = 1.0
        ..style = PaintingStyle.stroke,
    );
    _drawDot(canvas, s, 2.0, pulse);
    _drawDot(canvas, e, 2.0, pulse);
  }

  void _drawDot(Canvas canvas, Offset pos, double r, double pulse) {
    canvas.drawCircle(
      pos, r + 2.5,
      Paint()
        ..color = const Color(0xFF00CFFF).withOpacity(0.15 + pulse * 0.30)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 5)
        ..style = PaintingStyle.fill,
    );
    canvas.drawCircle(
      pos, r,
      Paint()
        ..color = const Color(0xFF2D7DD2).withOpacity(0.50 + pulse * 0.50)
        ..style = PaintingStyle.fill,
    );
  }

  void _drawSignal(Canvas canvas, _Seg seg) {
    final signalT = ((t * seg.speed + seg.phase) % 1.0);
    final pos = Offset.lerp(seg.start, seg.end, signalT)!;

    // Halo exterior
    canvas.drawCircle(
      pos, 9,
      Paint()
        ..color = const Color(0xFF00BFFF).withOpacity(0.18)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 9)
        ..style = PaintingStyle.fill,
    );
    // Halo interior
    canvas.drawCircle(
      pos, 4.5,
      Paint()
        ..color = const Color(0xFF64B5F6).withOpacity(0.55)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 3)
        ..style = PaintingStyle.fill,
    );
    // Núcleo blanco
    canvas.drawCircle(
      pos, 2.2,
      Paint()
        ..color = Colors.white.withOpacity(0.90)
        ..style = PaintingStyle.fill,
    );
  }

  @override
  bool shouldRepaint(CircuitPainter old) => old.t != t;
}
