import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:vehicle_monitoring_app/Screen/main_home_page.dart';

class NotificationService {
  static final NotificationService _notificationService =
      NotificationService._internal();

  factory NotificationService() {
    return _notificationService;
  }

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  NotificationService._internal();
  void onDidReceiveNotificationResponse(
      NotificationResponse notificationResponse, BuildContext context) async {
    final String? payload = notificationResponse.payload;
    if (notificationResponse.payload != null) {
      debugPrint('notification payload: $payload');
    }
    await Navigator.push(
      context,
      MaterialPageRoute<void>(builder: (context) => const MainHomeScreen()),
    );
  }

  Future<void> initNotification() async {
    // Android initialization
    final AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    // ios initialization
    // final IOSInitializationSettings initializationSettingsIOS =
    //     IOSInitializationSettings(
    //   requestAlertPermission: false,
    //   requestBadgePermission: false,
    //   requestSoundPermission: false,
    // );

    final InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
    );
    // the initialization settings are initialized after they are setted
    await flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onDidReceiveNotificationResponse:
            (NotificationResponse notificationResponse) async {
      final String? payload = notificationResponse.payload;
      if (notificationResponse.payload != null) {
        debugPrint('notification payload: $payload');
      }
      // await Navigator.push(
      //   context,
      //   MaterialPageRoute<void>(builder: (context) => const MainHomeScreen()),
      // );
    });
  }

  Future<void> showNotification(
    int id,
    String title,
    String body,
    AndroidNotificationSound? soundtype,
  ) async {
    await flutterLocalNotificationsPlugin.show(
      id,
      title,
      body,
      NotificationDetails(
          // Android details
          android: AndroidNotificationDetails(
        'main_channel', 'Main Channel',
        channelDescription: "althaf",
        // color: Colors.green,
        // ledColor: Colors.red,
        // ledOffMs: 5,
        // ledOnMs: 5,
        colorized: true,
        category: AndroidNotificationCategory.alarm,
        importance: Importance.high,
        priority: Priority.high,
        styleInformation: BigTextStyleInformation(body,
            htmlFormatBigText: true,
            contentTitle: title,
            htmlFormatContentTitle: true),
        // sound: soundtype,
      )),
      // iOS details
      // iOS: IOSNotificationDetails(
      //   sound: 'default.wav',
      //   presentAlert: true,
      //   presentBadge: true,
      //   presentSound: true,
      // ),
    );
  }
}
