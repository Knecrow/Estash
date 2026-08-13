import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest_all.dart' as tz;

abstract class NotificationService {
  static final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static Future<void> initialize() async {
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
  }

  static Future<void> schedulePeriodicReminders() async {
    const androidDetails = AndroidNotificationDetails(
      'estash_reminders',
      'Estash Daily Cap Reminders',
      channelDescription: '30-minute periodic reminders to track expenses',
      importance: Importance.defaultImportance,
      priority: Priority.defaultPriority,
    );

    const notificationDetails = NotificationDetails(
      android: androidDetails,
      iOS: DarwinNotificationDetails(),
    );

    // Schedule 30-min repeating notification
    await _notificationsPlugin.periodicallyShow(
      0,
      'Estash Expense Reminder',
      'Did you spend anything recently? Keep your daily cap on track!',
      RepeatInterval.everyMinute, // or daily/hourly depending on OS capabilities
      notificationDetails,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
    );
  }

  static Future<void> cancelReminders() async {
    await _notificationsPlugin.cancel(0);
  }
}
