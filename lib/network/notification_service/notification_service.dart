import 'dart:async';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:movie_obs/bloc/notification_bloc.dart';
import 'package:movie_obs/bloc/user_bloc.dart';
import 'package:movie_obs/data/persistence/persistence_data.dart';
import 'package:movie_obs/main.dart';
import 'package:movie_obs/network/notification_service/local_notification_service.dart';
import 'package:movie_obs/screens/profile/payment_status_screen.dart';
import 'package:movie_obs/utils/route_observer.dart';
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

    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

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
        var userBloc = Provider.of<UserBloc>(listen: false, currentContext);

        notiBloc.getNotifications();
        userBloc.updateToken();
        userBloc.getUser(context: context);

        if (PersistenceData.shared.getToken() == null) return;
        if (message.notification?.body == 'Payment successful' ||
            message.notification?.body == 'Payment unsuccessful') {
          if (CurrentRouteObserver.currentRoute != 'PaymentStatusScreen') {
            navigatorKey.currentState?.pushAndRemoveUntil(
              CupertinoPageRoute(
                builder:
                    (_) => PaymentStatusScreen(
                      status:
                          message.notification?.body == 'Payment successful'
                              ? 'success'
                              : 'fail',
                    ),
                settings: RouteSettings(name: "PaymentStatusScreen"),
              ),
              (route) => false,
            );
          }
        }
      }
    });

    // FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
    //   if (PersistenceData.shared.getToken() == '') return;
    //   _handleNotificationTap(message);
    // });

    // // Handle when the app is launched from terminated state
    FirebaseMessaging.instance.getInitialMessage().then((
      RemoteMessage? message,
    ) {
      if (message == null || PersistenceData.shared.getToken() == '') return;
      _handleNotificationTap(message);
    });
  }

  Future<void> getFCMToken() async {
    String? token = await FirebaseMessaging.instance.getToken();
    print('token is....$token');
  }
}

void _handleNotificationTap(RemoteMessage message) {
  if (message.notification?.body == 'Payment successful' ||
      message.notification?.body == 'Payment unsuccessful') {
    if (CurrentRouteObserver.currentRoute != 'PaymentStatusScreen') {
      navigatorKey.currentState?.pushAndRemoveUntil(
        CupertinoPageRoute(
          builder:
              (_) => PaymentStatusScreen(
                status:
                    message.notification?.body == 'Payment successful'
                        ? 'success'
                        : 'fail',
              ),
          settings: RouteSettings(name: "PaymentStatusScreen"),
        ),
        (route) => false,
      );
    }
  }
}

@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
}
