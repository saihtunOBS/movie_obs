import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:movie_obs/bloc/video_bloc.dart';
import 'package:movie_obs/screens/splash_screen.dart';
import 'package:provider/provider.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  WakelockPlus.enable();
  runApp(
    MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => VideoBloc())],
      child: const MovieOBS(),
    ),
  );
}

class MovieOBS extends StatelessWidget {
  const MovieOBS({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ZLan Movie Player',

      theme: ThemeData(
        progressIndicatorTheme: ProgressIndicatorThemeData(
          color: Colors.white, // Change the default progress indicator color
        ),
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.red,
          primary: Colors.amber,
        ),
        fontFamily: GoogleFonts.poppins().fontFamily,
      ),
      home: SplashScreen(),
    );
  }
}
