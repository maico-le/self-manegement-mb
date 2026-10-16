import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/pomodoro_model.dart';
import '../services/notification_service.dart';
import 'pet_provider.dart';
import 'streak_provider.dart';

class PomodoroState {
  final PomodoroMode mode;
  final TimerStatus status;
  final int totalSeconds;
  final int remainingSeconds;
  final String? selectedHabitId;
  final String selectedHabitTitle;

  const PomodoroState({
    this.mode = PomodoroMode.focus,
    this.status = TimerStatus.idle,
    this.totalSeconds = 25 * 60,
    this.remainingSeconds = 25 * 60,
    this.selectedHabitId,
    this.selectedHabitTitle = 'Tập thể dục',
  });

  double get progress {
    if (totalSeconds <= 0) return 0.0;
    return (totalSeconds - remainingSeconds) / totalSeconds;
  }

  String get formattedTime {
    final m = (remainingSeconds / 60).floor().toString().padLeft(2, '0');
    final s = (remainingSeconds % 60).toString().padLeft(2, '0');
    return '$m:$s';
  }

  PomodoroState copyWith({
    PomodoroMode? mode,
    TimerStatus? status,
    int? totalSeconds,
    int? remainingSeconds,
    String? selectedHabitId,
    String? selectedHabitTitle,
  }) {
    return PomodoroState(
      mode: mode ?? this.mode,
      status: status ?? this.status,
      totalSeconds: totalSeconds ?? this.totalSeconds,
      remainingSeconds: remainingSeconds ?? this.remainingSeconds,
      selectedHabitId: selectedHabitId ?? this.selectedHabitId,
      selectedHabitTitle: selectedHabitTitle ?? this.selectedHabitTitle,
    );
  }
}

class PomodoroNotifier extends Notifier<PomodoroState> {
  Timer? _ticker;

  @override
  PomodoroState build() {
    ref.onDispose(() {
      _ticker?.cancel();
    });

    final storage = ref.watch(storageServiceProvider);
    final focusMins = storage.getFocusDurationMinutes();

    return PomodoroState(
      mode: PomodoroMode.focus,
      status: TimerStatus.idle,
      totalSeconds: focusMins * 60,
      remainingSeconds: focusMins * 60,
      selectedHabitId: 'habit_fitness',
      selectedHabitTitle: 'Tập thể dục',
    );
  }

  void selectHabit(String? habitId, String habitTitle) {
    if (state.status == TimerStatus.running) return; // Cannot change during active session
    state = state.copyWith(
      selectedHabitId: habitId,
      selectedHabitTitle: habitTitle,
    );
  }

  void setMode(PomodoroMode mode) {
    _ticker?.cancel();
    final storage = ref.read(storageServiceProvider);
    int seconds = mode.defaultSeconds;
    if (mode == PomodoroMode.focus) {
      seconds = storage.getFocusDurationMinutes() * 60;
    } else if (mode == PomodoroMode.shortBreak) {
      seconds = storage.getShortBreakMinutes() * 60;
    }

    state = state.copyWith(
      mode: mode,
      status: TimerStatus.idle,
      totalSeconds: seconds,
      remainingSeconds: seconds,
    );
  }

  void start() {
    if (state.status == TimerStatus.running) return;

    state = state.copyWith(status: TimerStatus.running);
    _ticker?.cancel();
    _ticker = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (state.remainingSeconds > 1) {
        state = state.copyWith(remainingSeconds: state.remainingSeconds - 1);
      } else {
        _onCompleted();
      }
    });
  }

  void pause() {
    if (state.status != TimerStatus.running) return;
    _ticker?.cancel();
    state = state.copyWith(status: TimerStatus.paused);
  }

  void resume() {
    if (state.status != TimerStatus.paused) return;
    start();
  }

  Future<void> giveUp() async {
    _ticker?.cancel();

    // Pet becomes sad when user gives up halfway
    await ref.read(petProvider.notifier).onPomodoroGivenUp();

    // Reset timer to idle
    final storage = ref.read(storageServiceProvider);
    final seconds = state.mode == PomodoroMode.focus
        ? storage.getFocusDurationMinutes() * 60
        : state.mode.defaultSeconds;

    state = state.copyWith(
      status: TimerStatus.givenUp,
      remainingSeconds: seconds,
    );

    // After 2 seconds, transition back to idle
    Future.delayed(const Duration(seconds: 2), () {
      if (state.status == TimerStatus.givenUp) {
        state = state.copyWith(status: TimerStatus.idle);
      }
    });
  }

  Future<void> _onCompleted() async {
    _ticker?.cancel();

    final minutes = (state.totalSeconds / 60).round();

    if (state.mode == PomodoroMode.focus) {
      // 1. Reward Pet (Grows up, gains EXP, becomes Happy)
      await ref.read(petProvider.notifier).onPomodoroCompleted(minutesFocused: minutes);

      // 2. Mark linked Habit Streak as completed for today
      if (state.selectedHabitId != null) {
        await ref.read(habitsProvider.notifier).checkInHabit(
          state.selectedHabitId!,
          minutes: minutes,
        );
      }

      // 3. Save session history
      final session = PomodoroSession(
        id: 'session_${DateTime.now().millisecondsSinceEpoch}',
        habitId: state.selectedHabitId,
        habitTitle: state.selectedHabitTitle,
        durationSeconds: state.totalSeconds,
        completedAt: DateTime.now(),
        wasSuccessful: true,
      );
      await ref.read(storageServiceProvider).addSession(session);

      // 4. Send completion notification
      await NotificationService.instance.showTimerCompleteNotification(
        title: '🎉 Hoàn thành phiên tập trung!',
        body: 'Thú cưng Pixie đã nhận được EXP và đang rất vui! Hãy dành 5 phút nghỉ ngơi nhé.',
      );
    } else {
      // Break finished notification
      await NotificationService.instance.showTimerCompleteNotification(
        title: '⏰ Giờ nghỉ kết thúc!',
        body: 'Sẵn sàng bắt đầu phiên tập trung mới cùng thú cưng chưa nào?',
      );
    }

    state = state.copyWith(
      status: TimerStatus.completed,
      remainingSeconds: 0,
    );
  }

  void reset() {
    _ticker?.cancel();
    state = state.copyWith(
      status: TimerStatus.idle,
      remainingSeconds: state.totalSeconds,
    );
  }
}

final pomodoroProvider = NotifierProvider<PomodoroNotifier, PomodoroState>(PomodoroNotifier.new);
