import 'package:flutter/material.dart';
import 'package:movie_obs/bloc/user_bloc.dart';
import 'package:movie_obs/data/model/movie_model.dart';
import 'package:movie_obs/data/model/movie_model_impl.dart';
import 'package:movie_obs/data/persistence/persistence_data.dart';
import 'package:movie_obs/data/vos/movie_vo.dart' show MovieVO;
import 'package:movie_obs/network/requests/history_request.dart';
import 'package:movie_obs/network/requests/watchlist_request.dart';
import 'package:movie_obs/network/responses/movie_detail_response.dart';
import 'package:movie_obs/widgets/common_dialog.dart';
import 'package:movie_obs/widgets/error_dialog.dart';
import 'package:movie_obs/widgets/toast_service.dart';

class MovieDetailBloc extends ChangeNotifier {
  bool isLoading = false;
  bool isDisposed = false;
  String token = '';
  MovieDetailResponse? moviesResponse;
  List<MovieVO>? recommendedList;
  BuildContext? myContext;
  String movieId = '';
  List<ActorVO> castLists = [];
  final MovieModel _movieModel = MovieModelImpl();

  MovieDetailBloc(id, context) {
    myContext = context;
    movieId = id;
    token = PersistenceData.shared.getToken();
    getMovieDetail();
    getRecommendedMovie();
    //toggleHistory();
  }

  getMovieDetail() {
    _movieModel
        .getMovieDetail(token, movieId)
        .then((response) {
          moviesResponse = response;
          final combinedCasts = <ActorVO>[
            ...(response.actors ?? []),
            ...(response.actresses ?? []),
            ...(response.supports ?? []),
          ];

          castLists.addAll(combinedCasts);

          notifyListeners();
        })
        .catchError((error) {
          showCommonDialog(
            context: myContext!,
            isBarrierDismiss: false,
            dialogWidget: ErrorDialogView(
              errorMessage: 'Session Expired. Please Login Again',
              isLogin: true,
            ),
          );
        })
        .whenComplete(() {
          _hideLoading();
        });
  }

  toggleWatchlist() {
    _showLoading();
    final current = moviesResponse?.isWatchlist ?? false;
    moviesResponse?.isWatchlist = !current;
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
