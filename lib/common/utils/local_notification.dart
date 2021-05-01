import 'package:flutter_local_notifications/flutter_local_notifications.dart';

final _notificationsPlugin = FlutterLocalNotificationsPlugin();

class LocalNotification {
  static Future init() async {
    // initialise local notification plugin
    var androidInitialize = AndroidInitializationSettings('app_icon');
    // iOS permission request
    var iosInitialize = IOSInitializationSettings();
    var initializationSettings =
        InitializationSettings(android: androidInitialize, iOS: iosInitialize);

    await _notificationsPlugin.initialize(initializationSettings,
        onSelectNotification: (payload) async {
      if (payload != null) {
        print('Notification payload:' + payload);
      }
    });
  }

  static Future show({int id, String title, String body}) async {
    var notificationPlugin = FlutterLocalNotificationsPlugin();

    var androidDetails = AndroidNotificationDetails(
        'channelId', 'localNotification', 'description',
        importance: Importance.high);

    var iOSDetails = IOSNotificationDetails();

    var generalDetails =
        NotificationDetails(android: androidDetails, iOS: iOSDetails);

    await notificationPlugin.show(
      id ?? '0',
      title ?? 'Tree Doctor',
      body ?? '默認內容',
      generalDetails,
    );
  }
}
