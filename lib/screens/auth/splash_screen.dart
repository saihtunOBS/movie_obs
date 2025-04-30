import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:movie_obs/extension/page_navigator.dart';
import 'package:movie_obs/screens/auth/ads_screen.dart';
import 'package:movie_obs/utils/colors.dart';
import 'package:movie_obs/utils/images.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _offsetAnimation;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();

    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 1500),
    );

    _offsetAnimation = Tween<Offset>(
      begin: Offset(0.0, -1.5),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    _opacityAnimation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeIn));

    _controller.forward(); // Start animation

    Future.delayed(Duration(milliseconds: 2500), () {
      PageNavigator(ctx: context).nextPageOnly(page: AdsScreen());
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(kAppIcon, width: 90, height: 90),
            const SizedBox(height: 10),
            SlideTransition(
              position: _offsetAnimation,
              child: FadeTransition(
                opacity: _opacityAnimation,
                child: Text(
                  "Tuu Tu TV",
                  style: TextStyle(
                    fontSize: 23,
                    fontWeight: FontWeight.bold,
                    color: kPrimaryColor,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
