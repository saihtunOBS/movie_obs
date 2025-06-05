import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:movie_obs/bloc/home_bloc.dart';
import 'package:movie_obs/bloc/notification_bloc.dart';
import 'package:movie_obs/bloc/user_bloc.dart';
import 'package:movie_obs/data/persistence/persistence_data.dart';
import 'package:movie_obs/screens/home/home_screen.dart';
import 'package:movie_obs/screens/movie/movie_screen.dart';
import 'package:movie_obs/screens/profile/profile_screen.dart';
import 'package:movie_obs/screens/series/series_screen.dart';
import 'package:movie_obs/screens/video_player.dart/video_player_screen.dart';
import 'package:movie_obs/utils/colors.dart';
import 'package:movie_obs/utils/images.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';
import 'package:movie_obs/l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:screen_brightness/screen_brightness.dart';
import 'package:volume_controller/volume_controller.dart';

final ValueNotifier<bool> tab = ValueNotifier(true);
VolumeController? volumeController;
StreamSubscription<double>? _subscription;

class BottomNavScreen extends StatefulWidget {
  const BottomNavScreen({super.key});

  @override
  State<BottomNavScreen> createState() => _BottomNavScreenState();
}
//hello

class _BottomNavScreenState extends State<BottomNavScreen> {
  List<Widget> screens = [
    HomeScreen(),
    MovieScreen(),
    SeriesScreen(),
    ProfileScreen(),
  ];

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<UserBloc>().updateToken();
      context.read<UserBloc>().getUser(context);
      context.read<NotificationBloc>().updateToken();
      context.read<HomeBloc>().updateToken();
      PersistenceData.shared.saveFirstTime(false);
    });
    volumeController = VolumeController.instance;

    // Listen to system volume change
    _subscription = volumeController?.addListener((volume) {
      setState(() => deviceVolume = volume);
    }, fetchInitialVolume: true);
    super.initState();
  }

  @override
  void dispose() {
    _subscription?.cancel();
    volumeController?.removeListener();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<double>(
      stream: ScreenBrightness.instance.onSystemScreenBrightnessChanged,
      builder: (context, snapshot) {
        //brightness = snapshot.data ?? 1.0;
        return ValueListenableBuilder(
          valueListenable: tab,
          builder:
              (context, value, child) => PersistentTabView(
                backgroundColor: Colors.transparent,
                context,
                isVisible: value,
                screens: screens,
                handleAndroidBackButtonPress: false,
                navBarStyle: NavBarStyle.style9,
                padding: EdgeInsets.all(10),
                items: _navBarsItems(context),
                onItemSelected: (value) {
                  if (value == 3) {
                    context.read<UserBloc>().updateToken();
                    context.read<UserBloc>().getUser(context);
                  }
                },
              ),
        );
      },
    );
  }
}

List<PersistentBottomNavBarItem> _navBarsItems(BuildContext context) {
  return [
    PersistentBottomNavBarItem(
      icon: Image.asset(
        kHomeFillIcon,
        color: kSecondaryColor,
        width: 25,
        height: 25,
      ),
      inactiveIcon: Image.asset(
        kHomeIcon,
        color: kWhiteColor,
        width: 25,
        height: 25,
      ),
      title: (AppLocalizations.of(context)?.home ?? ''),
      activeColorPrimary: kWhiteColor,
    ),
    PersistentBottomNavBarItem(
      icon: Image.asset(
        kMovieFillIcon,
        color: kSecondaryColor,
        width: 25,
        height: 25,
      ),
      inactiveIcon: Image.asset(
        kMovieIcon,
        color: kWhiteColor,
        width: 25,
        height: 25,
      ),
      title: (AppLocalizations.of(context)?.movies ?? ''),
      activeColorPrimary: kWhiteColor,
    ),
    PersistentBottomNavBarItem(
      icon: Image.asset(
        kSeriesFillIcon,
        color: kSecondaryColor,
        width: 25,
        height: 25,
      ),
      inactiveIcon: Image.asset(
        kSeriesIcon,
        color: kWhiteColor,
        width: 25,
        height: 25,
      ),
      title: (AppLocalizations.of(context)?.series_nav ?? ''),
      activeColorPrimary: kWhiteColor,
    ),
    PersistentBottomNavBarItem(
      icon: Icon(CupertinoIcons.person_fill, color: kSecondaryColor),
      inactiveIcon: Icon(CupertinoIcons.person, color: kWhiteColor),
      title: (AppLocalizations.of(context)?.profile ?? ''),
      activeColorPrimary: kWhiteColor,
    ),
  ];
}
