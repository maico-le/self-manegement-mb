enum HabitCategory {
  exercise('Tập thể dục', 'fitness'),
  english('Học English', 'english'),
  japanese('Học Japanese', 'japanese'),
  custom('Kỹ năng khác', 'custom');

  final String title;
  final String iconKey;
  const HabitCategory(this.title, this.iconKey);
}

class HabitStreak {
  final String id;
  final String title;
  final HabitCategory category;
  final int currentStreak;
  final int bestStreak;
  final List<String> completedDateStrings; // format 'YYYY-MM-DD'
  final int targetMinutesPerDay;
  final int totalMinutesSpent;
  final String colorHex;
  final DateTime createdAt;

  // Notification & Scheduling properties
  final int reminderHour;
  final int reminderMinute;
  final bool isReminderEnabled;
  final List<int> reminderDays; // 1 = Monday, 7 = Sunday

  const HabitStreak({
    required this.id,
    required this.title,
    required this.category,
    this.currentStreak = 0,
    this.bestStreak = 0,
    this.completedDateStrings = const [],
    this.targetMinutesPerDay = 25,
    this.totalMinutesSpent = 0,
    this.colorHex = '#FA520F',
    required this.createdAt,
    this.reminderHour = 20,
    this.reminderMinute = 0,
    this.isReminderEnabled = true,
    this.reminderDays = const [1, 2, 3, 4, 5, 6, 7], // Default daily
  });

  String get reminderTimeString {
    final h = reminderHour.toString().padLeft(2, '0');
    final m = reminderMinute.toString().padLeft(2, '0');
    return '$h:$m';
  }

  String get frequencyString {
    if (reminderDays.length == 7) return 'Hàng ngày';
    if (reminderDays.length == 5 &&
        reminderDays.contains(1) &&
        reminderDays.contains(2) &&
        reminderDays.contains(3) &&
        reminderDays.contains(4) &&
        reminderDays.contains(5)) {
      return 'T2 - T6 (Ngày thường)';
    }
    if (reminderDays.length == 2 && reminderDays.contains(6) && reminderDays.contains(7)) {
      return 'T7 - CN (Cuối tuần)';
    }
    const dayNames = {1: 'T2', 2: 'T3', 3: 'T4', 4: 'T5', 5: 'T6', 6: 'T7', 7: 'CN'};
    final names = reminderDays.map((d) => dayNames[d] ?? '').where((s) => s.isNotEmpty).toList();
    return names.isEmpty ? 'Không lặp lại' : names.join(', ');
  }

