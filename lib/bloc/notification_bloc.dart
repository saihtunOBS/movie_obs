import 'package:flutter/material.dart';
import 'package:movie_obs/data/model/movie_model.dart';
import 'package:movie_obs/data/model/movie_model_impl.dart';
import 'package:movie_obs/data/persistence/persistence_data.dart';
import 'package:movie_obs/data/vos/notification_vo.dart';
import 'package:movie_obs/extension/page_navigator.dart';
import 'package:movie_obs/screens/auth/login_screen.dart';

class NotificationBloc extends ChangeNotifier {
  bool isLoading = false;
  bool isDisposed = false;
  String token = '';
  List<NotificationVo> notiLists = [];
  final MovieModel _movieModel = MovieModelImpl();
  BuildContext? mycontext;
  NotificationBloc({BuildContext? context}) {
    mycontext = context;
    updateToken();
    getNotifications();
  }

  getNotifications() {
    _showLoading();
    _movieModel
        .getNotifications(token)
        .then((response) {
          notiLists = response.data ?? [];
          notifyListeners();
        })
        .whenComplete(() {
          _hideLoading();
        })
        .catchError((_) {
          PersistenceData.shared.clearToken();
          PageNavigator(ctx: mycontext).nextPage(page: LoginScreen());
        });
  }

  void updateToken() {
    token = PersistenceData.shared.getToken();
    notifyListeners();
  }

  _showLoading() {
    isLoading = true;
    _notifySafely();
  }

  _hideLoading() {
    isLoading = false;
    _notifySafely();
  }

  void _notifySafely() {
    if (!isDisposed) {
      notifyListeners();
    }
  }

  @override
  void dispose() {
    super.dispose();
    isDisposed = true;
  }
}
