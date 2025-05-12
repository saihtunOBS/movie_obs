import 'package:flutter/material.dart';
import 'package:movie_obs/bloc/user_bloc.dart';
import 'package:movie_obs/data/model/movie_model.dart';
import 'package:movie_obs/data/model/movie_model_impl.dart';
import 'package:movie_obs/data/persistence/persistence_data.dart';
import 'package:movie_obs/data/vos/movie_vo.dart';

import '../network/requests/watchlist_request.dart';
import '../widgets/toast_service.dart';

class NewReleaseBloc extends ChangeNotifier {
  bool isLoading = false;
  bool isDisposed = false;
  String token = '';

  List<MovieVO> newReleaseMoviesList = [];

  final MovieModel _movieModel = MovieModelImpl();

  NewReleaseBloc({BuildContext? context}) {
    token = PersistenceData.shared.getToken();
    getNewRelease();
  }

  getNewRelease() {
    _showLoading();
    _movieModel
        .getNewRelease(token, '')
        .then((response) {
          newReleaseMoviesList = response.data ?? [];
          notifyListeners();
          _hideLoading();
        })
        .whenComplete(() {
          _hideLoading();
        });
  }

  toggleWatchlist(String type, String id) {
    // _showLoading();
    var request = WatchlistRequest(
      userDataListener.value.id ?? '',
      id,
      type.toUpperCase(),
    );
    _movieModel
        .toggleWatchlist(token, request)
        .then((_) {
          ToastService.successToast('Success');
        })
        .whenComplete(() {
          _hideLoading();
        })
        .catchError((error) {
          _hideLoading();
          ToastService.warningToast(error.toString());
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
