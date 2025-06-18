import 'package:flutter/material.dart';
import 'package:movie_obs/data/model/movie_model.dart';
import 'package:movie_obs/data/model/movie_model_impl.dart';
import 'package:movie_obs/data/persistence/persistence_data.dart';
import 'package:movie_obs/data/vos/season_vo.dart';
import 'package:movie_obs/network/responses/movie_detail_response.dart';
import 'package:movie_obs/network/responses/season_episode_response.dart';

import '../data/vos/movie_vo.dart';
import '../network/requests/history_request.dart';
import '../network/requests/watchlist_request.dart';
import '../widgets/toast_service.dart';
import 'user_bloc.dart';

class SeriesDetailBloc extends ChangeNotifier {
  bool isLoading = false;
  bool isDisposed = false;
  String token = '';
  MovieDetailResponse? seriesResponse;
  List<SeasonVO> seasons = [];
  List<MovieVO>? recommendedList;
  SeasonEpisodeResponse? seasonEpisodeResponse;
  BuildContext? myContext;
  String seriesId = '';

  final MovieModel _movieModel = MovieModelImpl();

  SeriesDetailBloc(id, context) {
    myContext = context;
    seriesId = id;
    token = PersistenceData.shared.getToken();
    getSeriesDetail();
    getRecommendedSeries();
  }

  getSeriesDetail() {
    _showLoading();
    _movieModel
        .getSeriesDetail(token, seriesId, true)
        .then((response) {
          seriesResponse = response;

          _hideLoading();
        })
        .catchError((error) {
          ToastService.warningToast(error.toString());
          _hideLoading();
        });
  }

  getSeason() {
    _movieModel.getSeason(token).then((response) {
      seasons = response.data ?? [];
      notifyListeners();
    });
  }

  getRecommendedSeries() {
    _movieModel.getRecommendedSeries(seriesId).then((response) {
      recommendedList = response;
      notifyListeners();
    });
  }

  toggleWatchlist() {
    _showLoading();
    var request = WatchlistRequest(
      userDataListener.value.id ?? '',
      seriesId,
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
    _showLoading();
    var request = HistoryRequest(
      userDataListener.value.id ?? '',
      seriesId,
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
