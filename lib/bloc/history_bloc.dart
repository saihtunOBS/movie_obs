import 'package:flutter/material.dart';
import 'package:movie_obs/bloc/user_bloc.dart';
import 'package:movie_obs/data/model/movie_model.dart';
import 'package:movie_obs/data/model/movie_model_impl.dart';
import 'package:movie_obs/data/persistence/persistence_data.dart';
import 'package:movie_obs/data/vos/genre_vo.dart';
import 'package:movie_obs/data/vos/watchlist_history_vo.dart';
import 'package:movie_obs/network/responses/watchlist_history_response.dart';

class HistoryBloc extends ChangeNotifier {
  bool isLoading = false;
  bool isDisposed = false;
  String token = '';
  WatchlistHistoryResponse? historyData;
  final MovieModel _movieModel = MovieModelImpl();
  String id = '';
  List<GenreVO> genreLists = [];
  List<WatchlistHistoryVo> filteredSuggestions = [];

  HistoryBloc({BuildContext? context}) {
    token = PersistenceData.shared.getToken();
    getHistory();
  }

  getHistory() {
    _showLoading();
    _movieModel
        .getHistory(token, false, userDataListener.value.id ?? '')
        .then((response) {
          historyData = response;
          notifyListeners();
        })
        .whenComplete(() {
          _hideLoading();
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
