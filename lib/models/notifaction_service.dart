import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  static final _notifactions = FlutterLocalNotificationsPlugin();

  static Future init() async {
    tz.initializeTimeZones();
    var initializationSettingsAndroid = AndroidInitializationSettings(
        'ic_launcher_round');
    var initializationSettingsIOS = IOSInitializationSettings();
    var initializationSettings = InitializationSettings(
        android: initializationSettingsAndroid, iOS: initializationSettingsIOS);
    await _notifactions.initialize(initializationSettings);
  }

  static Future showNotifaction({int id=0, String? title, String? body, String? payload}) async
  {
    _notifactions.show(
        id,
        title,
        body,
        await notificationDetails(),
        payload: payload);



  }


  static Future showScheduledNotifaction({int id=0, String? title, String? body, String? payload, DateTime? now}) async
  {

    _notifactions.zonedSchedule(
        id,
        title,
        body,
        tz.TZDateTime.from(DateTime.now().add(const Duration(seconds: 20)),tz.local),
        await notificationDetails(),
        payload: payload,
        androidAllowWhileIdle: true,
        uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime);
  }


  static Future notificationDetails() async {
    return NotificationDetails(
        android: AndroidNotificationDetails(
          'channelId',
          'channelName',
          channelDescription: 'channelDescription',
        ),
        iOS: IOSNotificationDetails()

    );


  }


}