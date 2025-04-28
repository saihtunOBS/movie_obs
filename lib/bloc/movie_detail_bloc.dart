import 'package:flutter/material.dart';
import 'package:movie_obs/data/model/movie_model.dart';
import 'package:movie_obs/data/model/movie_model_impl.dart';
import 'package:movie_obs/data/persistence/persistence_data.dart';
import 'package:movie_obs/network/responses/movie_detail_response.dart';

class MovieDetailBloc extends ChangeNotifier {
  bool isLoading = false;
  bool isDisposed = false;
  String token = '';
  MovieDetailResponse? moviesResponse;

  String movieId = '';

  final MovieModel _movieModel = MovieModelImpl();

  MovieDetailBloc(id) {
    movieId = id;
    token = PersistenceData.shared.getToken();
    getMovieDetail();
  }

  getMovieDetail() {
    _movieModel.getMovieDetail(token, movieId).then((response) {
      moviesResponse = response;
      notifyListeners();
    });
  }

  @override
  void dispose() {
    super.dispose();
    isDisposed = true;
  }
}
