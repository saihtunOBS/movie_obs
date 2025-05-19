import 'package:flutter/material.dart';
import 'package:movie_obs/bloc/user_bloc.dart';
import 'package:movie_obs/data/model/movie_model.dart';
import 'package:movie_obs/data/model/movie_model_impl.dart';
import 'package:movie_obs/data/persistence/persistence_data.dart';
import 'package:movie_obs/data/vos/genre_vo.dart';
import 'package:movie_obs/data/vos/watchlist_history_vo.dart';
import 'package:movie_obs/network/responses/watchlist_history_response.dart';

class WatchlistBloc extends ChangeNotifier {
  bool isLoading = false;
  bool isDisposed = false;
  String token = '';
  WatchlistHistoryResponse? watchListData;
  final MovieModel _movieModel = MovieModelImpl();
  String id = '';
  List<GenreVO> genreLists = [];
  List<WatchlistHistoryVo> filteredSuggestions = [];

  WatchlistBloc({BuildContext? context}) {
    token = PersistenceData.shared.getToken();
    getWatchList();
  }

  getWatchList() {
    _showLoading();
    _movieModel
        .getWatchlist(
          token,
          '',
          '',
          'BOTH',
          false,
          userDataListener.value.id ?? '',1
        )
        .then((response) {
          watchListData = response;
          notifyListeners();
        })
        .whenComplete(() {
          _hideLoading();
        });
  }

  void clearFilter() {
    filteredSuggestions.clear();
    notifyListeners();
  }

  void onSearchChanged(String value) {
    notifyListeners();
    if (value.isEmpty) {
      filteredSuggestions.clear();
      return;
    }
    filteredSuggestions =
        watchListData?.data
            ?.where(
              (item) => item.reference!.name!.toLowerCase().contains(
                value.toLowerCase(),
              ),
            )
            .toList() ??
        [];

    notifyListeners();
  }

  filter(String plan, String genre, String contentType) async {
    _showLoading();
    await _movieModel
        .getWatchlist(
          token,
          plan,
          genre,
          contentType,
          true,
          userDataListener.value.id ?? '',1
        )
        .then((response) {
          watchListData = response;
          _hideLoading();
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
