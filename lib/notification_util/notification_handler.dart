import 'package:flutter/cupertino.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:market_space/common/log.dart';
import 'package:market_space/notification_util/notification_util.dart';

class NotificationHandler {
  static const String CHANNEL_DEFAULT = "MarketSpaace Notifications";
  static const String CHANNEL_STATUS_UPDATES =
      "MarketSpaace Status Update Notifications";

  // FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  static void showNotification(
      FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin,
      int notificationId,
      String title,
      {String channel = CHANNEL_DEFAULT,
      String subtitle,
      bool showProgress = false,
      int maxProgress = 0,
      int progress = 0,
      bool autoCancel = true,
      bool ongoing = false,
      bool enableVibration = true,
      bool playSound = true,
      Priority priority = Priority.max,
      Importance importance = Importance.max}) async {
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
        channel, channel, channel,
        autoCancel: autoCancel,
        ongoing: ongoing,
        showProgress: showProgress,
        maxProgress: maxProgress,
        progress: progress,
        playSound: playSound,
        enableVibration: enableVibration,
        priority: priority,
        importance: importance);
    var iOSPlatformChannelSpecifics =
        IOSNotificationDetails(presentSound: playSound);

    var platformChannelSpecifics = NotificationDetails(
        android: androidPlatformChannelSpecifics,
        iOS: iOSPlatformChannelSpecifics);

    final NotificationAppLaunchDetails notificationAppLaunchDetails =
        await flutterLocalNotificationsPlugin.getNotificationAppLaunchDetails();

    await flutterLocalNotificationsPlugin.show(
        notificationId,
        title,
        subtitle ?? showProgress ? progress.toString() + "%" : null,
        platformChannelSpecifics);
  }

  static Future<void> backgroundMessageHandler(Map<String, dynamic> message) {
    Log.d(message);
    if (message.containsKey('data')) {
      final dynamic data = message['data'];
      NotificationHandler.showNotification(
          NotificationUtil.flutterLocalNotificationsPlugin,
          message.hashCode,
          data["title"],
          channel: NotificationHandler.CHANNEL_STATUS_UPDATES,
          priority: Priority.high,
          importance: Importance.high,
          playSound: true,
          enableVibration: true);
    }

    if (message.containsKey('notification')) {
      final dynamic notification = message['notification'];
      NotificationHandler.showNotification(
          NotificationUtil.flutterLocalNotificationsPlugin,
          message.hashCode,
          notification["title"],
          channel: NotificationHandler.CHANNEL_STATUS_UPDATES,
          priority: Priority.high,
          importance: Importance.high,
          playSound: true,
          enableVibration: true);
    }
  }
}

class ReceivedNotification {
  ReceivedNotification({
    @required this.id,
    @required this.title,
    @required this.body,
    @required this.payload,
  });

  final int id;
  final String title;
  final String body;
  final String payload;
}
