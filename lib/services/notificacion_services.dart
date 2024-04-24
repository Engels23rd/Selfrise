import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future<void> showNotification(String title, String body) async {
    var androidDetails = AndroidNotificationDetails(
      'channel_id',
      'channel_name',
      importance: Importance.max,
    );
    var platformDetails = NotificationDetails(android: androidDetails);
    await flutterLocalNotificationsPlugin.show(
      0, // ID único para la notificación
      title,
      body,
      platformDetails,
    );
  }

  Future<void> scheduleNotification(
      String title, String body, DateTime scheduledDateTime) async {
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'channel_id',
      'channel_name',
      importance: Importance.max,
    );
    var platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);

    // Convertir DateTime a TZDateTime utilizando la zona horaria local del dispositivo
    tz.TZDateTime scheduledDate =
        tz.TZDateTime.from(scheduledDateTime, tz.local);

    await flutterLocalNotificationsPlugin.zonedSchedule(
      0, // ID único para la notificación
      title,
      body,
      scheduledDate,
      platformChannelSpecifics,
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
    );
  }

  Future<void> showAlarm(String title, String body) async {
    var androidDetails = AndroidNotificationDetails(
      'alarm_channel_id',
      'Alarm Channel',
      channelShowBadge: false,
      icon: 'alarm_icon',
      playSound: true,
      sound: RawResourceAndroidNotificationSound('your_sound'),
      importance: Importance.max,
      priority: Priority.high,
    );
    var platformDetails = NotificationDetails(android: androidDetails);
    await flutterLocalNotificationsPlugin.show(
      0, // ID único para la notificación
      title,
      body,
      platformDetails,
    );
  }
}
