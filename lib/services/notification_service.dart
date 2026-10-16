import 'dart:developer' as developer;
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

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
}
