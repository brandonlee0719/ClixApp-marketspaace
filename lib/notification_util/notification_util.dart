import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:market_space/common/log.dart';
import 'package:market_space/notification/routes/notification_route.dart';
import 'package:market_space/notification/representation/screens/notification_screen.dart';
import 'package:market_space/notification_util/notification_handler.dart';
import 'package:market_space/providers/notification_provider/notification_provider.dart';
import 'package:market_space/repositories/auth/auth_repository.dart';
import 'package:market_space/services/RouterServices.dart';
import 'package:market_space/splash/splash_screen_bloc.dart';

class NotificationUtil {
  static FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  static final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  static AuthRepository _authRepository = AuthRepository();
  NotificationProvider notificationProvider = NotificationProvider();

  static Future<void> subscribe(String topic) async {
    await _firebaseMessaging.subscribeToTopic(topic);
  }

  static void unSubscribe(String topic) {
    _firebaseMessaging.unsubscribeFromTopic(topic);
  }

  void schedule(message) async {
    String title = message["title"];
    String body = message["body"];
    var iosPlatformChannelSpecifics = IOSNotificationDetails(
        presentAlert: true, presentBadge: true, presentSound: true);
    var details = NotificationDetails(iOS: iosPlatformChannelSpecifics);

    await flutterLocalNotificationsPlugin.show(
      0,
      title,
      body,
      details,
      payload: "zz",
    );
  }

  Future<void> initializeFCM(BuildContext context) async {
    // print("initializing FCM....");

    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true, // Required to display a heads up notification
      badge: true,
      sound: true,
    );
    NotificationSettings settings = await _firebaseMessaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );
    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      // print('User granted permission');
    } else if (settings.authorizationStatus ==
        AuthorizationStatus.provisional) {
      // print('User granted provisional permission');
    } else {
      // print('User declined or has not accepted permission');
    }
    // if (Platform.isIOS) {
    //   _firebaseMessaging
    //       .requestNotificationPermissions(IosNotificationSettings());
    // }

    //TODO implement concrete implementation of the code
    FirebaseMessaging.onMessage.listen((event) {
      // print(event.messageType);
      // print("recieved");
      // print(event.data);
      // // Map data = event.data?? {"a":"b"};
      // /* TODO this is not the best practice, write a handler function for the event data to make sure that it is working*/
      // if(event.data  != null){
      //   // print("this should redirect");
      //   RouterService.appRouter.navigateTo(event.data['path']);
      // }else{
      //   // print("this should not");
      // }
    });
    FirebaseMessaging.onMessageOpenedApp.listen((event) async {
      // print("recieved");
      // print(event.data);
      // Map data = event.data?? {"a":"b"};
      /* TODO this is not the best practice, write a handler function for the event data to make sure that it is working*/
      if (event.data != null) {
        // print("this should redirect");
        var result =
            await RouterService.appRouter.navigateTo(event.data['path']);
        // print(result);
      } else {
        // print("this should not");
      }
    });
    // ignore: missing_return
    FirebaseMessaging.onBackgroundMessage((message) {
      message.data != null
          ? RouterService.appRouter.navigateTo(message.data['path'])
          : print("no need to redirect");
      // print(message);
    });

    // _firebaseMessaging.getToken().then((token) async{
    //   // print('FCM token $token');
    //   if(token != null) {
    //     await _authRepository.saveDeviceToken(token);
    //     // await _firebaseMessaging.subscribeToTopic("lpl");
    //     // _firebaseMessaging.unsubscribeFromTopic("rPLMag2bJpefZdsmldQ04sKb82U2");
    //   }
    // });
  }

  static void showNotification(Map<String, dynamic> message) async {
    if (message != null) {
      // print("called from showNotification");
      // print(message);

      NotificationHandler.showNotification(
          flutterLocalNotificationsPlugin, 1, "hahaha",
          channel: NotificationHandler.CHANNEL_STATUS_UPDATES,
          priority: Priority.high,
          importance: Importance.high,
          playSound: true,
          enableVibration: true);
    }
    RouterService.appRouter.navigateTo('/BiometricsAuth/0');
  }

  void requestPermissions() {
    flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(
          alert: true,
          badge: true,
          sound: true,
        );
    flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            MacOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(
          alert: true,
          badge: true,
          sound: true,
        );
  }

  void initFirebase() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    // print("initializing firebase.....");

    /// Note: permissions aren't requested here just to demonstrate that can be
    /// done later
    // final IOSInitializationSettings initializationSettingsIOS =
    //     IOSInitializationSettings(
    //         requestAlertPermission: false,
    //         requestBadgePermission: false,
    //         requestSoundPermission: false,
    //         onDidReceiveLocalNotification:
    //             (int id, String title, String body, String payload) async {
    //           didReceiveLocalNotificationSubject.add(ReceivedNotification(
    //               id: id, title: title, body: body, payload: payload));
    //         });
    // const MacOSInitializationSettings initializationSettingsMacOS =
    //     MacOSInitializationSettings(
    //         requestAlertPermission: false,
    //         requestBadgePermission: false,
    //         requestSoundPermission: false);
    // final InitializationSettings initializationSettings =
    //     InitializationSettings(
    //         android: initializationSettingsAndroid,
    //         iOS: initializationSettingsIOS,
    //         macOS: initializationSettingsMacOS);
    // var android=AndroidInitializationSettings('mipmap/ic_launcher.png');
    var ios = IOSInitializationSettings();
    var platform = new InitializationSettings(
        android: initializationSettingsAndroid, iOS: ios);
    await flutterLocalNotificationsPlugin.initialize(platform);
  }
}
