enum ExerciseType {
  duration('Thời gian (Đếm ngược ⏱️)'),
  reps('Số lần (Reps x Sets 🔢)');

  final String label;
  const ExerciseType(this.label);
}

class ExerciseItem {
  final String id;
  final String name;
  final ExerciseType type;
  final int durationSeconds; // For duration type (e.g. 60s for Plank)
  final int targetReps; // For reps type (e.g. 15 reps)
  final int targetSets; // Number of sets (e.g. 3 sets)
  final int completedSetsToday;
  final bool isCompletedToday;

  const ExerciseItem({
    required this.id,
    required this.name,
    required this.type,
    this.durationSeconds = 60,
    this.targetReps = 15,
    this.targetSets = 3,
    this.completedSetsToday = 0,
    this.isCompletedToday = false,
  });

  String get summaryLabel {
    if (type == ExerciseType.duration) {
      if (durationSeconds >= 60) {
        final m = durationSeconds ~/ 60;
        final s = durationSeconds % 60;
        return s == 0 ? '$m phút đếm ngược' : '$m phút $s giây';
      }
      return '$durationSeconds giây đếm ngược';
    } else {
      return '$targetReps reps x $targetSets hiệp';
    }
  }

  ExerciseItem copyWith({
    String? id,
    String? name,
    ExerciseType? type,
    int? durationSeconds,
    int? targetReps,
    int? targetSets,
    int? completedSetsToday,
    bool? isCompletedToday,
  }) {
    return ExerciseItem(
      id: id ?? this.id,
      name: name ?? this.name,
      type: type ?? this.type,
      durationSeconds: durationSeconds ?? this.durationSeconds,
      targetReps: targetReps ?? this.targetReps,
      targetSets: targetSets ?? this.targetSets,
      completedSetsToday: completedSetsToday ?? this.completedSetsToday,
      isCompletedToday: isCompletedToday ?? this.isCompletedToday,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'type': type.name,
    'durationSeconds': durationSeconds,
    'targetReps': targetReps,
    'targetSets': targetSets,
    'completedSetsToday': completedSetsToday,
    'isCompletedToday': isCompletedToday,
  };

  factory ExerciseItem.fromJson(Map<String, dynamic> json) {
    ExerciseType parsedType = ExerciseType.duration;
    try {
      parsedType = ExerciseType.values.firstWhere((t) => t.name == json['type']);
    } catch (_) {}

    return ExerciseItem(
      id: json['id'] as String,
      name: json['name'] as String,
      type: parsedType,
      durationSeconds: json['durationSeconds'] as int? ?? 60,
      targetReps: json['targetReps'] as int? ?? 15,
      targetSets: json['targetSets'] as int? ?? 3,
      completedSetsToday: json['completedSetsToday'] as int? ?? 0,
      isCompletedToday: json['isCompletedToday'] as bool? ?? false,
    );
  }
}
