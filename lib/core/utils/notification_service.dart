import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest_all.dart' as tz;

abstract class NotificationService {
  static final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static Future<void> initialize() async {
    try {
      tz.initializeTimeZones();

      const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
      const darwinSettings = DarwinInitializationSettings(
        requestAlertPermission: true,
        requestBadgePermission: true,
        requestSoundPermission: true,
      );

      const initSettings = InitializationSettings(
        android: androidSettings,
        iOS: darwinSettings,
      );

      await _notificationsPlugin.initialize(initSettings);
    } catch (e) {
      // Prevent notification initialization failure from crashing app startup
    }
  }

  static Future<void> schedulePeriodicReminders() async {
    try {
      const androidDetails = AndroidNotificationDetails(
        'estash_reminders',
        'Estash Daily Cap Reminders',
        channelDescription: 'Periodic reminders to track expenses',
        importance: Importance.defaultImportance,
        priority: Priority.defaultPriority,
      );

      const notificationDetails = NotificationDetails(
        android: androidDetails,
        iOS: DarwinNotificationDetails(),
      );

      // Schedule repeating notification using inexact schedule mode to avoid Android 14 exact alarm permission crash
      await _notificationsPlugin.periodicallyShow(
        0,
        'Estash Expense Reminder',
        'Did you spend anything recently? Keep your daily cap on track!',
        RepeatInterval.hourly,
        notificationDetails,
        androidScheduleMode: AndroidScheduleMode.inexact,
      );
    } catch (e) {
      // Fail gracefully if permission is denied
    }
  }

  static Future<void> cancelReminders() async {
    try {
      await _notificationsPlugin.cancel(0);
    } catch (_) {}
  }
}
