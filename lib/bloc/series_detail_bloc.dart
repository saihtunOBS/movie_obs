import 'package:flutter/material.dart';
import 'package:movie_obs/data/model/movie_model.dart';
import 'package:movie_obs/data/model/movie_model_impl.dart';
import 'package:movie_obs/data/persistence/persistence_data.dart';
import 'package:movie_obs/data/vos/season_vo.dart';
import 'package:movie_obs/network/responses/movie_detail_response.dart';

class SeriesDetailBloc extends ChangeNotifier {
  bool isLoading = false;
  bool isDisposed = false;
  String token = '';
  MovieDetailResponse? seriesResponse;
  List<SeasonVO> seasons = [];

  String movieId = '';

  final MovieModel _movieModel = MovieModelImpl();

  SeriesDetailBloc(id) {
    movieId = id;
    token = PersistenceData.shared.getToken();
    getSeriesDetail();
    getSeason();
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

  @override
  void dispose() {
    super.dispose();
    isDisposed = true;
  }
}
