import 'package:dismissible_page/dismissible_page.dart';
import 'package:flutter/material.dart';
import 'package:movie_obs/bloc/video_bloc.dart';
import 'package:movie_obs/screens/home_page.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with WidgetsBindingObserver {
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.inactive ||
        state == AppLifecycleState.paused) {
      videoPlayerController.pause();
    }
    super.didChangeAppLifecycleState(state);
  }

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    super.initState();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
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
            GestureDetector(
              onTap: () {
                context.pushTransparentRoute(
                  HomePage(
                    isFirstTime: true,
                    url:
                        'https://moviedatatesting.s3.ap-southeast-1.amazonaws.com/Movie2/master.m3u8',
                  ),
                );
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
