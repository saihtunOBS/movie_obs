import 'package:flutter/material.dart';
import 'package:movie_obs/bloc/user_bloc.dart';
import 'package:movie_obs/data/model/movie_model.dart';
import 'package:movie_obs/data/model/movie_model_impl.dart';
import 'package:movie_obs/data/persistence/persistence_data.dart';
import 'package:movie_obs/data/vos/movie_vo.dart' show MovieVO;
import 'package:movie_obs/network/requests/history_request.dart';
import 'package:movie_obs/network/requests/watchlist_request.dart';
import 'package:movie_obs/network/responses/movie_detail_response.dart';
import 'package:movie_obs/widgets/toast_service.dart';

class MovieDetailBloc extends ChangeNotifier {
  bool isLoading = false;
  bool isDisposed = false;
  String token = '';
  MovieDetailResponse? moviesResponse;
  List<MovieVO>? recommendedList;

  String movieId = '';

  final MovieModel _movieModel = MovieModelImpl();

  MovieDetailBloc(id) {
    movieId = id;
    token = PersistenceData.shared.getToken();
    getMovieDetail();
    getRecommendedMovie();
    //toggleHistory();
  }

  getMovieDetail() {
    _movieModel.getMovieDetail(token, movieId).then((response) {
      moviesResponse = response;
      notifyListeners();
    });
  }

  toggleWatchlist() {
    _showLoading();
    var request = WatchlistRequest(
      userDataListener.value.id ?? '',
      movieId,
      'MOVIE',
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

  toggleHistory() {
    var request = HistoryRequest(
      userDataListener.value.id ?? '',
      movieId,
      0,
      'MOVIE',
    );
    _movieModel
        .toggleHistory(token, request)
        .then((_) {
          ToastService.successToast('Success');
        })
        .whenComplete(() {
          _hideLoading();
        })
        .catchError((error) {
          _hideLoading();
          //ToastService.warningToast(error.toString());
        });
  }

  getRecommendedMovie() {
    _movieModel.getRecommendedMovie(movieId).then((response) {
      recommendedList = response;
      notifyListeners();
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
