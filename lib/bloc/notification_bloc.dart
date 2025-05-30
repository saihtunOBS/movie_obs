import 'package:flutter/material.dart';
import 'package:movie_obs/data/model/movie_model.dart';
import 'package:movie_obs/data/model/movie_model_impl.dart';
import 'package:movie_obs/data/persistence/persistence_data.dart';
import 'package:movie_obs/data/vos/notification_vo.dart';

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

  Future<void> getNotifications() {
    _showLoading();
    return _movieModel
        .getNotifications(token)
        .then((response) {
          notiLists = response.data ?? [];
          notifyListeners();
        })
        .whenComplete(() {
          _hideLoading();
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
