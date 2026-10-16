import 'dart:developer' as developer;
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

import '../models/habit_streak_model.dart';

class NotificationService {
  static const int pomodoroTimerNotificationId = 2001;
  static const int dailyStreakNotificationId = 2002;
  static const int testNotificationId = 2003;
  static const int exerciseAlarmNotificationId = 2004;

  static const String channelIdTimer = 'pomodoro_timer_channel';
  static const String channelNameTimer = 'Đồng hồ Pomodoro';
  static const String channelDescTimer = 'Thông báo khi hoàn thành phiên tập trung hoặc giờ nghỉ';

  static const String channelIdStreak = 'streak_reminder_channel';
  static const String channelNameStreak = 'Nhắc nhở Streak & Thú cưng';
  static const String channelDescStreak = 'Nhắc nhở duy trì chuỗi tập thể dục và học ngoại ngữ hàng ngày';

  static const String channelIdExerciseAlarm = 'exercise_alarm_channel';
  static const String channelNameExerciseAlarm = 'Báo thức bài tập (Plank)';
  static const String channelDescExerciseAlarm = 'Báo thức rung chuông khi kết thúc bài tập đếm ngược như Plank';

  static const String channelIdHabitReminder = 'habit_reminder_channel';
  static const String channelNameHabitReminder = 'Lịch học Ngoại ngữ & Kỹ năng';
  static const String channelDescHabitReminder = 'Thông báo định kỳ theo giờ và thứ trong tuần để duy trì Streak học tập';

  final FlutterLocalNotificationsPlugin _plugin = FlutterLocalNotificationsPlugin();
  bool _isInitialized = false;

  static final NotificationService instance = NotificationService._internal();

  NotificationService._internal();

  Future<void> init() async {
    if (_isInitialized) return;

    try {
      tz.initializeTimeZones();
      try {
        final timezoneInfo = await FlutterTimezone.getLocalTimezone();
        tz.setLocalLocation(tz.getLocation(timezoneInfo.identifier));
      } catch (_) {
        try {
          tz.setLocalLocation(tz.getLocation('Asia/Ho_Chi_Minh'));
        } catch (_) {}
      }

      const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
      const darwinSettings = DarwinInitializationSettings(
        requestAlertPermission: true,
        requestBadgePermission: true,
        requestSoundPermission: true,
      );

      const initSettings = InitializationSettings(
        android: androidSettings,
        iOS: darwinSettings,
        macOS: darwinSettings,
      );

      await _plugin.initialize(
        settings: initSettings,
        onDidReceiveNotificationResponse: (response) {
          developer.log('Notification tapped: ${response.payload}', name: 'NotificationService');
        },
      );

      final androidPlugin = _plugin.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();
      if (androidPlugin != null) {
        await androidPlugin.requestNotificationsPermission();
        try {
          await androidPlugin.requestExactAlarmsPermission();
        } catch (_) {}
      }

      _isInitialized = true;
    } catch (e) {
      developer.log('NotificationService init error: $e', name: 'NotificationService');
    }
  }

  /// Notify when Pomodoro timer completes
  Future<void> showTimerCompleteNotification({
    required String title,
    required String body,
  }) async {
    if (!_isInitialized) await init();

    const androidDetails = AndroidNotificationDetails(
      channelIdTimer,
      channelNameTimer,
      channelDescription: channelDescTimer,
      importance: Importance.max,
      priority: Priority.high,
      playSound: true,
      enableVibration: true,
      icon: '@mipmap/ic_launcher',
    );

    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    await _plugin.show(
      id: pomodoroTimerNotificationId,
      title: title,
      body: body,
      notificationDetails: const NotificationDetails(android: androidDetails, iOS: iosDetails),
    );
  }

  /// Schedule daily streak reminder at 20:00 (8:00 PM)
  Future<void> scheduleDailyStreakReminder() async {
    if (!_isInitialized) await init();

    final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
    tz.TZDateTime scheduled = tz.TZDateTime(tz.local, now.year, now.month, now.day, 20, 0);
    if (scheduled.isBefore(now)) {
      scheduled = scheduled.add(const Duration(days: 1));
    }

    const androidDetails = AndroidNotificationDetails(
      channelIdStreak,
      channelNameStreak,
      channelDescription: channelDescStreak,
      importance: Importance.high,
      priority: Priority.high,
      icon: '@mipmap/ic_launcher',
    );

    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    await _plugin.zonedSchedule(
      id: dailyStreakNotificationId,
      title: '🔥 Đừng để ngọn lửa Streak bị tắt!',
      body: 'Thú cưng Pixie đang đợi bạn! Hãy hoàn thành mục tiêu Tập thể dục & Học ngoại ngữ hôm nay nhé.',
      scheduledDate: scheduled,
      notificationDetails: const NotificationDetails(android: androidDetails, iOS: iosDetails),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      matchDateTimeComponents: DateTimeComponents.time,
    );
  }

  Future<void> cancelDailyReminder() async {
    if (!_isInitialized) await init();
    await _plugin.cancel(id: dailyStreakNotificationId);
  }

