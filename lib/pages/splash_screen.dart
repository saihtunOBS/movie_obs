import 'package:dismissible_page/dismissible_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:movie_obs/pages/home_page.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
   SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          spacing: 20,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            InkWell(
              onTap: () {
                context
                    .pushTransparentRoute(
                      HomePage(
                        url:
                            'https://moviedatatesting.s3.ap-southeast-1.amazonaws.com/Movie2/master.m3u8',
                        isFirstTime: true,
                      ),
                    )
                    .whenComplete(() {});
              },
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.amber,
                ),
                child: Text('Play Video'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
