import 'dart:async';

import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:movie_obs/bloc/home_bloc.dart';
import 'package:movie_obs/bloc/video_bloc.dart';
import 'package:movie_obs/extension/extension.dart';
import 'package:movie_obs/screens/auth/splash_screen.dart';
import 'package:movie_obs/screens/bottom_nav/bottom_nav_screen.dart';
import 'package:movie_obs/utils/colors.dart';
import 'package:provider/provider.dart';
import 'package:rxdart/rxdart.dart';

import 'data/persistence/persistence_data.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

StreamController<String> languageStreamController = BehaviorSubject<String>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  await GetStorage.init();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => VideoBloc()),
        ChangeNotifierProvider(create: (_) => HomeBloc()),
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
            fontFamily:
                PersistenceData.shared.getLocale() == 'my'
                    ? GoogleFonts.notoSansMyanmar().fontFamily
                    : GoogleFonts.poppins().fontFamily,
          ),
          home: BottomNavScreen(),
        );
      },
    );
  }
}