  static String _toDateKey(DateTime date) {
    return '${date.year.toString().padLeft(4, '0')}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }

  bool isCompletedOn(DateTime date) {
    final key = _toDateKey(date);
    return completedDateStrings.contains(key);
  }

  bool get isCompletedToday => isCompletedOn(DateTime.now());

  /// Calculates dynamic streak given completion dates
  int calculateCurrentStreak() {
    if (completedDateStrings.isEmpty) return 0;

    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final todayKey = _toDateKey(today);
    final yesterday = today.subtract(const Duration(days: 1));
    final yesterdayKey = _toDateKey(yesterday);

    // If neither today nor yesterday is completed, streak is broken
    if (!completedDateStrings.contains(todayKey) && !completedDateStrings.contains(yesterdayKey)) {
      return 0;
    }

    int streak = 0;
    DateTime checkDate = completedDateStrings.contains(todayKey) ? today : yesterday;

    while (completedDateStrings.contains(_toDateKey(checkDate))) {
      streak++;
      checkDate = checkDate.subtract(const Duration(days: 1));
    }

    return streak;
  }

  HabitStreak markCompletedToday({int minutes = 0}) {
    final now = DateTime.now();
    final key = _toDateKey(now);
    final newDates = List<String>.from(completedDateStrings);
    if (!newDates.contains(key)) {
      newDates.add(key);
    }

    final updated = copyWith(
      completedDateStrings: newDates,
      totalMinutesSpent: totalMinutesSpent + minutes,
    );
    final newStreak = updated.calculateCurrentStreak();
    final newBest = newStreak > bestStreak ? newStreak : bestStreak;

    return updated.copyWith(
      currentStreak: newStreak,
      bestStreak: newBest,
    );
  }

  HabitStreak copyWith({
    String? id,
    String? title,
    HabitCategory? category,
    int? currentStreak,
    int? bestStreak,
    List<String>? completedDateStrings,
    int? targetMinutesPerDay,
    int? totalMinutesSpent,
    String? colorHex,
    DateTime? createdAt,
    int? reminderHour,
    int? reminderMinute,
    bool? isReminderEnabled,
    List<int>? reminderDays,
  }) {
    return HabitStreak(
      id: id ?? this.id,
      title: title ?? this.title,
      category: category ?? this.category,
      currentStreak: currentStreak ?? this.currentStreak,
      bestStreak: bestStreak ?? this.bestStreak,
      completedDateStrings: completedDateStrings ?? this.completedDateStrings,
      targetMinutesPerDay: targetMinutesPerDay ?? this.targetMinutesPerDay,
      totalMinutesSpent: totalMinutesSpent ?? this.totalMinutesSpent,
      colorHex: colorHex ?? this.colorHex,
      createdAt: createdAt ?? this.createdAt,
      reminderHour: reminderHour ?? this.reminderHour,
      reminderMinute: reminderMinute ?? this.reminderMinute,
      isReminderEnabled: isReminderEnabled ?? this.isReminderEnabled,
      reminderDays: reminderDays ?? this.reminderDays,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'category': category.name,
    'currentStreak': currentStreak,
    'bestStreak': bestStreak,
    'completedDateStrings': completedDateStrings,
    'targetMinutesPerDay': targetMinutesPerDay,
    'totalMinutesSpent': totalMinutesSpent,
    'colorHex': colorHex,
    'createdAt': createdAt.toIso8601String(),
    'reminderHour': reminderHour,
    'reminderMinute': reminderMinute,
    'isReminderEnabled': isReminderEnabled,
    'reminderDays': reminderDays,
  };

  factory HabitStreak.fromJson(Map<String, dynamic> json) {
    HabitCategory cat = HabitCategory.custom;
    try {
      cat = HabitCategory.values.firstWhere((c) => c.name == json['category']);
    } catch (_) {}

    final dates = (json['completedDateStrings'] as List?)
            ?.map((e) => e.toString())
            .toList() ??
        [];

    final daysList = (json['reminderDays'] as List?)
            ?.map((e) => int.tryParse(e.toString()) ?? 1)
            .toList() ??
        [1, 2, 3, 4, 5, 6, 7];

    final habit = HabitStreak(
      id: json['id'] as String,
      title: json['title'] as String,
      category: cat,
      currentStreak: json['currentStreak'] as int? ?? 0,
      bestStreak: json['bestStreak'] as int? ?? 0,
      completedDateStrings: dates,
      targetMinutesPerDay: json['targetMinutesPerDay'] as int? ?? 25,
      totalMinutesSpent: json['totalMinutesSpent'] as int? ?? 0,
      colorHex: json['colorHex'] as String? ?? '#FA520F',
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'] as String) ?? DateTime.now()
          : DateTime.now(),
      reminderHour: json['reminderHour'] as int? ?? 20,
      reminderMinute: json['reminderMinute'] as int? ?? 0,
      isReminderEnabled: json['isReminderEnabled'] as bool? ?? true,
      reminderDays: daysList,
    );

    // Refresh streak dynamically based on current date
    final liveStreak = habit.calculateCurrentStreak();
    return habit.copyWith(
      currentStreak: liveStreak,
      bestStreak: liveStreak > habit.bestStreak ? liveStreak : habit.bestStreak,
    );
  }
}
