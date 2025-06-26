import 'dart:async';
import 'dart:io';

import 'package:bot_toast/bot_toast.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:movie_obs/bloc/ads_bloc.dart';
import 'package:movie_obs/bloc/home_bloc.dart';
import 'package:movie_obs/bloc/notification_bloc.dart';
import 'package:movie_obs/bloc/user_bloc.dart';
import 'package:movie_obs/bloc/video_bloc.dart';
import 'package:movie_obs/extension/extension.dart';
import 'package:movie_obs/firebase_options.dart';
import 'package:movie_obs/network/notification_service/notification_service.dart';
import 'package:movie_obs/network/app_link_service.dart';
import 'package:movie_obs/screens/auth/splash_screen.dart';
import 'package:movie_obs/utils/colors.dart';
import 'package:movie_obs/utils/dimens.dart';
import 'package:movie_obs/utils/route_observer.dart';
import 'package:no_screenshot/no_screenshot.dart';
import 'package:provider/provider.dart';
import 'package:rxdart/rxdart.dart';

import 'data/persistence/persistence_data.dart';
import 'package:movie_obs/l10n/app_localizations.dart';

StreamController<String> languageStreamController = BehaviorSubject<String>();
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
final RouteObserver<PageRoute> routeObserver = CurrentRouteObserver();
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AppLinkServices.init();
  if (Platform.isAndroid) {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  }
  {
    await Firebase.initializeApp();
  }

  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
  ErrorWidget.builder = (FlutterErrorDetails details) => Container();
  await FirebaseAnalytics.instance.setAnalyticsCollectionEnabled(true);
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  await GetStorage.init();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => VideoBloc()),
        ChangeNotifierProvider(create: (_) => HomeBloc()),
        ChangeNotifierProvider(create: (_) => UserBloc()),
        ChangeNotifierProvider(create: (_) => AdsBloc()),
        ChangeNotifierProvider(create: (_) => NotificationBloc()),
      ],
      child: const MovieOBS(),
    ),
  );
}

class MovieOBS extends StatefulWidget {
  const MovieOBS({super.key});

  @override
  State<MovieOBS> createState() => _MovieOBSState();
}

class _MovieOBSState extends State<MovieOBS> {
  final _noScreenshot = NoScreenshot.instance;

  @override
  void initState() {
    super.initState();
    disableScreenshot();
  }

  void disableScreenshot() async {
    bool result = await _noScreenshot.screenshotOff();
    debugPrint('Screenshot Off: $result');
  }

  final FirebaseAnalytics _analytics = FirebaseAnalytics.instance;
  FirebaseAnalyticsObserver getAnalyticsObserver() =>
      FirebaseAnalyticsObserver(analytics: _analytics);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: languageStreamController.stream,
      builder: (context, snapshot) {
        String localString = '';
        snapshot.data == null
            ? PersistenceData.shared.getLocale() == 'my'
                ? localString = 'my'
                : localString = 'en'
            : localString = snapshot.data ?? 'en';

        return MaterialApp(
          navigatorKey: navigatorKey,
          navigatorObservers: [
            routeObserver,
            if (kReleaseMode) getAnalyticsObserver(),
          ],
          title: 'TuuTu Player',
          debugShowCheckedModeBanner: false,
          localizationsDelegates: [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          locale: Locale(localString),
          supportedLocales: [Locale('en', 'US'), Locale('my', 'MM')],
          builder: (context, child) {
            child = BotToastInit()(context, child);
            return MediaQuery(
              data: MediaQuery.of(context).copyWith(
                textScaler: TextScaler.linear(
                  getDeviceType() == 'phone' ? 0.87 : 1.3,
                ),
              ),
              child: child,
            );
          },
          theme: ThemeData(
            appBarTheme: AppBarTheme(
              titleSpacing: 0,
              titleTextStyle: TextStyle(fontSize: kTextRegular3x),
            ),
            scaffoldBackgroundColor: kBlackColor,
            actionIconTheme: ActionIconThemeData(
              backButtonIconBuilder:
                  (BuildContext context) => Icon(
                    CupertinoIcons.arrow_left,
                    size: getDeviceType() == 'phone' ? 20 : 27,
                  ),
            ),
            progressIndicatorTheme: ProgressIndicatorThemeData(
              color: Colors.white,
            ),
            colorScheme: ColorScheme.fromSeed(
              seedColor: kSecondaryColor,
              primary: kSecondaryColor,
              brightness: Brightness.dark,
            ),
            fontFamily: GoogleFonts.poppins().fontFamily,
          ),
          home: SplashScreen(),
        );
      },
    );
  }
}
