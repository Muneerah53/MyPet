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
       );



  }


  static Future showScheduledNotifaction({int id=0, String? title, String? body, DateTime? t}) async
  {

    _notifactions.zonedSchedule(
        id,
        title,
        'Your Appointment is in 1 hour.',
        tz.TZDateTime.now(tz.local).add(const Duration(hours: 1)),
        //tz.TZDateTime.from(t!.subtract(const Duration(hours: 1)),tz.local),
        await notificationDetails(),
        androidAllowWhileIdle: true,
        uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime);


    _notifactions.zonedSchedule(
        id,
        title,
        'Your Appointment is in 12 hour.',
        tz.TZDateTime.now(tz.local).add(const Duration(hours: 12)),
       // tz.TZDateTime.from(t!.subtract(const Duration(hours: 12)),tz.local),
        await notificationDetails(),
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