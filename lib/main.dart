import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:movie_obs/bloc/video_bloc.dart';
import 'package:movie_obs/extension/extension.dart';
import 'package:movie_obs/screens/auth/ads_screen.dart';
import 'package:movie_obs/utils/colors.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  runApp(
    MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => VideoBloc())],
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
    return MaterialApp(
      title: 'ZLan Movie Player',
      debugShowCheckedModeBanner: false,
      supportedLocales: [Locale('en')],
      localizationsDelegates: [
        CountryLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      builder: (context, child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(
            textScaler: TextScaler.linear(
              getDeviceType() == 'phone' ? 0.87 : 1.3,
            ),
          ),
          child: child!,
        );
      },
      theme: ThemeData(
       
        actionIconTheme: ActionIconThemeData(
          backButtonIconBuilder:
              (BuildContext context) => Icon(
                CupertinoIcons.arrow_left,
                size: getDeviceType() == 'phone' ? 20 : 27,
              ),
        ),
        progressIndicatorTheme: ProgressIndicatorThemeData(color: Colors.white),
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.red,
          primary: kSecondaryColor,
          brightness: Brightness.dark
        ),
        fontFamily: GoogleFonts.poppins().fontFamily,
      ),
      home: AdsScreen(),
    );
  }
}
