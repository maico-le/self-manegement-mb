import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/pomodoro_model.dart';
import '../../providers/pet_provider.dart';
import '../../providers/pomodoro_provider.dart';
import '../../providers/streak_provider.dart';
import '../../widgets/pixel_icons.dart';
import '../../widgets/pixel_pet_view.dart';
import '../../widgets/pixel_widgets.dart';

class FocusPetTab extends ConsumerWidget {
  const FocusPetTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pet = ref.watch(petProvider);
    final pomo = ref.watch(pomodoroProvider);
    final habits = ref.watch(habitsProvider);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // 1. Pet Stats Header Banner
          PixelCard(
            backgroundColor: Colors.white,
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Text(
                          pet.name.toUpperCase(),
                          style: const TextStyle(
                            fontFamily: 'monospace',
                            fontWeight: FontWeight.w900,
                            fontSize: 16,
                            color: Color(0xFF1E1E1E),
                          ),
                        ),
                        const SizedBox(width: 8),
                        PixelBadge(
                          text: 'LV.${pet.level}',
                          backgroundColor: const Color(0xFFFA520F),
                        ),
                      ],
                    ),
                    PixelBadge(
                      text: pet.stage.label,
                      backgroundColor: const Color(0xFFFFAF00),
                      textColor: Colors.black,
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'EXP: ${pet.currentExp} / ${pet.stage.maxExp}',
                      style: const TextStyle(
                        fontFamily: 'monospace',
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF64748B),
                      ),
                    ),
                    Text(
                      'Tâm trạng: ${pet.mood.label}',
                      style: const TextStyle(
                        fontFamily: 'monospace',
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF475569),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                PixelProgressBar(
                  progress: pet.stageProgress,
                  progressColor: const Color(0xFF16A34A),
                  height: 14,
                  label: '${(pet.stageProgress * 100).toInt()}% TIẾN HÓA',
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),

          // 2. Pet Interactive Arena & Speech Box
          PixelCard(
            backgroundColor: const Color(0xFFFEF3C7), // Warm retro arena
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
            child: Column(
              children: [
                // Speech Bubble
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.zero,
                    border: Border.all(color: Colors.black, width: 2),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black,
                        offset: Offset(2, 2),
                        blurRadius: 0,
                      ),
                    ],
                  ),
                  child: Text(
                    '💬 "${pet.speechText}"',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontFamily: 'monospace',
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1E1E1E),
                    ),
                  ),
                ),
                const SizedBox(height: 14),

                // Animated Custom Painter Pet
                PixelPetView(
                  pet: pet,
                  size: 130,
                  isTimerRunning: pomo.status == TimerStatus.running,
                  onTap: () {
                    ref.read(petProvider.notifier).tapPet();
                  },
                ),
                const SizedBox(height: 6),
                const Text(
                  '👉 Chạm vào thú cưng để tương tác',
                  style: TextStyle(
                    fontFamily: 'monospace',
                    fontSize: 10,
                    color: Color(0xFF94A3B8),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),

          // 3. Goal / Habit Attachment Selector
          PixelCard(
            backgroundColor: Colors.white,
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  children: [
                    Text(
                      'MỤC TIÊU PHIÊN NÀY:',
                      style: TextStyle(
                        fontFamily: 'monospace',
                        fontWeight: FontWeight.w900,
                        fontSize: 11,
                        color: Color(0xFF64748B),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    for (final h in habits)
                      _buildHabitChip(
                        ref: ref,
                        habitId: h.id,
                        title: h.title,
                        category: h.category,
                        isSelected: pomo.selectedHabitId == h.id,
                      ),
                    _buildHabitChip(
                      ref: ref,
                      habitId: null,
                      title: '🎯 Tập trung chung',
                      isSelected: pomo.selectedHabitId == null,
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),

          // 4. Retro Pomodoro Timer Clock Display
          PixelCard(
            backgroundColor: Colors.white,
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                // Mode Selector Buttons
                Row(
                  children: [
                    _buildModeButton(ref, pomo, PomodoroMode.focus),
                    const SizedBox(width: 6),
                    _buildModeButton(ref, pomo, PomodoroMode.shortBreak),
                    const SizedBox(width: 6),
                    _buildModeButton(ref, pomo, PomodoroMode.longBreak),
                  ],
                ),
                const SizedBox(height: 18),

                // Digital Retro Time Display
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 24),
                  decoration: BoxDecoration(
                    color: const Color(0xFF0F172A), // Retro terminal screen
                    borderRadius: BorderRadius.zero,
                    border: Border.all(color: Colors.black, width: 3),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black,
                        offset: Offset(4, 4),
                        blurRadius: 0,
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Text(
                        pomo.formattedTime,
                        style: TextStyle(
                          fontFamily: 'monospace',
                          fontSize: 54,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 4,
                          color: pomo.status == TimerStatus.running
                              ? const Color(0xFF22C55E) // Bright Green
                              : (pomo.status == TimerStatus.givenUp
                                  ? const Color(0xFFEF4444)
                                  : const Color(0xFFFA520F)), // Orange
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        pomo.status == TimerStatus.running
                            ? '⏳ ĐANG TẬP TRUNG...'
                            : (pomo.status == TimerStatus.paused
                                ? '⏸️ ĐANG TẠM DỪNG'
                                : (pomo.status == TimerStatus.givenUp
                                    ? '💔 BỎ CUỘC - THÚ BUỒN'
                                    : 'SẴN SÀNG')),
                        style: const TextStyle(
                          fontFamily: 'monospace',
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF94A3B8),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 18),

                // Timer Action Buttons
                if (pomo.status == TimerStatus.idle || pomo.status == TimerStatus.completed || pomo.status == TimerStatus.givenUp)
                  PixelButton(
                    backgroundColor: const Color(0xFFFA520F),
                    onPressed: () {
                      ref.read(pomodoroProvider.notifier).start();
                    },
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    child: const Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.play_arrow, size: 20, color: Colors.white),
                          SizedBox(width: 8),
                          Text(
                            'BẮT ĐẦU TẬP TRUNG',
                            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w900),
                          ),
                        ],
                      ),
                    ),
                  )
                else
                  Row(
                    children: [
                      // Pause / Resume
                      Expanded(
                        child: PixelButton(
                          backgroundColor: pomo.status == TimerStatus.running
                              ? const Color(0xFFFFAF00)
                              : const Color(0xFF16A34A),
                          textColor: pomo.status == TimerStatus.running ? Colors.black : Colors.white,
                          onPressed: () {
                            if (pomo.status == TimerStatus.running) {
                              ref.read(pomodoroProvider.notifier).pause();
                            } else {
                              ref.read(pomodoroProvider.notifier).resume();
                            }
                          },
                          child: Center(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  pomo.status == TimerStatus.running ? Icons.pause : Icons.play_arrow,
                                  size: 16,
                                  color: pomo.status == TimerStatus.running ? Colors.black : Colors.white,
                                ),
                                const SizedBox(width: 6),
                                Text(pomo.status == TimerStatus.running ? 'TẠM DỪNG' : 'TIẾP TỤC'),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      // Give Up (Pet becomes sad!)
                      Expanded(
                        child: PixelButton(
                          backgroundColor: const Color(0xFFEF4444),
                          onPressed: () {
                            _showGiveUpDialog(context, ref);
                          },
                          child: const Center(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.close, size: 16, color: Colors.white),
                                SizedBox(width: 6),
                                Text('BỎ CUỘC'),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildModeButton(WidgetRef ref, PomodoroState pomo, PomodoroMode mode) {
    final isSelected = pomo.mode == mode;
    return Expanded(
      child: PixelButton(
        isSmall: true,
        backgroundColor: isSelected ? const Color(0xFFFA520F) : const Color(0xFFE2E8F0),
        textColor: isSelected ? Colors.white : const Color(0xFF1E1E1E),
        onPressed: () {
          ref.read(pomodoroProvider.notifier).setMode(mode);
        },
        child: Center(
          child: Text(mode.label),
        ),
      ),
    );
  }

  Widget _buildHabitChip({
    required WidgetRef ref,
    required String? habitId,
    required String title,
    dynamic category,
    required bool isSelected,
  }) {
    Widget? iconWidget;
    if (category != null) {
      if (category.name == 'exercise') {
        iconWidget = const PixelDumbbellIcon(size: 14);
      } else if (category.name == 'english') {
        iconWidget = const PixelEnglishIcon(size: 14);
      } else if (category.name == 'japanese') {
        iconWidget = const PixelJapaneseIcon(size: 14);
      }
    }

    return GestureDetector(
      onTap: () {
        ref.read(pomodoroProvider.notifier).selectHabit(habitId, title);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFFA520F) : const Color(0xFFF1F5F9),
          borderRadius: BorderRadius.zero,
          border: Border.all(color: Colors.black, width: 2),
          boxShadow: isSelected
              ? const [
                  BoxShadow(
                    color: Colors.black,
                    offset: Offset(2, 2),
                    blurRadius: 0,
                  ),
                ]
              : null,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (iconWidget != null) ...[
              iconWidget,
              const SizedBox(width: 6),
            ],
            Text(
              title,
              style: TextStyle(
                fontFamily: 'monospace',
                fontWeight: FontWeight.bold,
                fontSize: 11,
                color: isSelected ? Colors.white : const Color(0xFF1E1E1E),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showGiveUpDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
        backgroundColor: Colors.white,
        title: const Text(
          '💔 BỎ CUỘC GIỮA CHỪNG?',
          style: TextStyle(
            fontFamily: 'monospace',
            fontWeight: FontWeight.w900,
            fontSize: 15,
            color: Color(0xFFEF4444),
          ),
        ),
        content: const Text(
          'Nếu dừng lại ngay bây giờ, thú cưng Pixie sẽ rất buồn 😭 và phiên tập trung này sẽ không được tính điểm EXP.\n\nBạn có chắc chắn muốn bỏ dở?',
          style: TextStyle(fontFamily: 'monospace', fontSize: 12, height: 1.5),
        ),
        actions: [
          PixelButton(
            isSmall: true,
            backgroundColor: const Color(0xFF16A34A),
            onPressed: () => Navigator.pop(ctx),
            child: const Text('CỐ TIẾP!'),
          ),
          PixelButton(
            isSmall: true,
            backgroundColor: const Color(0xFFEF4444),
            onPressed: () {
              Navigator.pop(ctx);
              ref.read(pomodoroProvider.notifier).giveUp();
            },
            child: const Text('BỎ CUỘC'),
          ),
        ],
      ),
    );
  }
}
