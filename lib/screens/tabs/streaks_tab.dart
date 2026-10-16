import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/habit_streak_model.dart';
import '../../models/pomodoro_model.dart';
import '../../providers/pomodoro_provider.dart';
import '../../providers/streak_provider.dart';
import '../../widgets/pixel_icons.dart';
import '../../widgets/pixel_widgets.dart';

class StreaksTab extends ConsumerWidget {
  final Function(int tabIndex)? onNavigateTab;

  const StreaksTab({super.key, this.onNavigateTab});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final habits = ref.watch(habitsProvider);

    int totalActiveStreaks = 0;
    int completedTodayCount = 0;
    int bestStreakOverall = 0;

    for (final h in habits) {
      if (h.currentStreak > 0) totalActiveStreaks++;
      if (h.isCompletedToday) completedTodayCount++;
      if (h.bestStreak > bestStreakOverall) bestStreakOverall = h.bestStreak;
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF1F5F9),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // 1. Overall Streak Fire Banner
            PixelCard(
              backgroundColor: const Color(0xFF0F172A),
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  const PixelFlameIcon(size: 38),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'CHUỖI RÈN LUYỆN (STREAKS)',
                          style: TextStyle(
                            fontFamily: 'monospace',
                            fontWeight: FontWeight.w900,
                            fontSize: 13,
                            color: Color(0xFFFA520F),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Đang duy trì: $totalActiveStreaks chuỗi hoạt động 🔥\n'
                          'Hôm nay: $completedTodayCount/${habits.length} hoàn thành | Kỷ lục: $bestStreakOverall ngày',
                          style: const TextStyle(
                            fontFamily: 'monospace',
                            fontSize: 11,
                            color: Color(0xFFCBD5E1),
                            height: 1.4,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // 2. Action row: Header + Add button
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'CÁC MỤC TIÊU CỦA BẠN',
                  style: TextStyle(
                    fontFamily: 'monospace',
                    fontWeight: FontWeight.w900,
                    fontSize: 12,
                    color: Color(0xFF1E1E1E),
                  ),
                ),
                PixelButton(
                  isSmall: true,
                  backgroundColor: const Color(0xFF16A34A),
                  onPressed: () => _showAddHabitDialog(context, ref),
                  child: const Row(
                    children: [
                      Icon(Icons.add, size: 14, color: Colors.white),
                      SizedBox(width: 4),
                      Text('THÊM MỤC TIÊU'),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),

            // 3. List of Habit Cards
            for (final habit in habits) ...[
              _buildHabitCard(context, ref, habit),
              const SizedBox(height: 14),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildHabitCard(BuildContext context, WidgetRef ref, HabitStreak habit) {
    Widget iconWidget;
    switch (habit.category) {
      case HabitCategory.exercise:
        iconWidget = const PixelDumbbellIcon(size: 26);
        break;
      case HabitCategory.english:
        iconWidget = const PixelEnglishIcon(size: 26);
        break;
      case HabitCategory.japanese:
        iconWidget = const PixelJapaneseIcon(size: 26);
        break;
      case HabitCategory.custom:
        iconWidget = const PixelFlameIcon(size: 26);
        break;
    }

    final isDoneToday = habit.isCompletedToday;

    return PixelCard(
      backgroundColor: Colors.white,
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header: Icon + Title + Streak Fire Badge
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFFF8FAFC),
                  border: Border.all(color: Colors.black, width: 2),
                ),
                child: iconWidget,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      habit.title,
                      style: const TextStyle(
                        fontFamily: 'monospace',
                        fontWeight: FontWeight.w900,
                        fontSize: 14,
                        color: Color(0xFF1E1E1E),
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Mục tiêu: ${habit.targetMinutesPerDay} phút/ngày',
                      style: const TextStyle(
                        fontFamily: 'monospace',
                        fontSize: 10,
                        color: Color(0xFF64748B),
                      ),
                    ),
                  ],
                ),
              ),
              // Flame Streak Tag
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: habit.currentStreak > 0 ? const Color(0xFFFEF2F2) : const Color(0xFFF1F5F9),
                  border: Border.all(
                    color: habit.currentStreak > 0 ? const Color(0xFFDC2626) : Colors.black,
                    width: 2,
                  ),
                ),
                child: Row(
                  children: [
                    const PixelFlameIcon(size: 16),
                    const SizedBox(width: 4),
                    Text(
                      '${habit.currentStreak} NGÀY',
                      style: TextStyle(
                        fontFamily: 'monospace',
                        fontWeight: FontWeight.w900,
                        fontSize: 11,
                        color: habit.currentStreak > 0 ? const Color(0xFFDC2626) : const Color(0xFF64748B),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),

          // 7-Day Week Dots (T2 -> CN)
          _buildWeeklyDots(habit),
          const SizedBox(height: 14),

          // Action Buttons: Check-in & Focus Now
          Row(
            children: [
              // Check-in Button
              Expanded(
                child: PixelButton(
                  isSmall: true,
                  backgroundColor: isDoneToday ? const Color(0xFF94A3B8) : const Color(0xFF16A34A),
                  onPressed: isDoneToday
                      ? null
                      : () {
                          ref.read(habitsProvider.notifier).checkInHabit(habit.id);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('🎉 Đã điểm danh "${habit.title}"! Thú cưng nhận thêm EXP!'),
                              backgroundColor: const Color(0xFF1E1E1E),
                              duration: const Duration(seconds: 2),
                            ),
                          );
                        },
                  child: Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(isDoneToday ? Icons.check_circle : Icons.check, size: 14, color: Colors.white),
                        const SizedBox(width: 6),
                        Text(isDoneToday ? 'ĐÃ CHECK-IN' : 'CHECK-IN HÔM NAY'),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),

              // Focus Timer Shortcut Button
              PixelButton(
                isSmall: true,
                backgroundColor: const Color(0xFFFA520F),
                onPressed: () {
                  ref.read(pomodoroProvider.notifier).selectHabit(habit.id, habit.title);
                  ref.read(pomodoroProvider.notifier).setMode(PomodoroMode.focus);
                  onNavigateTab?.call(0); // Switch to Focus & Pet tab
                },
                child: const Row(
                  children: [
                    Icon(Icons.timer_outlined, size: 14, color: Colors.white),
                    SizedBox(width: 4),
                    Text('BẬT TIMER'),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildWeeklyDots(HabitStreak habit) {
    final now = DateTime.now();
    // Monday of current week
    final monday = now.subtract(Duration(days: now.weekday - 1));
    const labels = ['T2', 'T3', 'T4', 'T5', 'T6', 'T7', 'CN'];

    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        border: Border.all(color: const Color(0xFFE2E8F0), width: 1.5),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          for (int i = 0; i < 7; i++) ...[
            Builder(builder: (context) {
              final day = monday.add(Duration(days: i));
              final isDone = habit.isCompletedOn(day);
              final isToday = day.year == now.year && day.month == now.month && day.day == now.day;

              return Column(
                children: [
                  Text(
                    labels[i],
                    style: TextStyle(
                      fontFamily: 'monospace',
                      fontSize: 9,
                      fontWeight: isToday ? FontWeight.w900 : FontWeight.bold,
                      color: isToday ? const Color(0xFFFA520F) : const Color(0xFF64748B),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Container(
                    width: 22,
                    height: 22,
                    decoration: BoxDecoration(
                      color: isDone ? const Color(0xFF16A34A) : Colors.white,
                      border: Border.all(
                        color: isToday ? const Color(0xFFFA520F) : Colors.black,
                        width: isToday ? 2 : 1.5,
                      ),
                    ),
                    child: isDone
                        ? const Icon(Icons.check, size: 14, color: Colors.white)
                        : (isToday ? Container(margin: const EdgeInsets.all(5), color: const Color(0xFFFA520F)) : null),
                  ),
                ],
              );
            }),
          ],
        ],
      ),
    );
  }

  void _showAddHabitDialog(BuildContext context, WidgetRef ref) {
    final titleController = TextEditingController();
    HabitCategory selectedCategory = HabitCategory.exercise;
    int targetMinutes = 25;

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
          backgroundColor: Colors.white,
          title: const Text(
            'THÊM MỤC TIÊU STREAK',
            style: TextStyle(fontFamily: 'monospace', fontWeight: FontWeight.w900, fontSize: 14),
          ),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Tên hoạt động:',
                  style: TextStyle(fontFamily: 'monospace', fontSize: 11, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                TextField(
                  controller: titleController,
                  decoration: const InputDecoration(
                    hintText: 'VD: Chạy bộ, Luyện nghe JLPT, Ôn từ vựng...',
                    border: OutlineInputBorder(borderRadius: BorderRadius.zero),
                    isDense: true,
                  ),
                  style: const TextStyle(fontFamily: 'monospace', fontSize: 12),
                ),
                const SizedBox(height: 14),
                const Text(
                  'Loại hoạt động:',
                  style: TextStyle(fontFamily: 'monospace', fontSize: 11, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 6),
                DropdownButton<HabitCategory>(
                  value: selectedCategory,
                  isExpanded: true,
                  items: const [
                    DropdownMenuItem(value: HabitCategory.exercise, child: Text('🏋️ Tập thể dục / Gym')),
                    DropdownMenuItem(value: HabitCategory.english, child: Text('🇬🇧 Học English')),
                    DropdownMenuItem(value: HabitCategory.japanese, child: Text('🇯🇵 Học Japanese')),
                    DropdownMenuItem(value: HabitCategory.custom, child: Text('🎯 Thói quen khác')),
                  ],
                  onChanged: (val) {
                    if (val != null) setState(() => selectedCategory = val);
                  },
                ),
              ],
            ),
          ),
          actions: [
            PixelButton(
              isSmall: true,
              backgroundColor: const Color(0xFF64748B),
              onPressed: () => Navigator.pop(ctx),
              child: const Text('HỦY'),
            ),
            PixelButton(
              isSmall: true,
              backgroundColor: const Color(0xFF16A34A),
              onPressed: () {
                final text = titleController.text.trim();
                if (text.isNotEmpty) {
                  ref.read(habitsProvider.notifier).addHabit(
                    title: text,
                    category: selectedCategory,
                    targetMinutes: targetMinutes,
                    colorHex: '#FA520F',
                  );
                  Navigator.pop(ctx);
                }
              },
              child: const Text('LƯU'),
            ),
          ],
        ),
      ),
    );
  }
}
