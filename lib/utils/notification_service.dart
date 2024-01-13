import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;

import 'package:anima/main.dart';
import 'package:anima/screen/setting/check_for_update.dart';
import 'package:anima/utils/custom_route_animation.dart';

class NotificationService {
  static final NotificationService _notificationService =
      NotificationService._internal();

  factory NotificationService() {
    return _notificationService;
  }

  NotificationService._internal();

  static const channelId = '123';

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future<void> init() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@drawable/ic_stat_name');

    const InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
    );

    tz.initializeTimeZones();

    await flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onDidReceiveNotificationResponse: selectNotification);
  }

  Future<void> showNotifications(String title, int id,
      [String? payload]) async {
    const AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails(
      'update',
      'channel name',
      channelDescription: 'channel description',
      priority: Priority.high,
      importance: Importance.defaultImportance,
    );

    await flutterLocalNotificationsPlugin.show(id, title, "",
        const NotificationDetails(android: androidNotificationDetails),
        payload: payload);
  }

  // Future<void> showProgressNotification(
  //     int id, int totalPage, int completed) async {
  //   int maxProgress = totalPage;

  //   final AndroidNotificationDetails androidNotificationDetails =
  //       AndroidNotificationDetails(
  //     'channel ID',
  //     'channel name',
  //     channelDescription: 'channel description',
  //     channelShowBadge: true,
  //     visibility: NotificationVisibility.private,
  //     importance: Importance.max,
  //     priority: Priority.high,
  //     progress: completed,
  //     showProgress: true,
  //     maxProgress: maxProgress,
  //     onlyAlertOnce: true,
  //     autoCancel: true,
  //     ongoing: true,
  //   );
  //   final NotificationDetails notificationDetails =
  //       NotificationDetails(android: androidNotificationDetails);

  //   await flutterLocalNotificationsPlugin.show(
  //     id,
  //     "Downloading",
  //     '$completed/$totalPage',
  //     notificationDetails,
  //   );
  // }

  Future<void> cancelNotifications(int id) async {
    await flutterLocalNotificationsPlugin.cancel(id);
  }

  Future<void> cancelAllNotifications() async {
    await flutterLocalNotificationsPlugin.cancelAll();
  }
}

void selectNotification(NotificationResponse payload) async {
  switch (payload.payload) {
    case "update":
      navigatorKey.currentState!
          .push(customRouteAnimation(const CheckForUpdateScreen()));
      break;
  }
}
