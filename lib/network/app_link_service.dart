import 'package:app_links/app_links.dart' show AppLinks;
import 'package:flutter/cupertino.dart';
import 'package:movie_obs/data/persistence/persistence_data.dart';
import 'package:movie_obs/main.dart';
import 'package:movie_obs/screens/profile/payment_status_screen.dart';

class AppLinkServices {
  static String _code = '';
  static String get code => _code;
  static bool get hasCode => _code.isNotEmpty;
  static void reset() => _code = '';

  static init() async {
    final appLinks = AppLinks();

    // Subscribe to all events (initial link and further)
    appLinks.uriLinkStream.listen((uri) {
      debugPrint('onAppLink: ${uri.pathSegments.first}');
      if (uri.path == '/payment') {
        final status = uri.queryParameters['status']?.toLowerCase();
        if (PersistenceData.shared.getToken() == '') {
          return;
        }

        WidgetsBinding.instance.addPostFrameCallback((_) {
          navigatorKey.currentState?.pushAndRemoveUntil(
            CupertinoPageRoute(
              builder: (_) => PaymentStatusScreen(status: status ?? 'fail'),
              settings: RouteSettings(name: "PaymentStatusScreen"),
            ),
            (route) => false,
          );
        });
      }
    });
  }
}
