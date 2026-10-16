import 'package:flutter/material.dart';

/// Pixel Flame Icon for Streaks 🔥
class PixelFlameIcon extends StatelessWidget {
  final double size;
  const PixelFlameIcon({super.key, this.size = 24.0});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(
        painter: _PixelFlamePainter(),
      ),
    );
  }
}

class _PixelFlamePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final unit = size.width / 12.0;

    // Grid 12x12
    final redPaint = Paint()..color = const Color(0xFFDC2626);
    final orangePaint = Paint()..color = const Color(0xFFFA520F);
    final yellowPaint = Paint()..color = const Color(0xFFFBBF24);

    void drawPx(int x, int y, Paint paint) {
      canvas.drawRect(
        Rect.fromLTWH(x * unit, y * unit, unit, unit),
        paint,
      );
    }

    // Outer flame border / shape
    final redCoords = [
      [5, 1], [6, 1],
      [4, 2], [5, 2], [6, 2], [7, 2],
      [3, 3], [4, 3], [5, 3], [6, 3], [7, 3], [8, 3],
      [2, 4], [3, 4], [4, 4], [5, 4], [6, 4], [7, 4], [8, 4], [9, 4],
      [2, 5], [3, 5], [4, 5], [5, 5], [6, 5], [7, 5], [8, 5], [9, 5],
      [1, 6], [2, 6], [3, 6], [4, 6], [5, 6], [6, 6], [7, 6], [8, 6], [9, 6], [10, 6],
      [1, 7], [2, 7], [3, 7], [4, 7], [5, 7], [6, 7], [7, 7], [8, 7], [9, 7], [10, 7],
      [2, 8], [3, 8], [4, 8], [5, 8], [6, 8], [7, 8], [8, 8], [9, 8],
      [3, 9], [4, 9], [5, 9], [6, 9], [7, 9], [8, 9],
      [4, 10], [5, 10], [6, 10], [7, 10],
    ];

    for (final c in redCoords) {
      drawPx(c[0], c[1], redPaint);
    }

    // Orange inner flame
    final orangeCoords = [
      [5, 3], [6, 3],
      [4, 4], [5, 4], [6, 4], [7, 4],
      [4, 5], [5, 5], [6, 5], [7, 5],
      [3, 6], [4, 6], [5, 6], [6, 6], [7, 6], [8, 6],
      [3, 7], [4, 7], [5, 7], [6, 7], [7, 7], [8, 7],
      [4, 8], [5, 8], [6, 8], [7, 8],
      [5, 9], [6, 9],
    ];

    for (final c in orangeCoords) {
      drawPx(c[0], c[1], orangePaint);
    }

    // Yellow core
    final yellowCoords = [
      [5, 5], [6, 5],
      [5, 6], [6, 6],
      [5, 7], [6, 7],
      [5, 8],
    ];

    for (final c in yellowCoords) {
      drawPx(c[0], c[1], yellowPaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// Pixel Dumbbell Icon for Fitness / Exercise 🏋️
class PixelDumbbellIcon extends StatelessWidget {
  final double size;
  const PixelDumbbellIcon({super.key, this.size = 24.0});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(
        painter: _PixelDumbbellPainter(),
      ),
    );
  }
}

class _PixelDumbbellPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final unit = size.width / 12.0;

    final darkPaint = Paint()..color = const Color(0xFF1E293B);
    final metalPaint = Paint()..color = const Color(0xFF94A3B8);
    final accentPaint = Paint()..color = const Color(0xFFFA520F);

    void drawPx(int x, int y, Paint paint) {
      canvas.drawRect(
        Rect.fromLTWH(x * unit, y * unit, unit, unit),
        paint,
      );
    }

    // Left plate (outer)
    for (int y = 3; y <= 8; y++) {
      drawPx(1, y, darkPaint);
    }
    // Left plate (inner)
    for (int y = 2; y <= 9; y++) {
      drawPx(2, y, metalPaint);
      drawPx(3, y, darkPaint);
    }

    // Bar handle in middle
    for (int x = 4; x <= 7; x++) {
      drawPx(x, 5, accentPaint);
      drawPx(x, 6, accentPaint);
    }

    // Right plate (inner)
    for (int y = 2; y <= 9; y++) {
      drawPx(8, y, darkPaint);
      drawPx(9, y, metalPaint);
    }
    // Right plate (outer)
    for (int y = 3; y <= 8; y++) {
      drawPx(10, y, darkPaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// Pixel Torii Gate / Japanese Icon 🇯🇵 / ⛩️
class PixelJapaneseIcon extends StatelessWidget {
  final double size;
  const PixelJapaneseIcon({super.key, this.size = 24.0});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(
        painter: _PixelJapanesePainter(),
      ),
    );
  }
}

