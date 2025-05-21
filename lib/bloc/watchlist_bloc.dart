import 'package:flutter/material.dart';
import 'package:movie_obs/bloc/user_bloc.dart';
import 'package:movie_obs/data/model/movie_model.dart';
import 'package:movie_obs/data/model/movie_model_impl.dart';
import 'package:movie_obs/data/persistence/persistence_data.dart';
import 'package:movie_obs/data/vos/genre_vo.dart';
import 'package:movie_obs/data/vos/watchlist_history_vo.dart';

class WatchlistBloc extends ChangeNotifier {
  bool isLoading = false;
  bool isDisposed = false;
  String token = '';
  List<WatchlistHistoryVo> watchLists = [];
  final MovieModel _movieModel = MovieModelImpl();
  String id = '';
  List<GenreVO> genreLists = [];
  List<WatchlistHistoryVo> filteredSuggestions = [];

  bool isLoadMore = false;
  int page = 1;
  String moviePlan = '';
  String movieGenre = '';
  String movieContentType = '';

  WatchlistBloc({BuildContext? context}) {
    token = PersistenceData.shared.getToken();
    getWatchList();
  }

  getWatchList() {
    page = 1;
    moviePlan = '';
    movieGenre = '';
    movieContentType = '';
    _showLoading();
    _movieModel
        .getWatchlist(
          token,
          '',
          '',
          'BOTH',
          false,
          userDataListener.value.id ?? '',
          1,
        )
        .then((response) {
          watchLists = response.data ?? [];
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
        .getWatchlist(
          token,
          moviePlan,
          movieGenre,
          movieContentType,
          false,
          userDataListener.value.id ?? '',
          page,
        )
        .then((response) => watchLists.addAll(response.data ?? []))
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
        watchLists
            .where(
              (item) => item.reference!.name!.toLowerCase().contains(
                value.toLowerCase(),
              ),
            )
            .toList();

    notifyListeners();
  }

  filter(String plan, String genre, String contentType) async {
    moviePlan = plan;
    movieGenre = genre;
    movieContentType = contentType;
    _showLoading();
    await _movieModel
        .getWatchlist(
          token,
          plan,
          genre,
          contentType,
          true,
          userDataListener.value.id ?? '',
          1,
        )
        .then((response) {
          watchLists = response.data ?? [];
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
