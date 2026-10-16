import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../models/pet_model.dart';

class PixelPetView extends StatefulWidget {
  final PixelPet pet;
  final double size;
  final bool isTimerRunning;
  final VoidCallback? onTap;

  const PixelPetView({
    super.key,
    required this.pet,
    this.size = 140.0,
    this.isTimerRunning = false,
    this.onTap,
  });

  @override
  State<PixelPetView> createState() => _PixelPetViewState();
}

class _PixelPetViewState extends State<PixelPetView> with SingleTickerProviderStateMixin {
  late AnimationController _animController;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: AnimatedBuilder(
        animation: _animController,
        builder: (context, child) {
          final bounce = widget.pet.mood == PetMood.sad
              ? 0.0 // Don't bounce when sad
              : (math.sin(_animController.value * math.pi) * (widget.pet.mood == PetMood.happy ? 6.0 : 3.0));

          return SizedBox(
            width: widget.size,
            height: widget.size + 10,
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Ground shadow pixel oval
                Positioned(
                  bottom: 4,
                  child: Container(
                    width: widget.size * 0.7,
                    height: 8,
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.zero,
                    ),
                  ),
                ),
                // Animated pet character
                Positioned(
                  bottom: 8 + bounce,
                  child: CustomPaint(
                    size: Size(widget.size, widget.size),
                    painter: _PixelPetPainter(
                      stage: widget.pet.stage,
                      mood: widget.isTimerRunning ? PetMood.focused : widget.pet.mood,
                      animValue: _animController.value,
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _PixelPetPainter extends CustomPainter {
  final PetStage stage;
  final PetMood mood;
  final double animValue;

  _PixelPetPainter({
    required this.stage,
    required this.mood,
    required this.animValue,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final double gridSize = 16.0;
    final double unit = size.width / gridSize;

    void px(int x, int y, Color color) {
      final paint = Paint()..color = color;
      canvas.drawRect(Rect.fromLTWH(x * unit, y * unit, unit, unit), paint);
    }

    final black = Colors.black;
    final white = Colors.white;
    final orange = const Color(0xFFFA520F); // Mistral signature
    final amber = const Color(0xFFFFAF00);
    final darkAmber = const Color(0xFFD97706);
    final tearBlue = const Color(0xFF38BDF8);
    final pinkCheek = const Color(0xFFFB7185);

    switch (stage) {
      case PetStage.egg:
        _drawEgg(px, black, white, amber, darkAmber, orange);
        break;
      case PetStage.baby:
        _drawBaby(px, black, white, amber, orange, pinkCheek, tearBlue);
        break;
      case PetStage.teen:
        _drawTeen(px, black, white, amber, orange, pinkCheek, tearBlue);
        break;
      case PetStage.adult:
      case PetStage.mythic:
        _drawAdult(px, black, white, amber, orange, pinkCheek, tearBlue, stage == PetStage.mythic);
        break;
    }

    // Mood decorations (tears for sad, hearts/sparkles for happy)
    if (mood == PetMood.sad) {
      // Tears streaming down
      final tearOffset = (animValue * 3).toInt();
      px(4, 9 + tearOffset, tearBlue);
      px(11, 9 + tearOffset, tearBlue);
    } else if (mood == PetMood.happy) {
      // Floating heart above
      px(7, 1, const Color(0xFFEF4444));
      px(8, 1, const Color(0xFFEF4444));
      px(6, 2, const Color(0xFFEF4444));
      px(7, 2, const Color(0xFFEF4444));
      px(8, 2, const Color(0xFFEF4444));
      px(9, 2, const Color(0xFFEF4444));
      px(7, 3, const Color(0xFFEF4444));
      px(8, 3, const Color(0xFFEF4444));
    }
  }

  void _drawEgg(Function px, Color black, Color white, Color amber, Color darkAmber, Color orange) {
    // 16x16 Egg
    final eggCoords = [
      [6, 3], [7, 3], [8, 3], [9, 3],
      [5, 4], [6, 4], [7, 4], [8, 4], [9, 4], [10, 4],
      [4, 5], [5, 5], [6, 5], [7, 5], [8, 5], [9, 5], [10, 5], [11, 5],
      [4, 6], [5, 6], [6, 6], [7, 6], [8, 6], [9, 6], [10, 6], [11, 6],
      [3, 7], [4, 7], [5, 7], [6, 7], [7, 7], [8, 7], [9, 7], [10, 7], [11, 7], [12, 7],
      [3, 8], [4, 8], [5, 8], [6, 8], [7, 8], [8, 8], [9, 8], [10, 8], [11, 8], [12, 8],
      [3, 9], [4, 9], [5, 9], [6, 9], [7, 9], [8, 9], [9, 9], [10, 9], [11, 9], [12, 9],
      [4, 10], [5, 10], [6, 10], [7, 10], [8, 10], [9, 10], [10, 10], [11, 10],
      [5, 11], [6, 11], [7, 11], [8, 11], [9, 11], [10, 11],
      [6, 12], [7, 12], [8, 12], [9, 12],
    ];

    for (final c in eggCoords) {
      px(c[0], c[1], amber);
    }

    // Spot patterns
    px(6, 6, orange);
    px(7, 6, orange);
    px(6, 7, orange);
    px(9, 8, orange);
    px(10, 8, orange);
    px(10, 9, orange);

    // Cute blinking eyes on egg
    if (mood != PetMood.sleeping) {
      px(6, 8, black);
      px(9, 8, black);
    }
  }

  void _drawBaby(Function px, Color black, Color white, Color amber, Color orange, Color pink, Color blue) {
    // Cute Baby Pixie (Cat/Fox ear creature)
    // Ears
    px(3, 3, orange);
    px(4, 3, orange);
    px(4, 4, orange);
    px(11, 3, orange);
    px(12, 3, orange);
    px(11, 4, orange);

    // Head/Body
    for (int y = 5; y <= 11; y++) {
      for (int x = 4; x <= 11; x++) {
        px(x, y, amber);
      }
    }

    // Cheeks
    px(4, 9, pink);
    px(11, 9, pink);

    // Eyes & Mouth based on mood
    if (mood == PetMood.sad) {
      // Crying slanted eyes
      px(5, 7, black);
      px(6, 8, black);
      px(10, 7, black);
      px(9, 8, black);
      // Frown mouth
      px(7, 10, black);
      px(8, 10, black);
      px(7, 9, black);
      px(8, 9, black);
    } else if (mood == PetMood.sleeping) {
      // Sleep lines
      px(5, 8, black);
      px(6, 8, black);
      px(9, 8, black);
      px(10, 8, black);
    } else {
      // Happy / Normal eyes
      px(6, 7, black);
      px(6, 8, black);
      px(9, 7, black);
      px(9, 8, black);
      // Sparkle
      px(6, 7, white);
      px(9, 7, white);
      // Smile
      px(7, 9, black);
      px(8, 9, black);
    }

    // Little paws
    px(5, 12, orange);
    px(6, 12, orange);
    px(9, 12, orange);
    px(10, 12, orange);
  }

  void _drawTeen(Function px, Color black, Color white, Color amber, Color orange, Color pink, Color blue) {
    // Teen creature with focus headband & scarf
    // Ears with inner color
    px(3, 2, orange);
    px(4, 2, orange);
    px(3, 3, orange);
    px(4, 3, pink);
    px(11, 2, orange);
    px(12, 2, orange);
    px(12, 3, orange);
    px(11, 3, pink);

    // Head
    for (int y = 4; y <= 10; y++) {
      for (int x = 3; x <= 12; x++) {
        px(x, y, amber);
      }
    }

    // Red Headband
    for (int x = 3; x <= 12; x++) {
      px(x, 4, const Color(0xFFDC2626));
    }
    px(7, 4, white); // Headband knot/badge
    px(8, 4, white);

    // Cheeks
    px(3, 8, pink);
    px(12, 8, pink);

    // Eyes
    if (mood == PetMood.sad) {
      px(5, 7, black);
      px(6, 7, black);
      px(9, 7, black);
      px(10, 7, black);
      // Down mouth
      px(7, 9, black);
      px(8, 9, black);
    } else {
      px(5, 6, black);
      px(5, 7, black);
      px(10, 6, black);
      px(10, 7, black);
      px(5, 6, white);
      px(10, 6, white);
      // Big smile
      px(7, 8, black);
      px(8, 8, black);
      px(7, 9, const Color(0xFFDC2626)); // Tongue
      px(8, 9, const Color(0xFFDC2626));
    }

    // Scarf around neck
    for (int x = 4; x <= 11; x++) {
      px(x, 11, const Color(0xFF0284C7));
    }

    // Body
    for (int y = 12; y <= 13; y++) {
      for (int x = 5; x <= 10; x++) {
        px(x, y, orange);
      }
    }

    // Boots
    px(4, 14, const Color(0xFF1E293B));
    px(5, 14, const Color(0xFF1E293B));
    px(10, 14, const Color(0xFF1E293B));
    px(11, 14, const Color(0xFF1E293B));
  }

  void _drawAdult(Function px, Color black, Color white, Color amber, Color orange, Color pink, Color blue, bool isMythic) {
    // Majestic creature / Mythic with horns & golden wings
    if (isMythic) {
      // Golden Crown / Halo
      px(6, 1, const Color(0xFFFBBF24));
      px(7, 0, const Color(0xFFFBBF24));
      px(8, 0, const Color(0xFFFBBF24));
      px(9, 1, const Color(0xFFFBBF24));
      px(7, 1, white);
      px(8, 1, white);
    }

    // Grand Horns / Crown
    px(2, 2, const Color(0xFFF59E0B));
    px(3, 3, const Color(0xFFF59E0B));
    px(13, 2, const Color(0xFFF59E0B));
    px(12, 3, const Color(0xFFF59E0B));

    // Full Face/Mane
    for (int y = 3; y <= 11; y++) {
      for (int x = 3; x <= 12; x++) {
        px(x, y, isMythic ? const Color(0xFFF97316) : amber);
      }
    }

    // Side Wings/Aura
    px(1, 6, isMythic ? const Color(0xFFFBBF24) : orange);
    px(2, 6, isMythic ? const Color(0xFFFBBF24) : orange);
    px(1, 7, isMythic ? const Color(0xFFFBBF24) : orange);
    px(13, 6, isMythic ? const Color(0xFFFBBF24) : orange);
    px(14, 6, isMythic ? const Color(0xFFFBBF24) : orange);
    px(14, 7, isMythic ? const Color(0xFFFBBF24) : orange);

    // Eyes
    if (mood == PetMood.sad) {
      px(5, 7, black);
      px(6, 8, black);
      px(10, 7, black);
      px(9, 8, black);
      px(7, 10, black);
      px(8, 10, black);
    } else {
      px(5, 6, black);
      px(5, 7, black);
      px(10, 6, black);
      px(10, 7, black);
      px(5, 6, isMythic ? const Color(0xFF38BDF8) : white);
      px(10, 6, isMythic ? const Color(0xFF38BDF8) : white);
      px(7, 9, black);
      px(8, 9, black);
    }

    // Claws/Paws
    for (int x = 4; x <= 11; x++) {
      px(x, 12, orange);
    }
    px(4, 13, black);
    px(5, 13, black);
    px(10, 13, black);
    px(11, 13, black);
  }

  @override
  bool shouldRepaint(covariant _PixelPetPainter oldDelegate) {
    return oldDelegate.stage != stage ||
        oldDelegate.mood != mood ||
        oldDelegate.animValue != animValue;
  }
}
