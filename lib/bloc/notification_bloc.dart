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

  NotificationBloc(BuildContext context) {
    token = PersistenceData.shared.getToken();
    getNotifications(context);
  }

  getNotifications(BuildContext myContext) {
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
          PageNavigator(ctx: myContext).nextPage(page: LoginScreen());
        });
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
