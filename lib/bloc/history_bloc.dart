import 'package:flutter/material.dart';
import 'package:movie_obs/bloc/user_bloc.dart';
import 'package:movie_obs/data/model/movie_model.dart';
import 'package:movie_obs/data/model/movie_model_impl.dart';
import 'package:movie_obs/data/persistence/persistence_data.dart';
import 'package:movie_obs/data/vos/genre_vo.dart';
import 'package:movie_obs/data/vos/watchlist_history_vo.dart';

class HistoryBloc extends ChangeNotifier {
  bool isLoading = false;
  bool isDisposed = false;
  String token = '';
  final MovieModel _movieModel = MovieModelImpl();
  String id = '';
  List<WatchlistHistoryVo> historyList = [];
  List<GenreVO> genreLists = [];
  List<WatchlistHistoryVo> filteredSuggestions = [];
  bool isLoadMore = false;
  int page = 1;

  HistoryBloc({BuildContext? context}) {
    token = PersistenceData.shared.getToken();
    getHistory();
  }

  getHistory() {
    page = 1;
    _showLoading();
    _movieModel
        .getHistory(token, false, userDataListener.value.id ?? '', 1)
        .then((response) {
          historyList = response.data ?? [];
          notifyListeners();
        })
        .whenComplete(() {
          _hideLoading();
        });
  }

  loadMoreData() {
    if (isLoadMore) return;
    _showLoadMoreLoading();
    page += 1;

    _movieModel
        .getHistory(token, false, userDataListener.value.id ?? '', page)
        .then((response) => historyList.addAll(response.data ?? []))
        .whenComplete(() => _hideLoadMoreLoading());
  }

  _showLoadMoreLoading() {
    isLoadMore = true;
    _notifySafely();
  }

  _hideLoadMoreLoading() {
    isLoadMore = false;
    _notifySafely();
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
