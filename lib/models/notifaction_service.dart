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

  static Future showNotifaction({int id=0, String? title, String? body}) async
  {

    _notifactions.show(
        id,
        title,
        body,
        await notificationDetails(),
       );



  }


  static Future showScheduledNotifaction({int? id, String? title, String? body, DateTime? t}) async
  {
    _notifactions.zonedSchedule(
        id!,
        title,
        'Your Appointment is in 1 hour.',
        tz.TZDateTime.from(t!.subtract(const Duration(minutes: 60)),tz.local),
        await notificationDetails(),
        androidAllowWhileIdle: true,
        uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime);


  }

  static Future cancel(int id) async
  {
    _notifactions.cancel(id);

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