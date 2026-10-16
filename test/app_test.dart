import 'package:flutter_test/flutter_test.dart';
import 'package:self_management_mb/models/habit_streak_model.dart';
import 'package:self_management_mb/models/pet_model.dart';
import 'package:self_management_mb/models/workout_model.dart';

void main() {
  group('PixelPet Evolution & EXP Tests', () {
    test('Pet starts at Egg stage and evolves to Baby at 51 EXP', () {
      final petEgg = PixelPet(
        name: 'Pixie',
        currentExp: 20,
        lastInteraction: DateTime.now(),
      );

      expect(petEgg.stage, PetStage.egg);
      expect(petEgg.calculatedLevel, 1);

      final petBaby = petEgg.copyWith(currentExp: 80);
      expect(petBaby.stage, PetStage.baby);
      expect(petBaby.calculatedLevel, 4);

      final petMythic = petBaby.copyWith(currentExp: 800);
      expect(petMythic.stage, PetStage.mythic);
      expect(petMythic.calculatedLevel, greaterThanOrEqualTo(20));
    });

    test('Pet mood changes and speech reflection', () {
      final pet = PixelPet(
        name: 'Pixie',
        mood: PetMood.sad,
        lastInteraction: DateTime.now(),
      );

      expect(pet.mood, PetMood.sad);
    });
  });

  group('HabitStreak & Daily Calculation Tests', () {
    test('Calculate streak correctly for consecutive days', () {
      final now = DateTime.now();
      String toKey(DateTime d) =>
          '${d.year.toString().padLeft(4, '0')}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';

      final todayKey = toKey(now);
      final yesterdayKey = toKey(now.subtract(const Duration(days: 1)));
      final twoDaysAgoKey = toKey(now.subtract(const Duration(days: 2)));

      final habit = HabitStreak(
        id: 'habit_fitness',
        title: 'Tập thể dục',
        category: HabitCategory.exercise,
        completedDateStrings: [todayKey, yesterdayKey, twoDaysAgoKey],
        createdAt: now.subtract(const Duration(days: 10)),
      );

      expect(habit.calculateCurrentStreak(), 3);
      expect(habit.isCompletedToday, true);
    });

    test('Marking habit completed today increments streak', () {
      final habit = HabitStreak(
        id: 'habit_english',
        title: 'Học English',
        category: HabitCategory.english,
        completedDateStrings: const [],
        createdAt: DateTime.now(),
      );

      expect(habit.isCompletedToday, false);
      expect(habit.currentStreak, 0);

      final completed = habit.markCompletedToday(minutes: 25);
      expect(completed.isCompletedToday, true);
      expect(completed.currentStreak, 1);
      expect(completed.bestStreak, 1);
    });
  });

  group('Workout ExerciseItem Tests', () {
    test('Plank duration exercise formatting', () {
      const plank = ExerciseItem(
        id: 'ex_plank',
        name: 'Plank bụng',
        type: ExerciseType.duration,
        durationSeconds: 60,
      );

      expect(plank.type, ExerciseType.duration);
      expect(plank.durationSeconds, 60);
      expect(plank.summaryLabel, '1 phút đếm ngược');
    });

    test('Push-up reps exercise formatting', () {
      const pushup = ExerciseItem(
        id: 'ex_pushup',
        name: 'Hít đất',
        type: ExerciseType.reps,
        targetReps: 15,
        targetSets: 3,
      );

      expect(pushup.type, ExerciseType.reps);
      expect(pushup.summaryLabel, '15 reps x 3 hiệp');
    });
  });
}