class _PixelJapanesePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final unit = size.width / 12.0;

    final redPaint = Paint()..color = const Color(0xFFE11D48);
    final blackPaint = Paint()..color = const Color(0xFF0F172A);

    void drawPx(int x, int y, Paint paint) {
      canvas.drawRect(
        Rect.fromLTWH(x * unit, y * unit, unit, unit),
        paint,
      );
    }

    // Top beam (curved ends)
    drawPx(0, 2, blackPaint);
    for (int x = 1; x <= 10; x++) {
      drawPx(x, 2, redPaint);
      drawPx(x, 3, redPaint);
    }
    drawPx(11, 2, blackPaint);

    // Second beam
    for (int x = 2; x <= 9; x++) {
      drawPx(x, 5, blackPaint);
    }

    // Two main pillars
    for (int y = 3; y <= 11; y++) {
      drawPx(3, y, redPaint);
      drawPx(8, y, redPaint);
    }

    // Center tablet / plaque
    drawPx(5, 4, blackPaint);
    drawPx(6, 4, blackPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// Pixel English / Book Icon 🇬🇧 / 📚
class PixelEnglishIcon extends StatelessWidget {
  final double size;
  const PixelEnglishIcon({super.key, this.size = 24.0});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(
        painter: _PixelEnglishPainter(),
      ),
    );
  }
}

class _PixelEnglishPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final unit = size.width / 12.0;

    final bluePaint = Paint()..color = const Color(0xFF0284C7);
    final goldPaint = Paint()..color = const Color(0xFFFFAF00);
    final whitePaint = Paint()..color = Colors.white;
    final darkPaint = Paint()..color = const Color(0xFF0F172A);

    void drawPx(int x, int y, Paint paint) {
      canvas.drawRect(
        Rect.fromLTWH(x * unit, y * unit, unit, unit),
        paint,
      );
    }

    // Book cover
    for (int x = 2; x <= 9; x++) {
      for (int y = 2; y <= 10; y++) {
        drawPx(x, y, bluePaint);
      }
    }

    // Spine
    for (int y = 2; y <= 10; y++) {
      drawPx(1, y, darkPaint);
    }

    // Pages edge
    for (int x = 2; x <= 9; x++) {
      drawPx(x, 10, whitePaint);
    }

    // Gold "A" letter in pixel
    drawPx(5, 4, goldPaint);
    drawPx(6, 4, goldPaint);
    drawPx(4, 5, goldPaint);
    drawPx(7, 5, goldPaint);
    drawPx(4, 6, goldPaint);
    drawPx(5, 6, goldPaint);
    drawPx(6, 6, goldPaint);
    drawPx(7, 6, goldPaint);
    drawPx(4, 7, goldPaint);
    drawPx(7, 7, goldPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// Pixel Heart ❤️
class PixelHeartIcon extends StatelessWidget {
  final double size;
  final bool isFilled;
  const PixelHeartIcon({super.key, this.size = 18.0, this.isFilled = true});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(
        painter: _PixelHeartPainter(isFilled),
      ),
    );
  }
}

class _PixelHeartPainter extends CustomPainter {
  final bool isFilled;
  _PixelHeartPainter(this.isFilled);

  @override
  void paint(Canvas canvas, Size size) {
    final unit = size.width / 10.0;
    final heartPaint = Paint()..color = isFilled ? const Color(0xFFEF4444) : const Color(0xFFCBD5E1);

    void drawPx(int x, int y) {
      canvas.drawRect(
        Rect.fromLTWH(x * unit, y * unit, unit, unit),
        heartPaint,
      );
    }

    final coords = [
      [1, 1], [2, 1], [6, 1], [7, 1],
      [0, 2], [1, 2], [2, 2], [3, 2], [5, 2], [6, 2], [7, 2], [8, 2],
      [0, 3], [1, 3], [2, 3], [3, 3], [4, 3], [5, 3], [6, 3], [7, 3], [8, 3],
      [1, 4], [2, 4], [3, 4], [4, 4], [5, 4], [6, 4], [7, 4],
      [2, 5], [3, 5], [4, 5], [5, 5], [6, 5],
      [3, 6], [4, 6], [5, 6],
      [4, 7],
    ];

    for (final c in coords) {
      drawPx(c[0], c[1]);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
