import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/habit_streak_model.dart';
import '../services/notification_service.dart';
import 'pet_provider.dart';

class HabitsNotifier extends Notifier<List<HabitStreak>> {
  @override
  List<HabitStreak> build() {
    final storage = ref.watch(storageServiceProvider);
    final loaded = storage.loadHabits();
    _rescheduleReminders(loaded);
    return loaded;
  }

  void _rescheduleReminders(List<HabitStreak> habits) {
    Future.microtask(() async {
      for (final h in habits) {
        if (h.isReminderEnabled) {
          await NotificationService.instance.scheduleHabitReminder(h);
        }
      }
    });
  }

  Future<void> checkInHabit(String habitId, {int minutes = 25}) async {
    final currentList = List<HabitStreak>.from(state);
    final index = currentList.indexWhere((h) => h.id == habitId);
    if (index < 0) return;

    final target = currentList[index];
    final updated = target.markCompletedToday(minutes: minutes);
    currentList[index] = updated;

    state = currentList;
    await ref.read(storageServiceProvider).saveHabits(currentList);

    // Reward pet with bonus EXP for maintaining streak
    ref.read(petProvider.notifier).onPomodoroCompleted(minutesFocused: 15);
  }

  Future<void> addHabit({
    required String title,
    required HabitCategory category,
    required int targetMinutes,
    required String colorHex,
    int reminderHour = 20,
    int reminderMinute = 0,
    bool isReminderEnabled = true,
    List<int> reminderDays = const [1, 2, 3, 4, 5, 6, 7],
  }) async {
    final newHabit = HabitStreak(
      id: 'habit_${DateTime.now().millisecondsSinceEpoch}',
      title: title.trim(),
      category: category,
      targetMinutesPerDay: targetMinutes,
      colorHex: colorHex,
      createdAt: DateTime.now(),
      reminderHour: reminderHour,
      reminderMinute: reminderMinute,
      isReminderEnabled: isReminderEnabled,
      reminderDays: reminderDays,
    );

    final updated = [...state, newHabit];
    state = updated;
    await ref.read(storageServiceProvider).saveHabits(updated);

    if (isReminderEnabled) {
      await NotificationService.instance.scheduleHabitReminder(newHabit);
    }
  }

  Future<void> updateHabitReminder({
    required String habitId,
    required int reminderHour,
    required int reminderMinute,
    required List<int> reminderDays,
    required bool isReminderEnabled,
  }) async {
    final currentList = List<HabitStreak>.from(state);
    final index = currentList.indexWhere((h) => h.id == habitId);
    if (index < 0) return;

    final updated = currentList[index].copyWith(
      reminderHour: reminderHour,
      reminderMinute: reminderMinute,
      reminderDays: reminderDays,
      isReminderEnabled: isReminderEnabled,
    );
    currentList[index] = updated;

    state = currentList;
    await ref.read(storageServiceProvider).saveHabits(currentList);

    if (isReminderEnabled) {
      await NotificationService.instance.scheduleHabitReminder(updated);
    } else {
      await NotificationService.instance.cancelHabitReminder(habitId);
    }
  }

  Future<void> toggleReminder(String habitId) async {
    final currentList = List<HabitStreak>.from(state);
    final index = currentList.indexWhere((h) => h.id == habitId);
    if (index < 0) return;

    final target = currentList[index];
    final newEnabled = !target.isReminderEnabled;
    final updated = target.copyWith(isReminderEnabled: newEnabled);
    currentList[index] = updated;

    state = currentList;
    await ref.read(storageServiceProvider).saveHabits(currentList);

    if (newEnabled) {
      await NotificationService.instance.scheduleHabitReminder(updated);
    } else {
      await NotificationService.instance.cancelHabitReminder(habitId);
    }
  }

  Future<void> deleteHabit(String habitId) async {
    await NotificationService.instance.cancelHabitReminder(habitId);
    final updated = state.where((h) => h.id != habitId).toList();
    state = updated;
    await ref.read(storageServiceProvider).saveHabits(updated);
  }
}

final habitsProvider = NotifierProvider<HabitsNotifier, List<HabitStreak>>(HabitsNotifier.new);
