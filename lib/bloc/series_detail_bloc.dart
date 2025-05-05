import 'package:flutter/material.dart';
import 'package:movie_obs/data/model/movie_model.dart';
import 'package:movie_obs/data/model/movie_model_impl.dart';
import 'package:movie_obs/data/persistence/persistence_data.dart';
import 'package:movie_obs/data/vos/season_vo.dart';
import 'package:movie_obs/network/responses/movie_detail_response.dart';
import 'package:movie_obs/network/responses/season_episode_response.dart';

import '../data/vos/movie_vo.dart';

class SeriesDetailBloc extends ChangeNotifier {
  bool isLoading = false;
  bool isDisposed = false;
  String token = '';
  MovieDetailResponse? seriesResponse;
  List<SeasonVO> seasons = [];
  List<MovieVO>? recommendedList;
  SeasonEpisodeResponse? seasonEpisodeResponse;

  String movieId = '';

  final MovieModel _movieModel = MovieModelImpl();

  SeriesDetailBloc() {
    // movieId = id;
    token = PersistenceData.shared.getToken();
    // getSeriesDetail();
    // getRecommendedSeries();
  }

  getSeriesDetail() {
    _movieModel.getSeriesDetail(token, movieId, true).then((response) {
      seriesResponse = response;

      notifyListeners();
    });
  }

  getSeason() {
    _movieModel.getSeason(token).then((response) {
      seasons = response.data ?? [];
      notifyListeners();
    });
  }

  getRecommendedSeries() {
    _movieModel.getRecommendedSeries(movieId).then((response) {
      recommendedList = response;
      notifyListeners();
    });
  }

  @override
  void dispose() {
    super.dispose();
    isDisposed = true;
  }
}
