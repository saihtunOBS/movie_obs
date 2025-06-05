import 'package:flutter/cupertino.dart';
import 'package:movie_obs/data/model/movie_model.dart';
import 'package:movie_obs/data/model/movie_model_impl.dart';
import 'package:movie_obs/data/persistence/persistence_data.dart';
import 'package:movie_obs/data/vos/episode_vo.dart';
import 'package:movie_obs/network/responses/season_episode_response.dart';

class EpisodeBloc extends ChangeNotifier {
  EpisodeVO? currentEpisode;
  SeasonEpisodeResponse? seasonEpisodeResponse;
  String token = '';
  bool isLoading = false;
  bool isDisposed = false;
  String seasonId = '';
  final MovieModel _movieModel = MovieModelImpl();

  EpisodeBloc(EpisodeVO episode, String id) {
    seasonId = id;
    currentEpisode = episode;
    token = PersistenceData.shared.getToken();
    getSeasonEpisode();
  }

  changeEpisode(EpisodeVO newEpisode) {
    currentEpisode = newEpisode;
    notifyListeners();
  }

  getSeasonEpisode() async {
    _showLoading();
    await _movieModel
        .getSeasonEpisode(token, seasonId)
        .then((response) {
          seasonEpisodeResponse = response;
          print(seasonEpisodeResponse?.episodes?.length);
          final episodeList = seasonEpisodeResponse?.episodes ?? [];
          final matchedEpisode = episodeList.firstWhere(
            (e) => e.id == currentEpisode?.id,
            orElse: () => currentEpisode ?? EpisodeVO(),
          );
          currentEpisode = matchedEpisode;
          _hideLoading();
        })
        .catchError((_) {
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
