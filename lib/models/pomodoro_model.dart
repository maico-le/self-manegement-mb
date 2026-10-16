enum PomodoroMode {
  focus('Tập Trung', 25 * 60),
  shortBreak('Nghỉ Ngắn', 5 * 60),
  longBreak('Nghỉ Dài', 15 * 60);

  final String label;
  final int defaultSeconds;
  const PomodoroMode(this.label, this.defaultSeconds);
}

enum TimerStatus {
  idle,
  running,
  paused,
  completed,
  givenUp,
}

class PomodoroSession {
  final String id;
  final String? habitId;
  final String habitTitle;
  final int durationSeconds;
  final DateTime completedAt;
  final bool wasSuccessful;

  const PomodoroSession({
    required this.id,
    this.habitId,
    required this.habitTitle,
    required this.durationSeconds,
    required this.completedAt,
    required this.wasSuccessful,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'habitId': habitId,
    'habitTitle': habitTitle,
    'durationSeconds': durationSeconds,
    'completedAt': completedAt.toIso8601String(),
    'wasSuccessful': wasSuccessful,
  };

  factory PomodoroSession.fromJson(Map<String, dynamic> json) {
    return PomodoroSession(
      id: json['id'] as String,
      habitId: json['habitId'] as String?,
      habitTitle: json['habitTitle'] as String? ?? 'Tập Trung',
      durationSeconds: json['durationSeconds'] as int? ?? 1500,
      completedAt: DateTime.tryParse(json['completedAt'] as String? ?? '') ?? DateTime.now(),
      wasSuccessful: json['wasSuccessful'] as bool? ?? true,
    );
  }
}
