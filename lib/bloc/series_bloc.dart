import 'package:flutter/material.dart';
import 'package:movie_obs/data/model/movie_model.dart';
import 'package:movie_obs/data/model/movie_model_impl.dart';
import 'package:movie_obs/data/persistence/persistence_data.dart';
import 'package:movie_obs/data/vos/movie_vo.dart';

class SeriesBloc extends ChangeNotifier {
  bool isLoading = false;
  bool isDisposed = false;
  String token = '';
  List<MovieVO> seriesLists = [];
  List<MovieVO> allSeriesLists = [];
  List<MovieVO> filteredSuggestions = [];
  bool isLoadMore = false;
  int page = 1;
  String moviePlan = '';
  String movieGenre = '';

  final MovieModel _movieModel = MovieModelImpl();

  SeriesBloc() {
    token = PersistenceData.shared.getToken();
    getSeriesByPage();
    getAllSeries();
  }

  getSeriesByPage() {
    moviePlan = '';
    movieGenre = '';
    page = 1;
    _showLoading();
    _movieModel.getSeriesLists(token, '', '', false, 1).then((response) {
      seriesLists = response.data ?? [];
      _hideLoading();
    });
  }

  getAllSeries() {
    _showLoading();
    _movieModel.getSeriesLists(token, '', '', true, 0).then((response) {
      allSeriesLists = response.data ?? [];
      _hideLoading();
    });
  }

  filterSeries(String plan, String genre) async {
    moviePlan = plan;
    movieGenre = genre;
    _showLoading();
    await _movieModel
        .getSeriesLists(token, plan, genre, false, 1)
        .then((response) {
          seriesLists = response.data ?? [];
        })
        .whenComplete(() {
          _hideLoading();
        });
  }

  clearFilter() {
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
        allSeriesLists
            .where(
              (item) => item.name!.toLowerCase().contains(value.toLowerCase()),
            )
            .toList();
    notifyListeners();
  }

  loadMoreData() {
    if (isLoadMore) return;
    _showLoadMoreLoading();
    page += 1;
    _movieModel
        .getSeriesLists(token, moviePlan, movieGenre, false, page)
        .then((response) => seriesLists.addAll(response.data ?? []))
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
