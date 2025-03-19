import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:movie_obs/screens/home_page.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: OpenContainer(
          useRootNavigator: true,
          closedElevation: 0.0,
          closedColor: Colors.white,
          openElevation: 0.0,
          closedShape: const RoundedRectangleBorder(),
          openShape: const RoundedRectangleBorder(),
          transitionDuration: const Duration(milliseconds: 400),
          closedBuilder: ((context, action) {
            return GestureDetector(
              onTap: action,
              child: Container(
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.amber,
                ),
                child: Text('Video'),
              ),
            );
          }),
          openBuilder: ((context, action) {
            return HomePage();
          }),
        ),
      ),
    );
  }
}
