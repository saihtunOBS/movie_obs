import 'dart:async';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:movie_obs/bloc/notification_bloc.dart';
import 'package:movie_obs/main.dart';
import 'package:movie_obs/network/notification_service/local_notification_service.dart';
import 'package:movie_obs/screens/profile/payment_status_screen.dart';
import 'package:movie_obs/utils/route_observer.dart';
import 'package:provider/provider.dart';

import '../../data/persistence/persistence_data.dart';

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
      var currentContext = navigatorKey.currentContext;
      if (currentContext != null) {
        var notiBloc = Provider.of<NotificationBloc>(
          listen: false,
          currentContext,
        );

        notiBloc.getNotifications();
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      debugPrint('Notification tapped!');
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (CurrentRouteObserver.currentRoute != 'PaymentStatusScreen') {
          navigatorKey.currentState?.pushAndRemoveUntil(
            MaterialPageRoute(
              builder: (_) => PaymentStatusScreen(),
              settings: RouteSettings(name: "PaymentStatusScreen"),
            ),
            (route) => false,
          );
        }
      });
    });
    FirebaseMessaging.instance.getInitialMessage().then((message) async {
      if (message == null || PersistenceData.shared.getToken() == null) return;

      Future.delayed((Duration(seconds: 3)), () {
        if (CurrentRouteObserver.currentRoute != 'PaymentStatusScreen') {
          navigatorKey.currentState!.push(
            MaterialPageRoute(
              builder: (_) => PaymentStatusScreen(),
              settings: RouteSettings(name: "PaymentStatusScreen"),
            ),
          );
        }
      });
    });
  }

  Future<void> getFCMToken() async {
    String? token = await FirebaseMessaging.instance.getToken();
    print('token is....$token');
  }
}

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
}
