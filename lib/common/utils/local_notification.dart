import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class LocalNotification {
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
