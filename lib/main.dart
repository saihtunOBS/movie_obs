import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:movie_obs/bloc/video_bloc.dart';
import 'package:movie_obs/screens/auth/ads_screen.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
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
      theme: ThemeData(
        actionIconTheme: ActionIconThemeData(
          backButtonIconBuilder:
              (BuildContext context) => Icon(CupertinoIcons.arrow_left),
        ),
        progressIndicatorTheme: ProgressIndicatorThemeData(
          color: Colors.white, // Change the default progress indicator color
        ),
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.red,
          primary: Colors.amber,
        ),
        fontFamily: GoogleFonts.poppins().fontFamily,
      ),
      home: AdsScreen(),
    );
  }
}
