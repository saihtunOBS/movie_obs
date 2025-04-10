import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:movie_obs/screens/home/home_screen.dart';
import 'package:movie_obs/screens/movie/movie_screen.dart';
import 'package:movie_obs/screens/profile/profile_screen.dart';
import 'package:movie_obs/screens/series/series_screen.dart';
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
    return PersistentTabView(
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
    );
  }
}

List<PersistentBottomNavBarItem> _navBarsItems() {
  return [
    PersistentBottomNavBarItem(
      icon: Image.asset(kHomeFillIcon),
      inactiveIcon: Image.asset(kHomeIcon),
      title: ("Home"),
      activeColorPrimary: Colors.black,
      inactiveColorPrimary: Colors.black,
    ),
    PersistentBottomNavBarItem(
      icon: Image.asset(kMovieFillIcon),
      inactiveIcon: Image.asset(kMovieIcon),
      title: ("Movies"),
      activeColorPrimary: Colors.black,
      inactiveColorPrimary: Colors.black,
    ),
    PersistentBottomNavBarItem(
      icon: Image.asset(kSeriesFillIcon),
      inactiveIcon: Image.asset(kSeriesIcon),
      title: ("Series"),
      activeColorPrimary: Colors.black,
      inactiveColorPrimary: Colors.black,
    ),
    PersistentBottomNavBarItem(
      icon: Icon(CupertinoIcons.person_fill),
      inactiveIcon: Icon(CupertinoIcons.person),
      title: ("Profile"),
      activeColorPrimary: Colors.black,
      inactiveColorPrimary: Colors.black,
    ),
  ];
}
