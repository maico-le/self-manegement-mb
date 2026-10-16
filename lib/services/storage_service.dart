import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/habit_streak_model.dart';
import '../models/pet_model.dart';
import '../models/pomodoro_model.dart';

class StorageService {
  static const String keyPet = 'pixel_pet_data';
  static const String keyHabits = 'habits_list_data';
  static const String keySessions = 'pomodoro_sessions_data';
  static const String keyFocusMinutes = 'setting_focus_minutes';
  static const String keyShortBreakMinutes = 'setting_short_break_minutes';
  static const String keyDailyReminderEnabled = 'setting_daily_reminder_enabled';

  final SharedPreferences _prefs;

  StorageService(this._prefs);

  static Future<StorageService> create() async {
    final prefs = await SharedPreferences.getInstance();
    return StorageService(prefs);
  }

  // --- Pet Persistence ---
  PixelPet loadPet() {
    final str = _prefs.getString(keyPet);
    if (str == null || str.isEmpty) {
      return PixelPet(
        name: 'Pixie',
        lastInteraction: DateTime.now(),
        speechText: 'Chào bạn! Mình là Pixie. Hãy cùng tập trung để mình lớn lên nhé!',
      );
    }
    try {
      final map = jsonDecode(str) as Map<String, dynamic>;
      return PixelPet.fromJson(map);
    } catch (_) {
      return PixelPet(lastInteraction: DateTime.now());
    }
  }

  Future<void> savePet(PixelPet pet) async {
    final str = jsonEncode(pet.toJson());
    await _prefs.setString(keyPet, str);
  }

  // --- Habits Persistence ---
  List<HabitStreak> loadHabits() {
    final str = _prefs.getString(keyHabits);
    if (str == null || str.isEmpty) {
      // Default 3 habits required by user: Tập thể dục, Học English, Học Japanese
      final defaults = [
        HabitStreak(
          id: 'habit_fitness',
          title: 'Tập thể dục',
          category: HabitCategory.exercise,
          targetMinutesPerDay: 30,
          colorHex: '#FA520F', // Mistral orange
          createdAt: DateTime.now(),
        ),
        HabitStreak(
          id: 'habit_english',
          title: 'Học English',
          category: HabitCategory.english,
          targetMinutesPerDay: 25,
          colorHex: '#0284C7', // Cyber blue
          createdAt: DateTime.now(),
        ),
        HabitStreak(
          id: 'habit_japanese',
          title: 'Học Japanese',
          category: HabitCategory.japanese,
          targetMinutesPerDay: 25,
          colorHex: '#E11D48', // Crimson red
          createdAt: DateTime.now(),
        ),
      ];
      saveHabits(defaults);
      return defaults;
    }

    try {
      final list = jsonDecode(str) as List;
      return list.map((item) => HabitStreak.fromJson(item as Map<String, dynamic>)).toList();
    } catch (_) {
      return [];
    }
  }

  Future<void> saveHabits(List<HabitStreak> habits) async {
    final list = habits.map((h) => h.toJson()).toList();
    await _prefs.setString(keyHabits, jsonEncode(list));
  }

  // --- Pomodoro History ---
  List<PomodoroSession> loadSessions() {
    final str = _prefs.getString(keySessions);
    if (str == null || str.isEmpty) return [];
    try {
      final list = jsonDecode(str) as List;
      return list.map((item) => PomodoroSession.fromJson(item as Map<String, dynamic>)).toList();
    } catch (_) {
      return [];
    }
  }

  Future<void> saveSessions(List<PomodoroSession> sessions) async {
    final list = sessions.map((s) => s.toJson()).toList();
    await _prefs.setString(keySessions, jsonEncode(list));
  }

  Future<void> addSession(PomodoroSession session) async {
    final current = loadSessions();
    current.insert(0, session);
    if (current.length > 100) current.removeLast();
    await saveSessions(current);
  }

  // --- Settings ---
  int getFocusDurationMinutes() => _prefs.getInt(keyFocusMinutes) ?? 25;
  Future<void> setFocusDurationMinutes(int mins) => _prefs.setInt(keyFocusMinutes, mins);

  int getShortBreakMinutes() => _prefs.getInt(keyShortBreakMinutes) ?? 5;
  Future<void> setShortBreakMinutes(int mins) => _prefs.setInt(keyShortBreakMinutes, mins);

  bool isDailyReminderEnabled() => _prefs.getBool(keyDailyReminderEnabled) ?? true;
  Future<void> setDailyReminderEnabled(bool enabled) => _prefs.setBool(keyDailyReminderEnabled, enabled);
}
