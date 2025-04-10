import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';

class PageNavigator {
  BuildContext? ctx;
  PageNavigator({required this.ctx});

  //navigate to next page
  Future nextPage({required Widget? page, bool withNav = false}) {
    return PersistentNavBarNavigator.pushNewScreen(
      ctx!,
      screen: page!,
      withNavBar: withNav,
      pageTransitionAnimation: PageTransitionAnimation.fade,
    );
  }

  Future nextPageOnly({Widget? page}) {
    return Navigator.pushAndRemoveUntil(
      ctx!,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => page!,
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(opacity: animation, child: child);
        },
        transitionDuration: const Duration(milliseconds: 500),
      ),
      (route) => false,
    );
  }

  Route popUp(Widget? page) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => page!,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(0.0, 1.0);
        const end = Offset.zero;
        const curve = Curves.fastOutSlowIn;

        final tween = Tween(begin: begin, end: end);
        final curvedAnimation = CurvedAnimation(
          parent: animation,
          curve: curve,
        );

        return SlideTransition(
          position: tween.animate(curvedAnimation),
          child: child,
        );
      },
    );
  }
}

Route createRoute(Widget page, {int? duration}) {
  return PageRouteBuilder(
    transitionDuration: Duration(milliseconds: duration ?? 900),
    pageBuilder: (context, animation, secondaryAnimation) => page,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      return FadeTransition(opacity: animation, child: child);
    },
  );
}
