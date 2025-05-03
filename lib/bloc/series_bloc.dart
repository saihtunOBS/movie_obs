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

  List<MovieVO> filteredSuggestions = [];

  final MovieModel _movieModel = MovieModelImpl();

  SeriesBloc() {
    token = PersistenceData.shared.getToken();
    getAllSeries();
  }

  getAllSeries() {
    _showLoading();
    _movieModel.getSeriesLists(token, '').then((response) {
      seriesLists = response.data ?? [];
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
        seriesLists
            .where(
              (item) => item.name!.toLowerCase().contains(value.toLowerCase()),
            )
            .toList();
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
