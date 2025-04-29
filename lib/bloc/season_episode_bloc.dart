import 'package:flutter/material.dart';
import 'package:movie_obs/data/model/movie_model.dart';
import 'package:movie_obs/data/model/movie_model_impl.dart';
import 'package:movie_obs/data/persistence/persistence_data.dart';
import 'package:movie_obs/network/responses/season_episode_response.dart';

class SeasonEpisodeBloc extends ChangeNotifier {
  bool isLoading = false;
  bool isDisposed = false;
  String token = '';
  SeasonEpisodeResponse? seasonEpisodeResponse;

  String seasonId = '';

  final MovieModel _movieModel = MovieModelImpl();

  SeasonEpisodeBloc(id) {
    seasonId = id;
    token = PersistenceData.shared.getToken();
    getSeasonEpisode();
  }

  getSeasonEpisode() {
    _movieModel.getSeasonEpisode(seasonId).then((response) {
      seasonEpisodeResponse = response;
      print(seasonEpisodeResponse?.actors?.length);
      notifyListeners();
    });
  }

  @override
  void dispose() {
    super.dispose();
    isDisposed = true;
  }
}
