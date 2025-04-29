import 'package:flutter/material.dart';
import 'package:movie_obs/data/model/movie_model.dart';
import 'package:movie_obs/data/model/movie_model_impl.dart';
import 'package:movie_obs/data/persistence/persistence_data.dart';
import 'package:movie_obs/data/vos/movie_vo.dart';

class SearchBloc extends ChangeNotifier {
  bool isLoading = false;
  bool isDisposed = false;
  String token = '';
  List<MovieVO> movieLists = [];
  final MovieModel _movieModel = MovieModelImpl();
  String id = '';

  SearchBloc({BuildContext? context, String? movieId}) {
    id = movieId ?? '';
    token = PersistenceData.shared.getToken();
    getFilterMovie();
  }

  getFilterMovie() {
    _showLoading();
    _movieModel
        .getMovieSeriesByGenre(id)
        .then((response) {
          movieLists = response.data ?? [];
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
