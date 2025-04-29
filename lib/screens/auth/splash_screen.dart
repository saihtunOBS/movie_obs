import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:movie_obs/extension/page_navigator.dart';
import 'package:movie_obs/screens/auth/ads_screen.dart';
import 'package:movie_obs/utils/images.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

    Future.delayed(Duration(milliseconds: 1500), () {
      // ignore: use_build_context_synchronously
      PageNavigator(ctx: context).nextPageOnly(page: AdsScreen());
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Column(
          spacing: 15,
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(kAppIcon, width: 70, height: 70),
            Text(
              "Tuu Tu TV",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
