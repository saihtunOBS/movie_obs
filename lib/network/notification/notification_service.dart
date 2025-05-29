import 'dart:async';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:movie_obs/bloc/notification_bloc.dart';
import 'package:movie_obs/network/notification/localization_service.dart';
import 'package:provider/provider.dart';

final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

class NotificationService {
  final BuildContext context;

  NotificationService(this.context);
  //permission
  requestPermission() async {
    await _firebaseMessaging.requestPermission(
      sound: true,
      alert: true,
      badge: true,
      provisional: false,
    );

    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
          alert: true, // Required to display a heads up notification
          badge: true,
          sound: true,
        );

    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    listenIncomingMessage();
    getFCMToken();
  }

  listenIncomingMessage() {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      LocalNotificationService().displayNotification(message);

      var notiBloc = Provider.of<NotificationBloc>(listen: false, context);

      notiBloc.getNotifications(context);
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      // Handle navigation after a user taps on the notification
      // if (CurrentRouteObserver.currentRoute != 'AnnouncementPage') {
      //   navigatorKey.currentState!.push(
      //     MaterialPageRoute(
      //       builder: (_) => AnnouncementPage(),
      //       settings: RouteSettings(name: "AnnouncementPage"),
      //     ),
      //   );
      // }
    });
  }

  Future<void> getFCMToken() async {
    String? token = await FirebaseMessaging.instance.getToken();
    print('token is....$token');
  }

  @pragma('vm:entry-point')
  Future<void> _firebaseMessagingBackgroundHandler(
    RemoteMessage message,
  ) async {
    await Firebase.initializeApp();
  }
}
