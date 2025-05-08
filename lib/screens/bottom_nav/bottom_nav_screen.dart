import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:movie_obs/bloc/user_bloc.dart';
import 'package:movie_obs/data/persistence/persistence_data.dart';
import 'package:movie_obs/screens/home/home_screen.dart';
import 'package:movie_obs/screens/movie/movie_screen.dart';
import 'package:movie_obs/screens/profile/profile_screen.dart';
import 'package:movie_obs/screens/series/series_screen.dart';
import 'package:movie_obs/utils/colors.dart';
import 'package:movie_obs/utils/dimens.dart';
import 'package:movie_obs/utils/images.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

final ValueNotifier<bool> tab = ValueNotifier(true);

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
    context.read<UserBloc>().updateToken();
    context.read<UserBloc>().getUser(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: tab,
      builder:
          (context, value, child) => PersistentTabView(
            backgroundColor: Colors.transparent,
            context,
            isVisible: value,
            screens: screens,
            navBarStyle: NavBarStyle.style9,
            items: _navBarsItems(context),
            onItemSelected: (value) {
              if (value == 3) {
                context.read<UserBloc>().updateToken();
                context.read<UserBloc>().getUser(context);
              }
            },
          ),
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
      textStyle:
          PersistenceData.shared.getLocale() != 'en'
              ? GoogleFonts.padauk(fontWeight: FontWeight.w600)
              : GoogleFonts.poppins(fontSize: kTextSmall),
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
      textStyle:
          PersistenceData.shared.getLocale() != 'en'
              ? GoogleFonts.padauk(fontWeight: FontWeight.w600)
              : GoogleFonts.poppins(fontSize: kTextSmall),
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
