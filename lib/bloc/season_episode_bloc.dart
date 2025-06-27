import 'package:flutter/material.dart';
import 'package:movie_obs/bloc/user_bloc.dart';
import 'package:movie_obs/data/model/movie_model.dart';
import 'package:movie_obs/data/model/movie_model_impl.dart';
import 'package:movie_obs/data/persistence/persistence_data.dart';
import 'package:movie_obs/network/responses/season_episode_response.dart';

import '../network/requests/watchlist_request.dart' show WatchlistRequest;
import '../network/responses/movie_detail_response.dart';
import '../widgets/toast_service.dart';

class SeasonEpisodeBloc extends ChangeNotifier {
  bool isLoading = false;
  bool isDisposed = false;
  String token = '';
  int selectedIndex = -1;
  SeasonEpisodeResponse? seasonEpisodeResponse;

  List<ActorVO> castsLists = [];
  String seasonId = '';
  String seriesID = '';
  MovieDetailResponse? seriesDetailResponse;

  final MovieModel _movieModel = MovieModelImpl();

  SeasonEpisodeBloc(id, MovieDetailResponse seriesDetail, {seriesId}) {
    seriesID = seriesId;
    seasonId = id;
    seriesDetailResponse = seriesDetail;
    token = PersistenceData.shared.getToken();
    getSeasonEpisode();
  }

  getSeasonEpisode() {
    _showLoading();
    _movieModel
        .getSeasonEpisode(token, seasonId)
        .then((response) {
          seasonEpisodeResponse = response;
          final combinedCasts = <ActorVO>[
            ...(response.actors ?? []),
            ...(response.actresses ?? []),
            ...(response.supports ?? []),
          ];

          castsLists.addAll(combinedCasts);
          _hideLoading();
        })
        .catchError((_) {
          _hideLoading();
        });
  }

  onSelectEpisode(int index) {
    selectedIndex = index;
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

  toggleWatchlist() {
    final current = seriesDetailResponse?.isWatchlist ?? false;
    seriesDetailResponse?.isWatchlist = !current;
    var request = WatchlistRequest(
      userDataListener.value.id ?? '',
      seriesDetailResponse?.id ?? '',
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
}
