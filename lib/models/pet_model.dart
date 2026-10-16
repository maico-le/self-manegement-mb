enum PetStage {
  egg('Trứng Pixel', 1, 0, 50),
  baby('Thú Con (Bé)', 2, 51, 150),
  teen('Thiếu Niên', 5, 151, 350),
  adult('Trưởng Thành', 10, 351, 700),
  mythic('Thần Thú Pixel', 20, 701, 99999);

  final String label;
  final int minLevel;
  final int minExp;
  final int maxExp;

  const PetStage(this.label, this.minLevel, this.minExp, this.maxExp);
}

enum PetMood {
  happy('Hạnh phúc 💖'),
  excited('Rất phấn chấn! 🎉'),
  focused('Đang tập trung 🎯'),
  neutral('Bình thường 🌿'),
  sad('Buồn bã 😭'),
  sleeping('Đang ngủ khò 💤');

  final String label;
  const PetMood(this.label);
}

class PixelPet {
  final String name;
  final int level;
  final int currentExp;
  final int totalPomodorosCompleted;
  final int totalMinutesFocused;
  final int giveUpCount;
  final PetMood mood;
  final DateTime lastInteraction;
  final String speechText;

  const PixelPet({
    this.name = 'Pixie',
    this.level = 1,
    this.currentExp = 0,
    this.totalPomodorosCompleted = 0,
    this.totalMinutesFocused = 0,
    this.giveUpCount = 0,
    this.mood = PetMood.happy,
    required this.lastInteraction,
    this.speechText = 'Chào bạn! Cùng nhau tập trung nào!',
  });

  PetStage get stage {
    if (currentExp < 50) return PetStage.egg;
    if (currentExp < 150) return PetStage.baby;
    if (currentExp < 350) return PetStage.teen;
    if (currentExp < 700) return PetStage.adult;
    return PetStage.mythic;
  }

  int get calculatedLevel {
    // 1 level per 25 EXP
    return (currentExp / 25).floor() + 1;
  }

  double get stageProgress {
    final s = stage;
    if (s == PetStage.mythic) return 1.0;
    final range = s.maxExp - s.minExp;
    if (range <= 0) return 1.0;
    final progress = (currentExp - s.minExp) / range;
    return progress.clamp(0.0, 1.0);
  }

  PixelPet copyWith({
    String? name,
    int? level,
    int? currentExp,
    int? totalPomodorosCompleted,
    int? totalMinutesFocused,
    int? giveUpCount,
    PetMood? mood,
    DateTime? lastInteraction,
    String? speechText,
  }) {
    return PixelPet(
      name: name ?? this.name,
      level: level ?? this.level,
      currentExp: currentExp ?? this.currentExp,
      totalPomodorosCompleted: totalPomodorosCompleted ?? this.totalPomodorosCompleted,
      totalMinutesFocused: totalMinutesFocused ?? this.totalMinutesFocused,
      giveUpCount: giveUpCount ?? this.giveUpCount,
      mood: mood ?? this.mood,
      lastInteraction: lastInteraction ?? this.lastInteraction,
      speechText: speechText ?? this.speechText,
    );
  }

  Map<String, dynamic> toJson() => {
    'name': name,
    'level': level,
    'currentExp': currentExp,
    'totalPomodorosCompleted': totalPomodorosCompleted,
    'totalMinutesFocused': totalMinutesFocused,
    'giveUpCount': giveUpCount,
    'mood': mood.name,
    'lastInteraction': lastInteraction.toIso8601String(),
    'speechText': speechText,
  };

  factory PixelPet.fromJson(Map<String, dynamic> json) {
    PetMood parsedMood = PetMood.happy;
    try {
      parsedMood = PetMood.values.firstWhere((m) => m.name == json['mood']);
    } catch (_) {}

    return PixelPet(
      name: json['name'] as String? ?? 'Pixie',
      level: json['level'] as int? ?? 1,
      currentExp: json['currentExp'] as int? ?? 0,
      totalPomodorosCompleted: json['totalPomodorosCompleted'] as int? ?? 0,
      totalMinutesFocused: json['totalMinutesFocused'] as int? ?? 0,
      giveUpCount: json['giveUpCount'] as int? ?? 0,
      mood: parsedMood,
      lastInteraction: json['lastInteraction'] != null
          ? DateTime.tryParse(json['lastInteraction'] as String) ?? DateTime.now()
          : DateTime.now(),
      speechText: json['speechText'] as String? ?? 'Chào bạn! Cùng nhau tập trung nào!',
    );
  }
}
