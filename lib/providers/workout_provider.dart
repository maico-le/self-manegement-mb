import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/workout_model.dart';
import '../services/notification_service.dart';
import 'pet_provider.dart';
import 'streak_provider.dart';

// --- Exercise List Provider ---
class ExercisesNotifier extends Notifier<List<ExerciseItem>> {
  @override
  List<ExerciseItem> build() {
    final storage = ref.watch(storageServiceProvider);
    return storage.loadExercises();
  }

  Future<void> addExercise({
    required String name,
    required ExerciseType type,
    int durationSeconds = 60,
    int targetReps = 15,
    int targetSets = 3,
  }) async {
    final newItem = ExerciseItem(
      id: 'ex_${DateTime.now().millisecondsSinceEpoch}',
      name: name.trim(),
      type: type,
      durationSeconds: durationSeconds,
      targetReps: targetReps,
      targetSets: targetSets,
    );

    final updated = [...state, newItem];
    state = updated;
    await ref.read(storageServiceProvider).saveExercises(updated);
  }

  Future<void> deleteExercise(String id) async {
    final updated = state.where((e) => e.id != id).toList();
    state = updated;
    await ref.read(storageServiceProvider).saveExercises(updated);
  }

  Future<void> completeExercise(String id) async {
    final current = List<ExerciseItem>.from(state);
    final idx = current.indexWhere((e) => e.id == id);
    if (idx < 0) return;

    final target = current[idx];
    current[idx] = target.copyWith(isCompletedToday: true);
    state = current;
    await ref.read(storageServiceProvider).saveExercises(current);

    // Reward Pet with EXP
    await ref.read(petProvider.notifier).onPomodoroCompleted(minutesFocused: 10);

    // Auto check-in the fitness streak habit
    await ref.read(habitsProvider.notifier).checkInHabit('habit_fitness', minutes: 10);
  }

  Future<void> incrementSet(String id) async {
    final current = List<ExerciseItem>.from(state);
    final idx = current.indexWhere((e) => e.id == id);
    if (idx < 0) return;

    final target = current[idx];
    final newCompletedSets = target.completedSetsToday + 1;
    final isDone = newCompletedSets >= target.targetSets;

    current[idx] = target.copyWith(
      completedSetsToday: newCompletedSets,
      isCompletedToday: isDone ? true : target.isCompletedToday,
    );
    state = current;
    await ref.read(storageServiceProvider).saveExercises(current);

    if (isDone) {
      await ref.read(petProvider.notifier).onPomodoroCompleted(minutesFocused: 15);
      await ref.read(habitsProvider.notifier).checkInHabit('habit_fitness', minutes: 15);
    }
  }
}

final exercisesProvider = NotifierProvider<ExercisesNotifier, List<ExerciseItem>>(ExercisesNotifier.new);

// --- Active Countdown Timer Provider (For Plank / Duration exercises) ---
enum ExerciseTimerStatus { idle, running, paused, finished }

class ExerciseTimerState {
  final ExerciseItem? exercise;
  final int totalSeconds;
  final int remainingSeconds;
  final ExerciseTimerStatus status;

  const ExerciseTimerState({
    this.exercise,
    this.totalSeconds = 60,
    this.remainingSeconds = 60,
    this.status = ExerciseTimerStatus.idle,
  });

  double get progress {
    if (totalSeconds <= 0) return 0.0;
    return (totalSeconds - remainingSeconds) / totalSeconds;
  }

  String get formattedTime {
    final m = (remainingSeconds ~/ 60).toString().padLeft(2, '0');
    final s = (remainingSeconds % 60).toString().padLeft(2, '0');
    return '$m:$s';
  }

  ExerciseTimerState copyWith({
    ExerciseItem? exercise,
    int? totalSeconds,
    int? remainingSeconds,
    ExerciseTimerStatus? status,
  }) {
    return ExerciseTimerState(
      exercise: exercise ?? this.exercise,
      totalSeconds: totalSeconds ?? this.totalSeconds,
      remainingSeconds: remainingSeconds ?? this.remainingSeconds,
      status: status ?? this.status,
    );
  }
}

class ExerciseTimerNotifier extends Notifier<ExerciseTimerState> {
  Timer? _timer;

  @override
  ExerciseTimerState build() {
    ref.onDispose(() {
      _timer?.cancel();
    });
    return const ExerciseTimerState();
  }

  void loadExercise(ExerciseItem exercise) {
    _timer?.cancel();
    final secs = exercise.durationSeconds;
    state = ExerciseTimerState(
      exercise: exercise,
      totalSeconds: secs,
      remainingSeconds: secs,
      status: ExerciseTimerStatus.idle,
    );
  }

  void start() {
    if (state.status == ExerciseTimerStatus.running) return;

    state = state.copyWith(status: ExerciseTimerStatus.running);
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (state.remainingSeconds > 1) {
        state = state.copyWith(remainingSeconds: state.remainingSeconds - 1);
      } else {
        _onFinish();
      }
    });
  }

  void pause() {
    if (state.status != ExerciseTimerStatus.running) return;
    _timer?.cancel();
    state = state.copyWith(status: ExerciseTimerStatus.paused);
  }

  void resume() {
    if (state.status != ExerciseTimerStatus.paused) return;
    start();
  }

  void reset() {
    _timer?.cancel();
    state = state.copyWith(
      remainingSeconds: state.totalSeconds,
      status: ExerciseTimerStatus.idle,
    );
  }

  Future<void> _onFinish() async {
    _timer?.cancel();
    final ex = state.exercise;

    state = state.copyWith(
      remainingSeconds: 0,
      status: ExerciseTimerStatus.finished,
    );

    if (ex != null) {
      // 1. Alarm local notification
      await NotificationService.instance.showExerciseAlarmNotification(
        exerciseName: ex.name,
        seconds: state.totalSeconds,
      );

      // 2. Mark exercise completed & reward Pet
      await ref.read(exercisesProvider.notifier).completeExercise(ex.id);
    }
  }
}

final exerciseTimerProvider =
    NotifierProvider<ExerciseTimerNotifier, ExerciseTimerState>(ExerciseTimerNotifier.new);
