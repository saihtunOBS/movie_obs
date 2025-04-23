import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:movie_obs/screens/home/home_screen.dart';
import 'package:movie_obs/screens/movie/movie_screen.dart';
import 'package:movie_obs/screens/profile/profile_screen.dart';
import 'package:movie_obs/screens/series/series_screen.dart';
import 'package:movie_obs/utils/colors.dart';
import 'package:movie_obs/utils/images.dart';
import 'package:movie_obs/widgets/banner_image_animation.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';

class BottomNavScreen extends StatefulWidget {
  const BottomNavScreen({super.key});

  @override
  State<BottomNavScreen> createState() => _BottomNavScreenState();
}

class _BottomNavScreenState extends State<BottomNavScreen> {
  List<Widget> screens = [
    HomeScreen(),
    MovieScreen(),
    SeriesScreen(),
    ProfileScreen(),
  ];
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        PersistentTabView(
          backgroundColor: Colors.transparent,
          context,
          screens: screens,
          items: _navBarsItems(),
          onItemSelected: (value) {
            if (value != 0) {
              controller.stop();
            } else {
              controller.reset();
            }
          },
        ),
        Positioned(
          bottom: 87,
          left: 0,
          right: 0,
          child: Image.asset(kBottomShadowImage,fit: BoxFit.contain,)
        ),
      ],
    );
  }
}

List<PersistentBottomNavBarItem> _navBarsItems() {
  return [
    PersistentBottomNavBarItem(
      icon: Image.asset(kHomeFillIcon, color: kSecondaryColor),
      inactiveIcon: Image.asset(kHomeIcon, color: kWhiteColor),
      title: ("Home"),
      activeColorPrimary: kWhiteColor,
    ),
    PersistentBottomNavBarItem(
      icon: Image.asset(kMovieFillIcon, color: kSecondaryColor),
      inactiveIcon: Image.asset(kMovieIcon, color: kWhiteColor),
      title: ("Movies"),
      activeColorPrimary: kWhiteColor,
    ),
    PersistentBottomNavBarItem(
      icon: Image.asset(kSeriesFillIcon, color: kSecondaryColor),
      inactiveIcon: Image.asset(kSeriesIcon, color: kWhiteColor),
      title: ("Series"),
      activeColorPrimary: kWhiteColor,
    ),
    PersistentBottomNavBarItem(
      icon: Icon(CupertinoIcons.person_fill, color: kSecondaryColor),
      inactiveIcon: Icon(CupertinoIcons.person, color: kWhiteColor),
      title: ("Profile"),
      activeColorPrimary: kWhiteColor,
    ),
  ];
}