  /// Alarm notification for exercise countdown completion (e.g. Plank 60s)
  Future<void> showExerciseAlarmNotification({
    required String exerciseName,
    required int seconds,
  }) async {
    if (!_isInitialized) await init();

    final bigTextStyle = BigTextStyleInformation(
      'Chúc mừng! Bạn đã giữ thành công bài tập $exerciseName trong $seconds giây!\nThú cưng Pixie nhận thêm điểm EXP thể lực và rất tự hào về bạn! 🏋️🔥',
      contentTitle: '⏰ HẾT GIỜ: $exerciseName!',
      summaryText: 'Báo thức thể dục',
    );

    final androidDetails = AndroidNotificationDetails(
      channelIdExerciseAlarm,
      channelNameExerciseAlarm,
      channelDescription: channelDescExerciseAlarm,
      importance: Importance.max,
      priority: Priority.high,
      playSound: true,
      enableVibration: true,
      styleInformation: bigTextStyle,
      icon: '@mipmap/ic_launcher',
    );

    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    await _plugin.show(
      id: exerciseAlarmNotificationId,
      title: '⏰ HẾT GIỜ BÀI TẬP: $exerciseName!',
      body: 'Hoàn thành $exerciseName ($seconds giây)! Thú cưng nhận thêm EXP!',
      notificationDetails: NotificationDetails(android: androidDetails, iOS: iosDetails),
    );
  }

  int _getHabitReminderId(String habitId, int weekday) {
    return ((habitId.hashCode & 0x00FFFFFF) * 10) + weekday;
  }

  /// Cancel all scheduled alarms for a specific habit
  Future<void> cancelHabitReminder(String habitId) async {
    if (!_isInitialized) await init();
    for (int day = 1; day <= 7; day++) {
      await _plugin.cancel(id: _getHabitReminderId(habitId, day));
    }
  }

  /// Schedule recurring study reminders for a habit based on time and frequency
  Future<void> scheduleHabitReminder(HabitStreak habit) async {
    if (!_isInitialized) await init();

    // Cancel previously scheduled days first
    await cancelHabitReminder(habit.id);

    if (!habit.isReminderEnabled || habit.reminderDays.isEmpty) return;

    const androidDetails = AndroidNotificationDetails(
      channelIdHabitReminder,
      channelNameHabitReminder,
      channelDescription: channelDescHabitReminder,
      importance: Importance.high,
      priority: Priority.high,
      playSound: true,
      enableVibration: true,
      icon: '@mipmap/ic_launcher',
    );

    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    const notificationDetails = NotificationDetails(android: androidDetails, iOS: iosDetails);

    final String iconText;
    switch (habit.category) {
      case HabitCategory.english:
        iconText = '🇬🇧 English';
        break;
      case HabitCategory.japanese:
        iconText = '🇯🇵 Japanese';
        break;
      case HabitCategory.exercise:
        iconText = '🏋️ Thể dục';
        break;
      case HabitCategory.custom:
        iconText = '🎯 Kỹ năng';
        break;
    }

    final title = '⏰ Đến giờ học $iconText: ${habit.title}!';
    final body = 'Đã đến giờ rèn luyện (${habit.reminderTimeString})! Dành ${habit.targetMinutesPerDay} phút để giữ chuỗi ${habit.currentStreak} ngày streak và giúp thú cưng lớn khôn nhé 🔥';

    final now = tz.TZDateTime.now(tz.local);

    for (final weekday in habit.reminderDays) {
      tz.TZDateTime scheduledDate = tz.TZDateTime(
        tz.local,
        now.year,
        now.month,
        now.day,
        habit.reminderHour,
        habit.reminderMinute,
      );

      // Adjust to next matching weekday (1 = Monday ... 7 = Sunday)
      while (scheduledDate.weekday != weekday || scheduledDate.isBefore(now)) {
        scheduledDate = scheduledDate.add(const Duration(days: 1));
      }

      await _plugin.zonedSchedule(
        id: _getHabitReminderId(habit.id, weekday),
        title: title,
        body: body,
        scheduledDate: scheduledDate,
        notificationDetails: notificationDetails,
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        matchDateTimeComponents: DateTimeComponents.dayOfWeekAndTime,
      );
    }
  }

  /// Fire an immediate test notification for the habit's study reminder
  Future<void> showTestHabitReminderNotification(HabitStreak habit) async {
    if (!_isInitialized) await init();

    final String iconText;
    switch (habit.category) {
      case HabitCategory.english:
        iconText = '🇬🇧 English';
        break;
      case HabitCategory.japanese:
        iconText = '🇯🇵 Japanese';
        break;
      case HabitCategory.exercise:
        iconText = '🏋️ Thể dục';
        break;
      case HabitCategory.custom:
        iconText = '🎯 Kỹ năng';
        break;
    }

    const androidDetails = AndroidNotificationDetails(
      channelIdHabitReminder,
      channelNameHabitReminder,
      channelDescription: channelDescHabitReminder,
      importance: Importance.high,
      priority: Priority.high,
      playSound: true,
      enableVibration: true,
      icon: '@mipmap/ic_launcher',
    );

    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    await _plugin.show(
      id: testNotificationId,
      title: '⏰ [TEST] Đến giờ học $iconText: ${habit.title}!',
      body: 'Chuông báo lúc ${habit.reminderTimeString} (${habit.frequencyString}) hoạt động chuẩn xác! Hãy bắt đầu phiên học nào 🔥',
      notificationDetails: const NotificationDetails(android: androidDetails, iOS: iosDetails),
    );
  }
}
