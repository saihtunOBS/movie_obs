import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:movie_obs/data/persistence/persistence_data.dart';
import 'package:movie_obs/screens/home/home_screen.dart';
import 'package:movie_obs/screens/movie/movie_screen.dart';
import 'package:movie_obs/screens/profile/profile_screen.dart';
import 'package:movie_obs/screens/series/series_screen.dart';
import 'package:movie_obs/utils/colors.dart';
import 'package:movie_obs/utils/dimens.dart';
import 'package:movie_obs/utils/images.dart';
import 'package:movie_obs/widgets/banner_image_animation.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
          items: _navBarsItems(context),
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
          child: Image.asset(kBottomShadowImage, fit: BoxFit.contain),
        ),
      ],
    );
  }
}

List<PersistentBottomNavBarItem> _navBarsItems(BuildContext context) {
  return [
    PersistentBottomNavBarItem(
      icon: Image.asset(kHomeFillIcon, color: kSecondaryColor),
      inactiveIcon: Image.asset(kHomeIcon, color: kWhiteColor),
      title: (AppLocalizations.of(context)?.home ?? ''),
      activeColorPrimary: kWhiteColor,
      textStyle:
          PersistenceData.shared.getLocale() != 'en'
              ? GoogleFonts.padauk(fontWeight: FontWeight.w600)
              : GoogleFonts.poppins(fontSize: kTextSmall),
    ),
    PersistentBottomNavBarItem(
      icon: Image.asset(kMovieFillIcon, color: kSecondaryColor),
      inactiveIcon: Image.asset(kMovieIcon, color: kWhiteColor),
      title: (AppLocalizations.of(context)?.movies ?? ''),
      activeColorPrimary: kWhiteColor,
      textStyle:
          PersistenceData.shared.getLocale() != 'en'
              ? GoogleFonts.padauk(fontWeight: FontWeight.w600)
              : GoogleFonts.poppins(fontSize: kTextSmall),
    ),
    PersistentBottomNavBarItem(
      icon: Image.asset(kSeriesFillIcon, color: kSecondaryColor),
      inactiveIcon: Image.asset(kSeriesIcon, color: kWhiteColor),
      title: (AppLocalizations.of(context)?.series ?? ''),
      activeColorPrimary: kWhiteColor,
      textStyle:
          PersistenceData.shared.getLocale() != 'en'
              ? GoogleFonts.padauk(fontWeight: FontWeight.w600)
              : GoogleFonts.poppins(fontSize: kTextSmall),
    ),
    PersistentBottomNavBarItem(
      icon: Icon(CupertinoIcons.person_fill, color: kSecondaryColor),
      inactiveIcon: Icon(CupertinoIcons.person, color: kWhiteColor),
      title: (AppLocalizations.of(context)?.profile ?? ''),
      activeColorPrimary: kWhiteColor,
      textStyle:
          PersistenceData.shared.getLocale() != 'en'
              ? GoogleFonts.padauk(fontWeight: FontWeight.w600)
              : GoogleFonts.poppins(fontSize: kTextSmall),
    ),
  ];
}
