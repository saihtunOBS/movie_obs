import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:movie_obs/screens/home_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  runApp(const MovieOBS());
}

class MovieOBS extends StatelessWidget {
  const MovieOBS({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.red,
          primary: Colors.amber,
        ),
      ),
      home: HomePage(),
    );
  }
}
