import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/habit_streak_model.dart';
import 'pet_provider.dart';

class HabitsNotifier extends Notifier<List<HabitStreak>> {
  @override
  List<HabitStreak> build() {
    final storage = ref.watch(storageServiceProvider);
    return storage.loadHabits();
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
  }) async {
    final newHabit = HabitStreak(
      id: 'habit_${DateTime.now().millisecondsSinceEpoch}',
      title: title.trim(),
      category: category,
      targetMinutesPerDay: targetMinutes,
      colorHex: colorHex,
      createdAt: DateTime.now(),
    );

    final updated = [...state, newHabit];
    state = updated;
    await ref.read(storageServiceProvider).saveHabits(updated);
  }

  Future<void> deleteHabit(String habitId) async {
    final updated = state.where((h) => h.id != habitId).toList();
    state = updated;
    await ref.read(storageServiceProvider).saveHabits(updated);
  }
}

final habitsProvider = NotifierProvider<HabitsNotifier, List<HabitStreak>>(HabitsNotifier.new);
