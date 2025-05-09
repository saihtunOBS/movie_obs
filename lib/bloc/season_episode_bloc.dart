import 'package:flutter/material.dart';
import 'package:movie_obs/bloc/user_bloc.dart';
import 'package:movie_obs/data/model/movie_model.dart';
import 'package:movie_obs/data/model/movie_model_impl.dart';
import 'package:movie_obs/data/persistence/persistence_data.dart';
import 'package:movie_obs/network/responses/season_episode_response.dart';

import '../network/requests/watchlist_request.dart' show WatchlistRequest;
import '../widgets/toast_service.dart';

class SeasonEpisodeBloc extends ChangeNotifier {
  bool isLoading = false;
  bool isDisposed = false;
  String token = '';
  SeasonEpisodeResponse? seasonEpisodeResponse;

  String seasonId = '';
  String seriesID = '';

  final MovieModel _movieModel = MovieModelImpl();

  SeasonEpisodeBloc(id, {seriesId}) {
    seriesID = seriesId;
    seasonId = id;
    token = PersistenceData.shared.getToken();
    getSeasonEpisode();
  }

  getSeasonEpisode() {
    _movieModel.getSeasonEpisode(seasonId).then((response) {
      seasonEpisodeResponse = response;
      notifyListeners();
    });
  }

  toggleWatchlist() {
    var request = WatchlistRequest(
      userDataListener.value.id ?? '',
      seriesID,
      'SERIES',
    );
    _movieModel
        .toggleWatchlist(token, request)
        .then((_) {
          ToastService.successToast('Success');
        })
        .whenComplete(() {})
        .catchError((error) {
          ToastService.warningToast(error.toString());
        });
  }

  @override
  void dispose() {
    super.dispose();
    isDisposed = true;
  }
}
