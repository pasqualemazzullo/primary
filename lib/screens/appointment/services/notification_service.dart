import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz_data;

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;

  final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();
  bool _isInitialized = false;

  NotificationService._internal();

  Future<void> initialize() async {
    if (_isInitialized) return;

    tz_data.initializeTimeZones();
    tz.setLocalLocation(tz.getLocation('Europe/Rome'));

    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('ic_launcher_foreground');

    const DarwinInitializationSettings initializationSettingsIOS =
        DarwinInitializationSettings(
          requestAlertPermission: true,
          requestBadgePermission: true,
          requestSoundPermission: true,
        );

    const InitializationSettings initializationSettings =
        InitializationSettings(
          android: initializationSettingsAndroid,
          iOS: initializationSettingsIOS,
        );

    await _notificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) {},
    );

    _isInitialized = true;
  }

  Future<void> requestNotificationPermissions() async {
    await initialize();

    try {
      await _notificationsPlugin
          .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin
          >()
          ?.requestNotificationsPermission();

      await _notificationsPlugin
          .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin
          >()
          ?.requestExactAlarmsPermission();
    } catch (e) {
      // Non succede niente.
    }
  }

  Future<void> scheduleAppointmentNotification({
    required int id,
    required String title,
    required String body,
    required DateTime appointmentDateTime,
    required bool useMinuteNotification,
    int days = 0,
    int hours = 0,
    int minutes = 0,
    String? payload,
  }) async {
    await initialize();

    await requestNotificationPermissions();

    DateTime notificationTime;

    if (useMinuteNotification) {
      notificationTime = appointmentDateTime.subtract(
        Duration(minutes: minutes),
      );
    } else {
      notificationTime = appointmentDateTime.subtract(
        Duration(days: days, hours: hours),
      );
    }

    if (notificationTime.isBefore(DateTime.now())) {
      return;
    }

    final tz.TZDateTime scheduledDate = tz.TZDateTime(
      tz.local,
      notificationTime.year,
      notificationTime.month,
      notificationTime.day,
      notificationTime.hour,
      notificationTime.minute,
    );

    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
          'appointment_channel',
          'Appuntamenti',
          channelDescription: 'Notifiche per appuntamenti',
          importance: Importance.max,
          priority: Priority.high,
          playSound: true,
          enableVibration: true,
        );

    const DarwinNotificationDetails iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    const NotificationDetails notificationDetails = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _notificationsPlugin.zonedSchedule(
      id,
      title,
      body,
      scheduledDate,
      notificationDetails,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      payload: payload,
    );
  }

  Future<void> cancelNotification(int id) async {
    await _notificationsPlugin.cancel(id);
  }

  Future<void> cancelAllNotifications() async {
    await _notificationsPlugin.cancelAll();
  }
}
