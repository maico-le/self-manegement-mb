import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/habit_streak_model.dart';
import '../../models/pomodoro_model.dart';
import '../../providers/pomodoro_provider.dart';
import '../../providers/streak_provider.dart';
import '../../services/notification_service.dart';
import '../../widgets/pixel_icons.dart';
import '../../widgets/pixel_widgets.dart';
import '../workout_screen.dart';

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
          const SizedBox(height: 12),

          // Scheduled Study Time & Notification Banner
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            decoration: BoxDecoration(
              color: habit.isReminderEnabled ? const Color(0xFFF0FDF4) : const Color(0xFFF8FAFC),
              border: Border.all(
                color: habit.isReminderEnabled ? const Color(0xFF86EFAC) : const Color(0xFFCBD5E1),
                width: 1.5,
              ),
            ),
            child: Row(
              children: [
                Icon(
                  habit.isReminderEnabled ? Icons.notifications_active : Icons.notifications_off_outlined,
                  size: 16,
                  color: habit.isReminderEnabled ? const Color(0xFF16A34A) : const Color(0xFF94A3B8),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        habit.isReminderEnabled
                            ? '⏰ Giờ học: ${habit.reminderTimeString} • ${habit.frequencyString}'
                            : '⏰ Báo thức học: Đang tắt',
                        style: TextStyle(
                          fontFamily: 'monospace',
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: habit.isReminderEnabled ? const Color(0xFF166534) : const Color(0xFF64748B),
                        ),
                      ),
                      Text(
                        habit.isReminderEnabled
                            ? 'Báo thức tự động giữ streak'
                            : 'Nhấn bút chì để bật thông báo',
                        style: const TextStyle(
                          fontFamily: 'monospace',
                          fontSize: 9,
                          color: Color(0xFF64748B),
                        ),
                      ),
                    ],
                  ),
                ),
                // Test notification button
                InkWell(
                  onTap: () {
                    NotificationService.instance.showTestHabitReminderNotification(habit);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('🔔 Đã bắn thông báo thử nghiệm cho "${habit.title}"!'),
                        backgroundColor: const Color(0xFF1E1E1E),
                        duration: const Duration(seconds: 2),
                      ),
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: Colors.black, width: 1.5),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.volume_up, size: 12, color: Color(0xFFFA520F)),
                        SizedBox(width: 3),
                        Text(
                          'THỬ CHUÔNG',
                          style: TextStyle(
                            fontFamily: 'monospace',
                            fontSize: 9,
                            fontWeight: FontWeight.w900,
                            color: Color(0xFFFA520F),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 6),
                // Edit schedule button
                InkWell(
                  onTap: () => _showEditReminderDialog(context, ref, habit),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: Colors.black, width: 1.5),
                    ),
                    child: const Icon(Icons.edit_calendar, size: 14, color: Color(0xFF1E1E1E)),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),

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
          if (habit.category == HabitCategory.exercise) ...[
            const SizedBox(height: 8),
            PixelButton(
              isSmall: true,
              backgroundColor: const Color(0xFF0F172A),
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (_) => const WorkoutScreen()));
              },
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  PixelDumbbellIcon(size: 14),
                  SizedBox(width: 8),
                  Text('VÀO BÀI TẬP (PLANK, HÍT ĐẤT CÓ BÁO THỨC ⏰)'),
                ],
              ),
            ),
          ],
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
    HabitCategory selectedCategory = HabitCategory.english;
    int targetMinutes = 25;
    TimeOfDay selectedTime = const TimeOfDay(hour: 19, minute: 30);
    List<int> selectedDays = [1, 2, 3, 4, 5, 6, 7]; // Default all days
    bool enableReminder = true;

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setState) {
          final isAllDays = selectedDays.length == 7;
          final isWeekdays = selectedDays.length == 5 &&
              selectedDays.contains(1) &&
              selectedDays.contains(2) &&
              selectedDays.contains(3) &&
              selectedDays.contains(4) &&
              selectedDays.contains(5);
          final isWeekend = selectedDays.length == 2 && selectedDays.contains(6) && selectedDays.contains(7);

          return AlertDialog(
            shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
            backgroundColor: Colors.white,
            title: const Text(
              'THÊM MỤC TIÊU STREAK MỚI',
              style: TextStyle(fontFamily: 'monospace', fontWeight: FontWeight.w900, fontSize: 14),
            ),
            content: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Tên hoạt động / Kỹ năng:',
                    style: TextStyle(fontFamily: 'monospace', fontSize: 11, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  TextField(
                    controller: titleController,
                    decoration: const InputDecoration(
                      hintText: 'VD: Học Tiếng Anh (IELTS), Học Tiếng Nhật (N3)...',
                      border: OutlineInputBorder(borderRadius: BorderRadius.zero),
                      isDense: true,
                    ),
                    style: const TextStyle(fontFamily: 'monospace', fontSize: 12),
                  ),
                  const SizedBox(height: 12),

                  const Text(
                    'Loại hoạt động:',
                    style: TextStyle(fontFamily: 'monospace', fontSize: 11, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 6),
                  DropdownButton<HabitCategory>(
                    value: selectedCategory,
                    isExpanded: true,
                    items: const [
                      DropdownMenuItem(value: HabitCategory.english, child: Text('🇬🇧 Học English')),
                      DropdownMenuItem(value: HabitCategory.japanese, child: Text('🇯🇵 Học Japanese')),
                      DropdownMenuItem(value: HabitCategory.exercise, child: Text('🏋️ Tập thể dục / Gym')),
                      DropdownMenuItem(value: HabitCategory.custom, child: Text('🎯 Kỹ năng khác')),
                    ],
                    onChanged: (val) {
                      if (val != null) setState(() => selectedCategory = val);
                    },
                  ),
                  const SizedBox(height: 12),

                  // Target duration
                  const Text(
                    'Thời lượng mục tiêu:',
                    style: TextStyle(fontFamily: 'monospace', fontSize: 11, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 6),
                  Wrap(
                    spacing: 8,
                    children: [15, 25, 45, 60].map((mins) {
                      final isSel = targetMinutes == mins;
                      return ChoiceChip(
                        label: Text('$mins phút', style: TextStyle(fontFamily: 'monospace', fontSize: 11, color: isSel ? Colors.white : Colors.black)),
                        selected: isSel,
                        selectedColor: const Color(0xFFFA520F),
                        backgroundColor: const Color(0xFFF1F5F9),
                        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
                        onSelected: (selected) {
                          if (selected) setState(() => targetMinutes = mins);
                        },
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 14),

                  // Reminder Toggle
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Thông báo nhắc học:',
                        style: TextStyle(fontFamily: 'monospace', fontSize: 11, fontWeight: FontWeight.bold),
                      ),
                      Switch(
                        value: enableReminder,
                        activeThumbColor: const Color(0xFF16A34A),
                        onChanged: (val) => setState(() => enableReminder = val),
                      ),
                    ],
                  ),

                  if (enableReminder) ...[
                    const SizedBox(height: 6),
                    // Time selector
                    InkWell(
                      onTap: () async {
                        final picked = await showTimePicker(
                          context: context,
                          initialTime: selectedTime,
                        );
                        if (picked != null) {
                          setState(() => selectedTime = picked);
                        }
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF8FAFC),
                          border: Border.all(color: Colors.black, width: 1.5),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Row(
                              children: [
                                Icon(Icons.access_time, size: 16, color: Color(0xFFFA520F)),
                                SizedBox(width: 8),
                                Text(
                                  'Giờ học mỗi ngày:',
                                  style: TextStyle(fontFamily: 'monospace', fontSize: 11, fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                            Text(
                              '${selectedTime.hour.toString().padLeft(2, '0')}:${selectedTime.minute.toString().padLeft(2, '0')}',
                              style: const TextStyle(
                                fontFamily: 'monospace',
                                fontSize: 14,
                                fontWeight: FontWeight.w900,
                                color: Color(0xFFFA520F),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Frequency selector
                    const Text(
                      'Tần suất lặp lại:',
                      style: TextStyle(fontFamily: 'monospace', fontSize: 11, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 6),
                    Wrap(
                      spacing: 6,
                      runSpacing: 6,
                      children: [
                        FilterChip(
                          label: const Text('Hàng ngày', style: TextStyle(fontFamily: 'monospace', fontSize: 10)),
                          selected: isAllDays,
                          selectedColor: const Color(0xFFDC2626),
                          labelStyle: TextStyle(color: isAllDays ? Colors.white : Colors.black),
                          shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
                          onSelected: (_) => setState(() => selectedDays = [1, 2, 3, 4, 5, 6, 7]),
                        ),
                        FilterChip(
                          label: const Text('T2 - T6', style: TextStyle(fontFamily: 'monospace', fontSize: 10)),
                          selected: isWeekdays,
                          selectedColor: const Color(0xFFDC2626),
                          labelStyle: TextStyle(color: isWeekdays ? Colors.white : Colors.black),
                          shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
                          onSelected: (_) => setState(() => selectedDays = [1, 2, 3, 4, 5]),
                        ),
                        FilterChip(
                          label: const Text('T7 - CN', style: TextStyle(fontFamily: 'monospace', fontSize: 10)),
                          selected: isWeekend,
                          selectedColor: const Color(0xFFDC2626),
                          labelStyle: TextStyle(color: isWeekend ? Colors.white : Colors.black),
                          shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
                          onSelected: (_) => setState(() => selectedDays = [6, 7]),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),

                    // Individual Day Toggle Row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        for (int d = 1; d <= 7; d++) ...[
                          Builder(builder: (context) {
                            const dNames = {1: 'T2', 2: 'T3', 3: 'T4', 4: 'T5', 5: 'T6', 6: 'T7', 7: 'CN'};
                            final isSel = selectedDays.contains(d);
                            return InkWell(
                              onTap: () {
                                setState(() {
                                  if (isSel) {
                                    if (selectedDays.length > 1) selectedDays.remove(d);
                                  } else {
                                    selectedDays.add(d);
                                    selectedDays.sort();
                                  }
                                });
                              },
                              child: Container(
                                width: 28,
                                height: 28,
                                decoration: BoxDecoration(
                                  color: isSel ? const Color(0xFF16A34A) : Colors.white,
                                  border: Border.all(color: Colors.black, width: 1.5),
                                ),
                                child: Center(
                                  child: Text(
                                    dNames[d]!,
                                    style: TextStyle(
                                      fontFamily: 'monospace',
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                      color: isSel ? Colors.white : Colors.black,
                                    ),
                                  ),
                                ),
                              ),
                            );
                          }),
                        ],
                      ],
                    ),
                  ],
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
                      reminderHour: selectedTime.hour,
                      reminderMinute: selectedTime.minute,
                      isReminderEnabled: enableReminder,
                      reminderDays: selectedDays,
                    );
                    Navigator.pop(ctx);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('✅ Đã tạo mục tiêu "$text" với thông báo lúc ${selectedTime.hour.toString().padLeft(2, '0')}:${selectedTime.minute.toString().padLeft(2, '0')}!'),
                        backgroundColor: const Color(0xFF16A34A),
                      ),
                    );
                  }
                },
                child: const Text('LƯU MỤC TIÊU'),
              ),
            ],
          );
        },
      ),
    );
  }

  void _showEditReminderDialog(BuildContext context, WidgetRef ref, HabitStreak habit) {
    TimeOfDay selectedTime = TimeOfDay(hour: habit.reminderHour, minute: habit.reminderMinute);
    List<int> selectedDays = List<int>.from(habit.reminderDays);
    bool enableReminder = habit.isReminderEnabled;

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setState) {
          final isAllDays = selectedDays.length == 7;
          final isWeekdays = selectedDays.length == 5 &&
              selectedDays.contains(1) &&
              selectedDays.contains(2) &&
              selectedDays.contains(3) &&
              selectedDays.contains(4) &&
              selectedDays.contains(5);
          final isWeekend = selectedDays.length == 2 && selectedDays.contains(6) && selectedDays.contains(7);

          return AlertDialog(
            shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
            backgroundColor: Colors.white,
            title: Text(
              'LỊCH BÁO THỨC: ${habit.title.toUpperCase()}',
              style: const TextStyle(fontFamily: 'monospace', fontWeight: FontWeight.w900, fontSize: 13),
            ),
            content: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Bật chuông thông báo:',
                        style: TextStyle(fontFamily: 'monospace', fontSize: 11, fontWeight: FontWeight.bold),
                      ),
                      Switch(
                        value: enableReminder,
                        activeThumbColor: const Color(0xFF16A34A),
                        onChanged: (val) => setState(() => enableReminder = val),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),

                  // Pick study time
                  InkWell(
                    onTap: () async {
                      final picked = await showTimePicker(
                        context: context,
                        initialTime: selectedTime,
                      );
                      if (picked != null) {
                        setState(() => selectedTime = picked);
                      }
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF8FAFC),
                        border: Border.all(color: Colors.black, width: 1.5),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Row(
                            children: [
                              Icon(Icons.alarm, size: 16, color: Color(0xFFFA520F)),
                              SizedBox(width: 8),
                              Text(
                                'Giờ học:',
                                style: TextStyle(fontFamily: 'monospace', fontSize: 11, fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                          Text(
                            '${selectedTime.hour.toString().padLeft(2, '0')}:${selectedTime.minute.toString().padLeft(2, '0')}',
                            style: const TextStyle(
                              fontFamily: 'monospace',
                              fontSize: 16,
                              fontWeight: FontWeight.w900,
                              color: Color(0xFFFA520F),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),

                  const Text(
                    'Tần suất lặp lại:',
                    style: TextStyle(fontFamily: 'monospace', fontSize: 11, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 6),
                  Wrap(
                    spacing: 6,
                    runSpacing: 6,
                    children: [
                      FilterChip(
                        label: const Text('Hàng ngày', style: TextStyle(fontFamily: 'monospace', fontSize: 10)),
                        selected: isAllDays,
                        selectedColor: const Color(0xFFDC2626),
                        labelStyle: TextStyle(color: isAllDays ? Colors.white : Colors.black),
                        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
                        onSelected: (_) => setState(() => selectedDays = [1, 2, 3, 4, 5, 6, 7]),
                      ),
                      FilterChip(
                        label: const Text('T2 - T6', style: TextStyle(fontFamily: 'monospace', fontSize: 10)),
                        selected: isWeekdays,
                        selectedColor: const Color(0xFFDC2626),
                        labelStyle: TextStyle(color: isWeekdays ? Colors.white : Colors.black),
                        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
                        onSelected: (_) => setState(() => selectedDays = [1, 2, 3, 4, 5]),
                      ),
                      FilterChip(
                        label: const Text('T7 - CN', style: TextStyle(fontFamily: 'monospace', fontSize: 10)),
                        selected: isWeekend,
                        selectedColor: const Color(0xFFDC2626),
                        labelStyle: TextStyle(color: isWeekend ? Colors.white : Colors.black),
                        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
                        onSelected: (_) => setState(() => selectedDays = [6, 7]),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),

                  // Individual Day Toggle Row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      for (int d = 1; d <= 7; d++) ...[
                        Builder(builder: (context) {
                          const dNames = {1: 'T2', 2: 'T3', 3: 'T4', 4: 'T5', 5: 'T6', 6: 'T7', 7: 'CN'};
                          final isSel = selectedDays.contains(d);
                          return InkWell(
                            onTap: () {
                              setState(() {
                                if (isSel) {
                                  if (selectedDays.length > 1) selectedDays.remove(d);
                                } else {
                                  selectedDays.add(d);
                                  selectedDays.sort();
                                }
                              });
                            },
                            child: Container(
                              width: 28,
                              height: 28,
                              decoration: BoxDecoration(
                                color: isSel ? const Color(0xFF16A34A) : Colors.white,
                                border: Border.all(color: Colors.black, width: 1.5),
                              ),
                              child: Center(
                                child: Text(
                                  dNames[d]!,
                                  style: TextStyle(
                                    fontFamily: 'monospace',
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                    color: isSel ? Colors.white : Colors.black,
                                  ),
                                ),
                              ),
                            ),
                          );
                        }),
                      ],
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Delete habit button
                  Center(
                    child: TextButton.icon(
                      style: TextButton.styleFrom(foregroundColor: const Color(0xFFDC2626)),
                      onPressed: () {
                        ref.read(habitsProvider.notifier).deleteHabit(habit.id);
                        Navigator.pop(ctx);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('🗑️ Đã xóa mục tiêu "${habit.title}"'),
                            backgroundColor: const Color(0xFF1E1E1E),
                          ),
                        );
                      },
                      icon: const Icon(Icons.delete_outline, size: 16),
                      label: const Text('Xóa mục tiêu này', style: TextStyle(fontFamily: 'monospace', fontSize: 11)),
                    ),
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
                  ref.read(habitsProvider.notifier).updateHabitReminder(
                    habitId: habit.id,
                    reminderHour: selectedTime.hour,
                    reminderMinute: selectedTime.minute,
                    reminderDays: selectedDays,
                    isReminderEnabled: enableReminder,
                  );
                  Navigator.pop(ctx);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('💾 Đã cập nhật lịch học "${habit.title}"!'),
                      backgroundColor: const Color(0xFF16A34A),
                    ),
                  );
                },
                child: const Text('CẬP NHẬT'),
              ),
            ],
          );
        },
      ),
    );
  }
}
